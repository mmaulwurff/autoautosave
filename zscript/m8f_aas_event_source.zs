class m8f_aas_event_source : EventHandler
{

  // constants section /////////////////////////////////////////////////////////

  const ticks_in_second = 35;

  // attributes section ////////////////////////////////////////////////////////

  private bool    loading_finished;

  private int     oldActiveCount;
  private int     oldActiveBigCount;
  private int     maxActive;

  private int     old_kill_count;
  private int     old_item_count;
  private int     old_secret_count;

  private vector3 old_pos;

  private int     old_health;
  private int     old_armor;
  private double  old_armor_save;

  private int     seconds_from_last_save;

  private int     autosave_request;
  private bool    screenshot_request;

  private m8f_aas_event_handler handler;

  // public methods section

  void request_screenshot()
  {
    screenshot_request = true;
  }

  // override functions section ////////////////////////////////////////////////

  override void OnRegister()
  {
    loading_finished   = false;
    screenshot_request = false;
    autosave_request   = -1;
  }

  override void WorldTick()
  {
    // request must not be processed in the same tick as it was received
    // because request CVar is not updated yet.
    if (autosave_request != -1)
    {
      handler.on_event(autosave_request);
      autosave_request = -1;
      return;
    }

    CVar autosave_request_cvar = CVar.GetCVar("m8f_aas_request");
    int  received_request      = autosave_request_cvar.GetInt();
    if (received_request != -1)
    {
      autosave_request_cvar.SetInt(-1);
      autosave_request = received_request;
    }

    if (level.time == 0) { return; }
    else { loading_finished = true; }

    int tick_inside_second = level.time % ticks_in_second;
    switch (tick_inside_second)
      {
      case  0: handler.on_event(m8f_aas_event.tick); break;
      case  1: maybeTakeScreenShot();  return;
      case  9: check_counter_events(); return;
      case 18: check_map_events();     return;
      case 27: check_player_events();  return;
      default: return;
      }
  }

  override void PlayerEntered(PlayerEvent e)
  {
    if (e.PlayerNumber != consolePlayer) { return; }
    init_player();
    handler.on_event(m8f_aas_event.level_start);
  }

  override void WorldThingSpawned(WorldEvent e)
  {
    if (e == null) { return; }
    if (e.thing == null) { return; }

    // spawn special actor that saves the game when picked up
    // alongside inventory items.
    if (e.thing.GetClassName() == "m8f_aas_token") { return; }

    Inventory item = Inventory(e.thing);
    if (item == null) { return; }

    bool saveOnDropped = CVar.GetCVar("m8f_aas_save_on_dropped").GetInt();
    if (!saveOnDropped && loading_finished) { return; }

    static const string saveable_item_classes[] =
    {
      "Key",
      "FDKeyBase",
      "QCRedCard",
      "QCYellowCard",
      "QCBlueCard",
      "QCRedSkull",
      "QCYellowSkull",
      "QCBlueSkull",
      "Weapon", // weapons
      "Goonades",
      "SPAMMineItem",
      "PowerupGiver", // powerups
      "TBPowerupBase",
      "MapRevealer",
      "Berserk",
      "Speeders",
      "IcarusMk8",
      "ProtectoBand",
      "BigSPAMMine",
      "GuardBoi",
      "BadassGlasses",
      "Mapisto",
      "LovebirdTag",
      "BigScorePresent",
      "BackpackItem", // backpacks
      "Backpack2",
      "BlueprintItem",
      "NetronianBackpack",
      "Big_Coin_pickup", // other
      "BasicArmorPickup" // armor
    };
    static const int types[] =
    {
      m8f_aas_event.key,
      m8f_aas_event.key,
      m8f_aas_event.key,
      m8f_aas_event.key,
      m8f_aas_event.key,
      m8f_aas_event.key,
      m8f_aas_event.key,
      m8f_aas_event.key,
      m8f_aas_event.weapon,
      m8f_aas_event.weapon,
      m8f_aas_event.weapon,
      m8f_aas_event.powerup,
      m8f_aas_event.powerup,
      m8f_aas_event.powerup,
      m8f_aas_event.powerup,
      m8f_aas_event.powerup,
      m8f_aas_event.powerup,
      m8f_aas_event.powerup,
      m8f_aas_event.powerup,
      m8f_aas_event.powerup,
      m8f_aas_event.powerup,
      m8f_aas_event.powerup,
      m8f_aas_event.powerup,
      m8f_aas_event.powerup,
      m8f_aas_event.backpack,
      m8f_aas_event.backpack,
      m8f_aas_event.backpack,
      m8f_aas_event.backpack,
      m8f_aas_event.gs_gold_coin,
      m8f_aas_event.armor
    };

    int n_saveable_items_classes = saveable_item_classes.size();
    if (n_saveable_items_classes != types.size()) { console.printf("AAS Error: invalid saveable items."); }

    Actor   player = players[consolePlayer].mo;
    Actor   owner  = item.owner;
    Vector3 point  = item.pos;

    for (int i = 0; i < n_saveable_items_classes; ++i)
    {
      if (!(item is saveable_item_classes[i])) { continue; }

      if (owner == null)
      {
        m8f_aas_token(Actor.Spawn("m8f_aas_token", point)).init(types[i], handler);
      }
      else if (owner == player
               && loading_finished) // don't save on obtaining starting weapons
      {
        string netronianBackpack = "NetronianBackpack";
        class<Actor> netronianBackpackClass = netronianBackpack;
        // don't save on BackpackItem for Netronian Chaos, save on
        // Netronian Backpack instead
        if (saveable_item_classes[i] == "BackpackItem"
            && netronianBackpackClass) { return; }

        handler.on_event(types[i]);
      }
      break;
    }
  }

  // private methods

  private void init_player()
  {
    oldActiveCount = 0;
    oldActiveBigCount = 0;
    maxActive = 0;

    old_kill_count = 0;
    old_item_count = 0;

    handler = new("m8f_aas_event_dispatcher").init(self, null);

    PlayerInfo pInfo  = players[consolePlayer];
    let player = PlayerPawn(pInfo.mo);
    old_pos    = player.Pos;
    old_health = player.Health;
    old_armor  = player.CountInv("BasicArmor");
    old_secret_count = pInfo.secretcount;

    BasicArmor armor = BasicArmor(player.FindInventory("BasicArmor"));
    if (armor) { old_armor_save = armor.SavePercent; }
    else       { old_armor_save = 0.0; }
  }

  private void check_counter_events()
  {
    // count active monsters
    let i               = ThinkerIterator.Create("Actor", Thinker.STAT_DEFAULT);
    int activeCount     = 0;
    int activeBigCount  = 0;
    int min_boss_health = CVar.GetCVar("m8f_aas_min_boss_health").GetInt();
    Actor a;

    while (a = Actor(i.Next()))
    {
      if (a.bISMONSTER
          && a.Target != null
          && a.Health > 0)
      {
        if (a.SpawnHealth() >= min_boss_health) { ++activeBigCount; }
        ++activeCount;
      }
    }
    //Console.Printf("Counts: %d, %d", activeCount, activeBigCount);

    if (activeCount > maxActive) { maxActive = activeCount; }

    int group_number = CVar.GetCVar("m8f_aas_group_number").GetInt();
    if (activeCount >= oldActiveCount + group_number)
    {
      handler.on_event(m8f_aas_event.group_alert);
    }
    else if (activeCount == 0)
    {
      if (maxActive >= group_number)
      {
        handler.on_event(m8f_aas_event.group_kill);
      }
      maxActive = 0;
    }
    else if (activeBigCount > oldActiveBigCount)
    {
      handler.on_event(m8f_aas_event.boss_alert);
    }
    else if (activeBigCount < oldActiveBigCount)
    {
      handler.on_event(m8f_aas_event.boss_kill);
    }

    oldActiveCount = activeCount;
    oldActiveBigCount = activeBigCount;
  }

  private void check_player_events()
  {
    PlayerInfo player = players[consoleplayer];

    {
      vector3 pos = player.mo.Pos;
      float x_diff = (pos.x - old_pos.x);
      float y_diff = (pos.y - old_pos.y);
      float dist = x_diff * x_diff + y_diff * y_diff;
      if (dist > 2000000.0)
      {
        //Console.Printf("Distance: %f", dist);
        handler.on_event(m8f_aas_event.teleport);
      }
      old_pos = pos;
    }

    {
      int health      = player.mo.health;
      int health_down = CVar.GetCVar("m8f_aas_health_threshold_down").GetInt();
      int health_up   = CVar.GetCVar("m8f_aas_health_threshold_up").GetInt();
      if (health < health_down && old_health >= health_down)
      {
        handler.on_event(m8f_aas_event.health_drop);
      }
      else if (health > health_up && old_health <= health_up)
      {
        handler.on_event(m8f_aas_event.health_rise);
      }
      else if (health >= old_health + 50 && old_health > 0)
      {
        handler.on_event(m8f_aas_event.big_heal);
      }
      if (health == 1 && old_health > 1)
      {
        handler.on_event(m8f_aas_event.one_percent);
      }
      old_health = health;
    }

    {
      int armor_count = player.mo.CountInv("BasicArmor");
      int armor_down  = CVar.GetCVar("m8f_aas_armor_threshold_down").GetInt();
      int armor_up    = CVar.GetCVar("m8f_aas_armor_threshold_up").GetInt();
      if (armor_count < armor_down && old_armor >= armor_down)
      {
        handler.on_event(m8f_aas_event.armor_drop);
      }
      else if (armor_count > armor_up && old_armor <= armor_up)
      {
        handler.on_event(m8f_aas_event.armor_rise);
      }
      old_armor = armor_count;
    }

    {
      BasicArmor armor = BasicArmor(player.mo.FindInventory("BasicArmor"));
      if (armor != null)
        {
          double save_percent = armor.SavePercent;
          if (save_percent != 0.0 && save_percent != old_armor_save)
          {
            handler.on_event(m8f_aas_event.new_armor);
          }
          old_armor_save = save_percent;
        }
    }
  }

  private void check_map_events()
  {
    PlayerInfo player = players[consoleplayer];

    {
      int secret_count = player.secretcount;
      if (secret_count > old_secret_count)
      {
        handler.on_event(m8f_aas_event.secret_found);
      }
      old_secret_count = secret_count;
    }

    {
      int kill_count = level.killed_monsters;
      if (kill_count != old_kill_count && kill_count == level.total_monsters)
      {
        handler.on_event(m8f_aas_event.all_kill);
      }
      old_kill_count = kill_count;
    }

    {
      int item_count = level.found_items;
      if (item_count != old_item_count && item_count == level.total_items)
      {
        handler.on_event(m8f_aas_event.all_items_found);
      }
      old_item_count = item_count;
    }
  }

  private void maybeTakeScreenShot()
  {
    if (screenshot_request)
    {
      LevelLocals.MakeScreenShot();

      screenshot_request = false;
    }
  }

} // class m8f_aas_event_source
