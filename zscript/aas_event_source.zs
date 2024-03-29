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

    let last_save_time = aas_timestamp.of();

    result._clock      = aas_level_clock.of();
    result._scheduler  = aas_game_action_scheduler.of();
    result._voice      = aas_voice.of();

    array<aas_event_handler> handlers;
    handlers.push(aas_saver .of(result._scheduler, result._clock, last_save_time));
    handlers.push(aas_logger.of(aas_log_function.of(), "m8f_aas_console_log_level"));
    handlers.push(aas_logger.of(aas_print_function.of(), "m8f_aas_screen_level"));
    handlers.push(result._voice);
    handlers.push(aas_screenshot_maker.of(result._scheduler));
    result._handler = aas_event_handlers.of(handlers);

    result._save_timer = aas_save_timer.of(result._clock, last_save_time);

    result._old_kill_count = level.killed_monsters;
    result._old_item_count = level.found_items;

    PlayerInfo player_info  = players[consolePlayer];
    let player = PlayerPawn(player_info.mo);
    result._old_pos    = player.Pos;
    result._old_health = player.Health;
    result._old_armor  = player.CountInv("BasicArmor");
    result._old_secret_count = player_info.secretCount;

    BasicArmor armor = BasicArmor(player.FindInventory("BasicArmor"));
    if (armor) { result._old_armor_save = armor.SavePercent; }
    else       { result._old_armor_save = 0.0; }

    result._save_on_dropped = aas_cvar.of("m8f_aas_save_on_dropped");
    result._health_down     = aas_cvar.of("m8f_aas_health_threshold_down");
    result._health_up       = aas_cvar.of("m8f_aas_health_threshold_up");
    result._armor_down      = aas_cvar.of("m8f_aas_armor_threshold_down");
    result._armor_up        = aas_cvar.of("m8f_aas_armor_threshold_up");
    result._major_healing   = aas_cvar.of("aas_big_heal");

    let active_enemies_counter = aas_active_enemies_counter.of();
    let enemies_group_cvar     = aas_cvar.of("m8f_aas_group_number");
    result._active_enemies_checker = aas_active_enemies_checker.of( result._handler
                                                                  , active_enemies_counter
                                                                  , enemies_group_cvar
                                                                  , aas_event.group_alert
                                                                  , aas_event.group_kill
                                                                  );
    let active_bosses_counter = aas_active_bosses_counter.of();
    let bosses_group_cvar = aas_cvar.of("aas_boss_group_number");
    result._active_bosses_checker = aas_active_enemies_checker.of( result._handler
                                                                 , active_bosses_counter
                                                                 , bosses_group_cvar
                                                                 , aas_event.boss_alert
                                                                 , aas_event.boss_kill
                                                                 );

    return result;
  }

  void on_event(int event_type)
  {
    _handler.on_event(event_type);
  }

  void tick()
  {
    if (_save_timer.is_periodic_save() && players[consolePlayer].mo.health > 0)
    {
      on_event(aas_event.time_period);
    }

    _voice.tick();
    _active_enemies_checker.tick();
    _active_bosses_checker.tick();

    check_secrets();
    check_all_found();
    check_player_events();

    check_all_killed();
    check_kill_percents();
    _old_kill_count = level.killed_monsters;

    _scheduler.tick();
  }

  void on_thing_spawned(Actor item)
  {
    string class_name = item.getClassName();

    if (class_name == "aas_token") { return; }

    if (class_name.left(11) == "aas_pickup_")
    {
      aas_token(Actor.Spawn("aas_token", item.pos)).init(aas_event.gs_gold_coin, _handler, item);
      return;
    }

    if (class_name.left(12) == "aas_instant_")
    {
      on_event(aas_event.gs_gold_coin);
      return;
    }

    if (!_save_on_dropped.get_bool() && is_loading_finished()) { return; }

    static const string saving_item_classes[] =
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

    int n_saving_items_classes = saving_item_classes.size();
    if (n_saving_items_classes != types.size())
    {
      aas_log.error("invalid saving items");
    }

    Actor player = players[consolePlayer].mo;
    Actor owner  = (item is "Inventory") ? Inventory(item).owner : NULL;

    for (int i = 0; i < n_saving_items_classes; ++i)
    {
      string saving_class = saving_item_classes[i];

      if (!(item is saving_class || Actor.GetReplacee(class_name) is saving_class))
      {
        continue;
      }

      if (owner == NULL)
      {
        aas_token(Actor.Spawn("aas_token", item.pos)).init(types[i], _handler, item);
      }
      else if (owner == player && is_loading_finished())
      {
        // don't save on obtaining starting weapons
        string netronianBackpack = "NetronianBackpack";
        class<Actor> netronianBackpackClass = netronianBackpack;

        // don't save on BackpackItem for Netronian Chaos, save on
        // Netronian Backpack instead
        if (saving_class == "BackpackItem" && netronianBackpackClass)
        {
          return;
        }

        on_event(types[i]);
      }

      break;
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void check_player_events()
  {
    PlayerInfo player = players[consolePlayer];

    int health = player.mo.health;
    if (health <= 0) return;

    {
      vector3 pos = player.mo.Pos;
      float x_diff = (pos.x - _old_pos.x);
      float y_diff = (pos.y - _old_pos.y);
      float dist = x_diff * x_diff + y_diff * y_diff;
      if (dist > 2000000.0)
      {
        aas_log.debug(String.Format("positions distance: %f", dist));
        on_event(aas_event.teleport);
      }
      _old_pos = pos;
    }

    {
      int health_down = _health_down.get_int();
      int health_up   = _health_up.get_int();
      if (health < health_down && _old_health >= health_down)
      {
        on_event(aas_event.health_drop);
      }
      else if (health > health_up && _old_health <= health_up)
      {
        on_event(aas_event.health_rise);
      }
      else if (health >= _old_health + _major_healing.get_int() && _old_health > 0)
      {
        on_event(aas_event.big_heal);
      }
      if (health == 1 && _old_health > 1)
      {
        on_event(aas_event.one_percent);
      }
      _old_health = health;
    }

    {
      int armor_count = player.mo.CountInv("BasicArmor");
      int armor_down  = _armor_down.get_int();
      int armor_up    = _armor_up.get_int();
      if (armor_count < armor_down && _old_armor >= armor_down && health > 0)
      {
        on_event(aas_event.armor_drop);
      }
      else if (armor_count > armor_up && _old_armor <= armor_up)
      {
        on_event(aas_event.armor_rise);
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
          on_event(aas_event.new_armor);
        }
        _old_armor_save = save_percent;
      }
    }
  }

  private
  void check_secrets()
  {
    PlayerInfo player = players[consolePlayer];
    int secret_count = player.secretCount;
    if (secret_count > _old_secret_count)
    {
      on_event(aas_event.secret_found);
    }
    _old_secret_count = secret_count;
  }

  private
  void check_all_killed()
  {
    int kill_count = level.killed_monsters;
    if (kill_count != _old_kill_count && kill_count == level.total_monsters)
    {
      on_event(aas_event.all_kill);
    }
  }

  private
  void check_kill_percents()
  {
    int kill_count = level.killed_monsters;
    static const int events[] =
    {
      aas_event.enemies_10,
      aas_event.enemies_20,
      aas_event.enemies_30,
      aas_event.enemies_40,
      aas_event.enemies_50,
      aas_event.enemies_60,
      aas_event.enemies_70,
      aas_event.enemies_80,
      aas_event.enemies_90
    };

    for (int i = 0; i < 9; ++i)
    {
      int percent = (i + 1) * 10;
      int ratio   = int(ceil(level.total_monsters * percent / 100.0));
      if (_old_kill_count < ratio && kill_count >= ratio)
      {
        on_event(events[i]);
      }
    }
  }

  private
  void check_all_found()
  {
    int item_count = level.found_items;
    if (item_count != _old_item_count && item_count == level.total_items)
    {
      on_event(aas_event.all_items_found);
    }
    _old_item_count = item_count;
  }

  private
  bool is_loading_finished()
  {
    return (_clock.time() > 0);
  }

  private aas_clock         _clock;
  private aas_event_handler _handler;
  private aas_game_action_scheduler _scheduler;
  private aas_save_timer    _save_timer;
  private aas_voice         _voice;

  private int     _old_kill_count;
  private int     _old_item_count;
  private int     _old_secret_count;

  private vector3 _old_pos;

  private int     _old_health;
  private int     _old_armor;
  private double  _old_armor_save;

  private aas_cvar _save_on_dropped;
  private aas_cvar _health_down;
  private aas_cvar _health_up;
  private aas_cvar _armor_down;
  private aas_cvar _armor_up;
  private aas_cvar _major_healing;

  private aas_active_enemies_checker _active_enemies_checker;
  private aas_active_enemies_checker _active_bosses_checker;

} // class aas_event_source
