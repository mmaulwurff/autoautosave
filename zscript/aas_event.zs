// This file is generated from event_types.org by gen-files.sh.
// All manual changes will be lost.

class aas_event
{

  enum event_type
  {
    all_kill         =   0,
    boss_kill        =   1,
    group_kill       =   2,
    group_alert      =   3,
    boss_alert       =   4,
    all_items_found  =   5,
    time_period      =   7,
    teleport         =   8,
    manual           =   9,
    pomodoro         =  10,
    gs_gold_coin     =  11,
    level_start      =  12,
    one_percent      =  13,
    health_drop      = 100,
    health_rise      = 101,
    armor_drop       = 102,
    armor_rise       = 103,
    secret_found     = 104,
    powerup          = 200,
    weapon           = 201,
    key              = 202,
    backpack         = 203,
    new_armor        = 204,
    big_heal         = 205,
    armor            = 206,
  }

  static string message(int type)
  {
    switch (type)
    {
      case aas_event.all_kill         : return "All enemies eliminated.";
      case aas_event.boss_kill        : return "Boss eliminated.";
      case aas_event.group_kill       : return "No active enemies.";
      case aas_event.group_alert      : return "New active enemies.";
      case aas_event.boss_alert       : return "Boss alerted.";
      case aas_event.all_items_found  : return "All items found.";
      case aas_event.time_period      : return "Time passed.";
      case aas_event.teleport         : return "Moved to another place.";
      case aas_event.manual           : return "Manual save.";
      case aas_event.pomodoro         : return "Take a break.";
      case aas_event.gs_gold_coin     : return "Something rare!";
      case aas_event.level_start      : return "Level started.";
      case aas_event.one_percent      : return "Last health percent!";
      case aas_event.health_drop      : return "Health low.";
      case aas_event.health_rise      : return "Health high.";
      case aas_event.armor_drop       : return "Armor low.";
      case aas_event.armor_rise       : return "Armor high.";
      case aas_event.secret_found     : return "Secret found.";
      case aas_event.powerup          : return "Powerup found.";
      case aas_event.weapon           : return "Weapon found.";
      case aas_event.key              : return "Key found.";
      case aas_event.backpack         : return "Backpack found.";
      case aas_event.new_armor        : return "New armor.";
      case aas_event.big_heal         : return "Major healing.";
      case aas_event.armor            : return "Armor found.";
      default: aas_log.error(String.Format("unknown event: %d", type)); return "Unknown event type.";
    }
  }

  static string toggle_name(int type)
  {
    switch (type)
    {
      case aas_event.all_kill         : return "m8f_aas_save_on_all_kill";
      case aas_event.boss_kill        : return "m8f_aas_save_on_boss_kill";
      case aas_event.group_kill       : return "m8f_aas_save_on_group_kill";
      case aas_event.group_alert      : return "m8f_aas_save_on_group_alert";
      case aas_event.boss_alert       : return "m8f_aas_save_on_boss_alert";
      case aas_event.all_items_found  : return "m8f_aas_save_on_all_items_found";
      case aas_event.time_period      : return "m8f_aas_save_on_time_period";
      case aas_event.teleport         : return "m8f_aas_save_on_teleport";
      case aas_event.manual           : return "m8f_aas_true";
      case aas_event.pomodoro         : return "m8f_aas_true";
      case aas_event.gs_gold_coin     : return "m8f_aas_save_on_artefact";
      case aas_event.level_start      : return "m8f_aas_save_on_level_start";
      case aas_event.one_percent      : return "m8f_aas_save_on_one_percent";
      case aas_event.health_drop      : return "m8f_aas_save_on_health_drop";
      case aas_event.health_rise      : return "m8f_aas_save_on_health_rise";
      case aas_event.armor_drop       : return "m8f_aas_save_on_armor_drop";
      case aas_event.armor_rise       : return "m8f_aas_save_on_armor_rise";
      case aas_event.secret_found     : return "m8f_aas_save_on_secret_found";
      case aas_event.powerup          : return "m8f_aas_save_on_powerup";
      case aas_event.weapon           : return "m8f_aas_save_on_weapon";
      case aas_event.key              : return "m8f_aas_save_on_key";
      case aas_event.backpack         : return "m8f_aas_save_on_backpack";
      case aas_event.new_armor        : return "m8f_aas_save_on_new_armor";
      case aas_event.big_heal         : return "m8f_aas_save_on_big_heal";
      case aas_event.armor            : return "m8f_aas_save_on_armor";
      default: aas_log.error(String.Format("unknown event: %d", type)); return "aas_unknown";
    }
  }

