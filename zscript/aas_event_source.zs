/* Copyright Alexander 'm8f' Kromm (mmaulwurff@gmail.com) 2018-2020
 *
 * This file is a part of Autoautosave.
 *
 * Autoautosave is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * Autoautosave is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Autoautosave.  If not, see <https://www.gnu.org/licenses/>.
 */

/**
 * This class represents the core of Autoautosave.
 */
class aas_event_source play
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_event_source of()
  {
    let result = new("aas_event_source");

    result._old_active_count = 0;
    result._old_active_big_count = 0;
    result._max_active = 0;

    result._old_kill_count = 0;
    result._old_item_count = 0;

    result._handler = new("aas_event_dispatcher").init(result, NULL);

    PlayerInfo pInfo  = players[consolePlayer];
    let player = PlayerPawn(pInfo.mo);
    result._old_pos    = player.Pos;
    result._old_health = player.Health;
    result._old_armor  = player.CountInv("BasicArmor");
    result._old_secret_count = pInfo.secretcount;

    BasicArmor armor = BasicArmor(player.FindInventory("BasicArmor"));
    if (armor) { result._old_armor_save = armor.SavePercent; }
    else       { result._old_armor_save = 0.0; }

    result._screenshot_request = false;

    return result;
  }

  void on_event(int event_type)
  {
    _handler.on_event(event_type);
  }

  void request_screenshot()
  {
    _screenshot_request = true;
  }

  void tick()
  {
    if (level.time == 0) { return; }

    int tick_inside_second = level.time % TICRATE;
    switch (tick_inside_second)
    {
    case  0: _handler.on_event(aas_event.tick); break;
    case  1: maybeTakeScreenShot();  return;
    case  9: check_counter_events(); return;
    case 18: check_map_events();     return;
    case 27: check_player_events();  return;
    default: return;
    }
  }

  void on_thing_spawned(Actor item)
  {
    string class_name = item.getClassName();

    // spawn special actor that saves the game when picked up
    // alongside inventory items.

    if (class_name == "aas_token") { return; }

    bool saveOnDropped = CVar.GetCVar("m8f_aas_save_on_dropped").GetInt();
    if (!saveOnDropped && is_loading_finished()) { return; }

    static const string saveable_item_classes[] =
    {
      "Key",             // keys
      "FDKeyBase",
      "QCRedCard",
      "QCYellowCard",
      "QCBlueCard",
      "QCRedSkull",
      "QCYellowSkull",
      "QCBlueSkull",
      "Weapon",          // weapons
      "Goonades",
      "SPAMMineItem",
      "PowerupGiver",    // powerups
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
      "BackpackItem",    // backpacks
      "Backpack2",
      "BlueprintItem",
      "NetronianBackpack",
      "Big_Coin_pickup", // other
      "BasicArmorPickup" // armor
    };
    static const int types[] =
    {
      aas_event.key,
      aas_event.key,
      aas_event.key,
      aas_event.key,
      aas_event.key,
      aas_event.key,
      aas_event.key,
      aas_event.key,
      aas_event.weapon,
      aas_event.weapon,
      aas_event.weapon,
      aas_event.powerup,
      aas_event.powerup,
      aas_event.powerup,
      aas_event.powerup,
      aas_event.powerup,
      aas_event.powerup,
      aas_event.powerup,
      aas_event.powerup,
      aas_event.powerup,
      aas_event.powerup,
      aas_event.powerup,
      aas_event.powerup,
      aas_event.powerup,
      aas_event.backpack,
      aas_event.backpack,
      aas_event.backpack,
      aas_event.backpack,
      aas_event.gs_gold_coin,
      aas_event.armor
    };

    int n_saveable_items_classes = saveable_item_classes.size();
    if (n_saveable_items_classes != types.size())
    {
      console.printf("AAS Error: invalid saveable items.");
    }

    Actor   player = players[consolePlayer].mo;
    Actor   owner  = (item is "Inventory") ? Inventory(item).owner : NULL;
    Vector3 point  = item.pos;

    for (int i = 0; i < n_saveable_items_classes; ++i)
    {
      string saveable_class = saveable_item_classes[i];

      if (!(item is saveable_class || Actor.GetReplacee(class_name) is saveable_class))
      {
        continue;
      }

      if (owner == NULL)
      {
        aas_token(Actor.Spawn("aas_token", point)).init(types[i], _handler);
      }
      else if (owner == player && is_loading_finished())
      {
        // don't save on obtaining starting weapons
        string netronianBackpack = "NetronianBackpack";
        class<Actor> netronianBackpackClass = netronianBackpack;

        // don't save on BackpackItem for Netronian Chaos, save on
        // Netronian Backpack instead
        if (saveable_class == "BackpackItem" && netronianBackpackClass)
        {
          return;
        }

        _handler.on_event(types[i]);
      }

      break;
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void check_counter_events()
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
          && a.Target != NULL
          && a.Health > 0)
      {
        if (a.SpawnHealth() >= min_boss_health) { ++activeBigCount; }
        ++activeCount;
      }
    }
    //Console.Printf("Counts: %d, %d", activeCount, activeBigCount);

    if (activeCount > _max_active) { _max_active = activeCount; }

    int group_number = CVar.GetCVar("m8f_aas_group_number").GetInt();
    if (activeCount >= _old_active_count + group_number)
    {
      _handler.on_event(aas_event.group_alert);
    }
    else if (activeCount == 0)
    {
      if (_max_active >= group_number)
      {
        _handler.on_event(aas_event.group_kill);
      }
      _max_active = 0;
    }
    else if (activeBigCount > _old_active_big_count)
    {
      _handler.on_event(aas_event.boss_alert);
    }
    else if (activeBigCount < _old_active_big_count)
    {
      _handler.on_event(aas_event.boss_kill);
    }

    _old_active_count = activeCount;
    _old_active_big_count = activeBigCount;
  }

  private
  void check_player_events()
  {
    PlayerInfo player = players[consoleplayer];

    {
      vector3 pos = player.mo.Pos;
      float x_diff = (pos.x - _old_pos.x);
      float y_diff = (pos.y - _old_pos.y);
      float dist = x_diff * x_diff + y_diff * y_diff;
      if (dist > 2000000.0)
      {
        //Console.Printf("Distance: %f", dist);
        _handler.on_event(aas_event.teleport);
      }
      _old_pos = pos;
    }

    {
      int health      = player.mo.health;
      int health_down = CVar.GetCVar("m8f_aas_health_threshold_down").GetInt();
      int health_up   = CVar.GetCVar("m8f_aas_health_threshold_up").GetInt();
      if (health < health_down && _old_health >= health_down)
      {
        _handler.on_event(aas_event.health_drop);
      }
      else if (health > health_up && _old_health <= health_up)
      {
        _handler.on_event(aas_event.health_rise);
      }
      else if (health >= _old_health + 50 && _old_health > 0)
      {
        _handler.on_event(aas_event.big_heal);
      }
      if (health == 1 && _old_health > 1)
      {
        _handler.on_event(aas_event.one_percent);
      }
      _old_health = health;
    }

    {
      int armor_count = player.mo.CountInv("BasicArmor");
      int armor_down  = CVar.GetCVar("m8f_aas_armor_threshold_down").GetInt();
      int armor_up    = CVar.GetCVar("m8f_aas_armor_threshold_up").GetInt();
      if (armor_count < armor_down && _old_armor >= armor_down)
      {
        _handler.on_event(aas_event.armor_drop);
      }
      else if (armor_count > armor_up && _old_armor <= armor_up)
      {
        _handler.on_event(aas_event.armor_rise);
      }
      _old_armor = armor_count;
    }

    {
      BasicArmor armor = BasicArmor(player.mo.FindInventory("BasicArmor"));
      if (armor != NULL)
      {
        double save_percent = armor.SavePercent;
        if (save_percent != 0.0 && save_percent != _old_armor_save)
        {
          _handler.on_event(aas_event.new_armor);
        }
        _old_armor_save = save_percent;
      }
    }
  }

  private
  void check_map_events()
  {
    PlayerInfo player = players[consoleplayer];

    {
      int secret_count = player.secretcount;
      if (secret_count > _old_secret_count)
      {
        _handler.on_event(aas_event.secret_found);
      }
      _old_secret_count = secret_count;
    }

    {
      int kill_count = level.killed_monsters;
      if (kill_count != _old_kill_count && kill_count == level.total_monsters)
      {
        _handler.on_event(aas_event.all_kill);
      }
      _old_kill_count = kill_count;
    }

    {
      int item_count = level.found_items;
      if (item_count != _old_item_count && item_count == level.total_items)
      {
        _handler.on_event(aas_event.all_items_found);
      }
      _old_item_count = item_count;
    }
  }

  private
  void maybeTakeScreenShot()
  {
    if (_screenshot_request)
    {
      LevelLocals.MakeScreenShot();

      _screenshot_request = false;
    }
  }

  private bool is_loading_finished()
  {
    return (level.time > 0);
  }

  private int     _old_active_count;
  private int     _old_active_big_count;
  private int     _max_active;

  private int     _old_kill_count;
  private int     _old_item_count;
  private int     _old_secret_count;

  private vector3 _old_pos;

  private int     _old_health;
  private int     _old_armor;
  private double  _old_armor_save;

  private bool    _screenshot_request;

  private aas_event_handler _handler;

} // class aas_event_source
