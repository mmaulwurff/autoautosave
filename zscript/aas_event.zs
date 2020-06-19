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
    tick             =   6,
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
      case all_kill         : return "All enemies eliminated.";
      case boss_kill        : return "Boss eliminated.";
      case group_kill       : return "No more active enemies.";
      case group_alert      : return "New active enemies.";
      case boss_alert       : return "Boss alerted.";
      case all_items_found  : return "All items found.";
      case tick             : return "Tick.";
      case time_period      : return "Time passed.";
      case teleport         : return "You are moved to another place.";
      case manual           : return "Manual save.";
      case pomodoro         : return "It's time to take a break.";
      case gs_gold_coin     : return "Picked up a big coin, nice job!";
      case level_start      : return "Level started.";
      case one_percent      : return "Last health percent!";
      case health_drop      : return "Health low.";
      case health_rise      : return "Health high.";
      case armor_drop       : return "Armor low.";
      case armor_rise       : return "Armor high.";
      case secret_found     : return "Secret found.";
      case powerup          : return "Powerup is found.";
      case weapon           : return "Weapon is found.";
      case key              : return "Key found.";
      case backpack         : return "Backpack found.";
      case new_armor        : return "New armor type.";
      case big_heal         : return "Major healing.";
      case armor            : return "Armor found.";
      default: return "Unknown event type.";
    }
  }

  static string toggle_name(int type)
  {
    switch (type)
    {
      case all_kill         : return "m8f_aas_save_on_all_kill";
      case boss_kill        : return "m8f_aas_save_on_boss_kill";
      case group_kill       : return "m8f_aas_save_on_group_kill";
      case group_alert      : return "m8f_aas_save_on_group_alert";
      case boss_alert       : return "m8f_aas_save_on_boss_alert";
      case all_items_found  : return "m8f_aas_save_on_all_items_found";
      case tick             : return "m8f_aas_false";
      case time_period      : return "m8f_aas_save_on_time_period";
      case teleport         : return "m8f_aas_save_on_teleport";
      case manual           : return "m8f_aas_true";
      case pomodoro         : return "m8f_aas_true";
      case gs_gold_coin     : return "m8f_aas_save_on_artefact";
      case level_start      : return "m8f_aas_save_on_level_start";
      case one_percent      : return "m8f_aas_save_on_one_percent";
      case health_drop      : return "m8f_aas_save_on_health_drop";
      case health_rise      : return "m8f_aas_save_on_health_rise";
      case armor_drop       : return "m8f_aas_save_on_armor_drop";
      case armor_rise       : return "m8f_aas_save_on_armor_rise";
      case secret_found     : return "m8f_aas_save_on_secret_found";
      case powerup          : return "m8f_aas_save_on_powerup";
      case weapon           : return "m8f_aas_save_on_weapon";
      case key              : return "m8f_aas_save_on_key";
      case backpack         : return "m8f_aas_save_on_backpack";
      case new_armor        : return "m8f_aas_save_on_new_armor";
      case big_heal         : return "m8f_aas_save_on_big_heal";
      case armor            : return "m8f_aas_save_on_armor";
      default: return "m8f_aas_false";
    }
  }

  static string shot_toggle_name(int type)
  {
    switch (type)
    {
      case all_kill         : return "m8f_aas_shot_on_all_kill";
      case boss_kill        : return "m8f_aas_shot_on_boss_kill";
      case group_kill       : return "m8f_aas_shot_on_group_kill";
      case group_alert      : return "m8f_aas_shot_on_group_alert";
      case boss_alert       : return "m8f_aas_shot_on_boss_alert";
      case all_items_found  : return "m8f_aas_shot_on_all_items_found";
      case tick             : return "m8f_aas_shot_on_tick";
      case time_period      : return "m8f_aas_shot_on_time_period";
      case teleport         : return "m8f_aas_shot_on_teleport";
      case manual           : return "m8f_aas_shot_on_manual";
      case pomodoro         : return "m8f_aas_shot_on_pomodoro";
      case gs_gold_coin     : return "m8f_aas_shot_on_gs_gold_coin";
      case level_start      : return "m8f_aas_shot_on_level_start";
      case one_percent      : return "m8f_aas_shot_on_one_percent";
      case health_drop      : return "m8f_aas_shot_on_health_drop";
      case health_rise      : return "m8f_aas_shot_on_health_rise";
      case armor_drop       : return "m8f_aas_shot_on_armor_drop";
      case armor_rise       : return "m8f_aas_shot_on_armor_rise";
      case secret_found     : return "m8f_aas_shot_on_secret_found";
      case powerup          : return "m8f_aas_shot_on_powerup";
      case weapon           : return "m8f_aas_shot_on_weapon";
      case key              : return "m8f_aas_shot_on_key";
      case backpack         : return "m8f_aas_shot_on_backpack";
      case new_armor        : return "m8f_aas_shot_on_new_armor";
      case big_heal         : return "m8f_aas_shot_on_big_heal";
      case armor            : return "m8f_aas_shot_on_armor";
      default: return "m8f_aas_false";
    }
  }

  static string voice_toggle_name(int type)
  {
    switch (type)
    {
      case all_kill         : return "m8f_aas_voice_on_all_kill";
      case boss_kill        : return "m8f_aas_voice_on_boss_kill";
      case group_kill       : return "m8f_aas_voice_on_group_kill";
      case group_alert      : return "m8f_aas_voice_on_group_alert";
      case boss_alert       : return "m8f_aas_voice_on_boss_alert";
      case all_items_found  : return "m8f_aas_voice_on_all_items_found";
      case tick             : return "m8f_aas_voice_on_tick";
      case time_period      : return "m8f_aas_voice_on_time_period";
      case teleport         : return "m8f_aas_voice_on_teleport";
      case manual           : return "m8f_aas_voice_on_manual";
      case pomodoro         : return "m8f_aas_voice_on_pomodoro";
      case gs_gold_coin     : return "m8f_aas_voice_on_gs_gold_coin";
      case level_start      : return "m8f_aas_voice_on_level_start";
      case one_percent      : return "m8f_aas_voice_on_one_percent";
      case health_drop      : return "m8f_aas_voice_on_health_drop";
      case health_rise      : return "m8f_aas_voice_on_health_rise";
      case armor_drop       : return "m8f_aas_voice_on_armor_drop";
      case armor_rise       : return "m8f_aas_voice_on_armor_rise";
      case secret_found     : return "m8f_aas_voice_on_secret_found";
      case powerup          : return "m8f_aas_voice_on_powerup";
      case weapon           : return "m8f_aas_voice_on_weapon";
      case key              : return "m8f_aas_voice_on_key";
      case backpack         : return "m8f_aas_voice_on_backpack";
      case new_armor        : return "m8f_aas_voice_on_new_armor";
      case big_heal         : return "m8f_aas_voice_on_big_heal";
      case armor            : return "m8f_aas_voice_on_armor";
      default: return "m8f_aas_true";
    }
  }

} // class m8f_aas_event