  static string shot_toggle_name(int type)
  {
    switch (type)
    {
      case aas_event.all_kill         : return "m8f_aas_shot_on_all_kill";
      case aas_event.boss_kill        : return "m8f_aas_shot_on_boss_kill";
      case aas_event.group_kill       : return "m8f_aas_shot_on_group_kill";
      case aas_event.group_alert      : return "m8f_aas_shot_on_group_alert";
      case aas_event.boss_alert       : return "m8f_aas_shot_on_boss_alert";
      case aas_event.all_items_found  : return "m8f_aas_shot_on_all_items_found";
      case aas_event.time_period      : return "m8f_aas_shot_on_time_period";
      case aas_event.teleport         : return "m8f_aas_shot_on_teleport";
      case aas_event.manual           : return "m8f_aas_shot_on_manual";
      case aas_event.pomodoro         : return "m8f_aas_shot_on_pomodoro";
      case aas_event.gs_gold_coin     : return "m8f_aas_shot_on_gs_gold_coin";
      case aas_event.level_start      : return "m8f_aas_shot_on_level_start";
      case aas_event.one_percent      : return "m8f_aas_shot_on_one_percent";
      case aas_event.health_drop      : return "m8f_aas_shot_on_health_drop";
      case aas_event.health_rise      : return "m8f_aas_shot_on_health_rise";
      case aas_event.armor_drop       : return "m8f_aas_shot_on_armor_drop";
      case aas_event.armor_rise       : return "m8f_aas_shot_on_armor_rise";
      case aas_event.secret_found     : return "m8f_aas_shot_on_secret_found";
      case aas_event.powerup          : return "m8f_aas_shot_on_powerup";
      case aas_event.weapon           : return "m8f_aas_shot_on_weapon";
      case aas_event.key              : return "m8f_aas_shot_on_key";
      case aas_event.backpack         : return "m8f_aas_shot_on_backpack";
      case aas_event.new_armor        : return "m8f_aas_shot_on_new_armor";
      case aas_event.big_heal         : return "m8f_aas_shot_on_big_heal";
      case aas_event.armor            : return "m8f_aas_shot_on_armor";
      default: aas_log.error(String.Format("unknown event: %d", type)); return "aas_unknown";
    }
  }

  static string voice_toggle_name(int type)
  {
    switch (type)
    {
      case aas_event.all_kill         : return "m8f_aas_voice_on_all_kill";
      case aas_event.boss_kill        : return "m8f_aas_voice_on_boss_kill";
      case aas_event.group_kill       : return "m8f_aas_voice_on_group_kill";
      case aas_event.group_alert      : return "m8f_aas_voice_on_group_alert";
      case aas_event.boss_alert       : return "m8f_aas_voice_on_boss_alert";
      case aas_event.all_items_found  : return "m8f_aas_voice_on_all_items_found";
      case aas_event.time_period      : return "m8f_aas_voice_on_time_period";
      case aas_event.teleport         : return "m8f_aas_voice_on_teleport";
      case aas_event.manual           : return "m8f_aas_voice_on_manual";
      case aas_event.pomodoro         : return "m8f_aas_voice_on_pomodoro";
      case aas_event.gs_gold_coin     : return "m8f_aas_voice_on_gs_gold_coin";
      case aas_event.level_start      : return "m8f_aas_voice_on_level_start";
      case aas_event.one_percent      : return "m8f_aas_voice_on_one_percent";
      case aas_event.health_drop      : return "m8f_aas_voice_on_health_drop";
      case aas_event.health_rise      : return "m8f_aas_voice_on_health_rise";
      case aas_event.armor_drop       : return "m8f_aas_voice_on_armor_drop";
      case aas_event.armor_rise       : return "m8f_aas_voice_on_armor_rise";
      case aas_event.secret_found     : return "m8f_aas_voice_on_secret_found";
      case aas_event.powerup          : return "m8f_aas_voice_on_powerup";
      case aas_event.weapon           : return "m8f_aas_voice_on_weapon";
      case aas_event.key              : return "m8f_aas_voice_on_key";
      case aas_event.backpack         : return "m8f_aas_voice_on_backpack";
      case aas_event.new_armor        : return "m8f_aas_voice_on_new_armor";
      case aas_event.big_heal         : return "m8f_aas_voice_on_big_heal";
      case aas_event.armor            : return "m8f_aas_voice_on_armor";
      default: aas_log.error(String.Format("unknown event: %d", type)); return "aas_unknown";
    }
  }

} // class aas_event
