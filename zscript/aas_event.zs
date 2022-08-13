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
    gs_gold_coin     =  11,
    level_start      =  12,
    one_percent      =  13,
    enemies_10       =  14,
    enemies_20       =  15,
    enemies_30       =  16,
    enemies_40       =  17,
    enemies_50       =  18,
    enemies_60       =  19,
    enemies_70       =  20,
    enemies_80       =  21,
    enemies_90       =  22,
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
      case aas_event.all_kill         : return Stringtable.Localize("$AAS_EVENT_ALL_CLEAR");
      case aas_event.boss_kill        : return Stringtable.Localize("$AAS_EVENT_BOSS_KILLED");
      case aas_event.group_kill       : return Stringtable.Localize("$AAS_EVENT_ACTIVE_CLEAR");
      case aas_event.group_alert      : return Stringtable.Localize("$AAS_EVENT_NEW_ACTIVE");
      case aas_event.boss_alert       : return Stringtable.Localize("$AAS_EVENT_BOSS_ACTIVE");
      case aas_event.all_items_found  : return Stringtable.Localize("$AAS_EVENT_ALL_ITEMS");
      case aas_event.time_period      : return Stringtable.Localize("$AAS_EVENT_PERIODIC");
      case aas_event.teleport         : return Stringtable.Localize("$AAS_EVENT_TELEPORT");
      case aas_event.manual           : return Stringtable.Localize("$AAS_EVENT_MANUALSAVE");
      case aas_event.gs_gold_coin     : return Stringtable.Localize("$AAS_EVENT_RAREITEMGET");
      case aas_event.level_start      : return Stringtable.Localize("$AAS_EVENT_LEVELSTARTED");
      case aas_event.one_percent      : return Stringtable.Localize("$AAS_EVENT_HEALTH_1");
      case aas_event.enemies_10       : return Stringtable.Localize("$AAS_EVENT_10_DOWN");
      case aas_event.enemies_20       : return Stringtable.Localize("$AAS_EVENT_20_DOWN");
      case aas_event.enemies_30       : return Stringtable.Localize("$AAS_EVENT_30_DOWN");
      case aas_event.enemies_40       : return Stringtable.Localize("$AAS_EVENT_40_DOWN");
      case aas_event.enemies_50       : return Stringtable.Localize("$AAS_EVENT_50_DOWN");
      case aas_event.enemies_60       : return Stringtable.Localize("$AAS_EVENT_60_DOWN");
      case aas_event.enemies_70       : return Stringtable.Localize("$AAS_EVENT_70_DOWN");
      case aas_event.enemies_80       : return Stringtable.Localize("$AAS_EVENT_80_DOWN");
      case aas_event.enemies_90       : return Stringtable.Localize("$AAS_EVENT_90_DOWN");
      case aas_event.health_drop      : return Stringtable.Localize("$AAS_EVENT_HEALTH_LOW");
      case aas_event.health_rise      : return Stringtable.Localize("$AAS_EVENT_HEALTH_HIGH");
      case aas_event.armor_drop       : return Stringtable.Localize("$AAS_EVENT_ARMOR_LOW");
      case aas_event.armor_rise       : return Stringtable.Localize("$AAS_EVENT_ARMOR_HIGH");
      case aas_event.secret_found     : return Stringtable.Localize("$AAS_EVENT_SECRET");
      case aas_event.powerup          : return Stringtable.Localize("$AAS_EVENT_POWERUP");
      case aas_event.weapon           : return Stringtable.Localize("$AAS_EVENT_WEAPON");
      case aas_event.key              : return Stringtable.Localize("$AAS_EVENT_KEY");
      case aas_event.backpack         : return Stringtable.Localize("$AAS_EVENT_BACKPACK");
      case aas_event.new_armor        : return Stringtable.Localize("$AAS_EVENT_NEW_ARMOR");
      case aas_event.big_heal         : return Stringtable.Localize("$AAS_EVENT_HEALING");
      case aas_event.armor            : return Stringtable.Localize("$AAS_EVENT_ARMOR");
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
      case aas_event.gs_gold_coin     : return "m8f_aas_save_on_artefact";
      case aas_event.level_start      : return "m8f_aas_save_on_level_start";
      case aas_event.one_percent      : return "m8f_aas_save_on_one_percent";
      case aas_event.enemies_10       : return "m8f_aas_save_on_enemies_10";
      case aas_event.enemies_20       : return "m8f_aas_save_on_enemies_20";
      case aas_event.enemies_30       : return "m8f_aas_save_on_enemies_30";
      case aas_event.enemies_40       : return "m8f_aas_save_on_enemies_40";
      case aas_event.enemies_50       : return "m8f_aas_save_on_enemies_50";
      case aas_event.enemies_60       : return "m8f_aas_save_on_enemies_60";
      case aas_event.enemies_70       : return "m8f_aas_save_on_enemies_70";
      case aas_event.enemies_80       : return "m8f_aas_save_on_enemies_80";
      case aas_event.enemies_90       : return "m8f_aas_save_on_enemies_90";
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
      case aas_event.gs_gold_coin     : return "m8f_aas_shot_on_gs_gold_coin";
      case aas_event.level_start      : return "m8f_aas_shot_on_level_start";
      case aas_event.one_percent      : return "m8f_aas_shot_on_one_percent";
      case aas_event.enemies_10       : return "m8f_aas_shot_on_enemies_10";
      case aas_event.enemies_20       : return "m8f_aas_shot_on_enemies_20";
      case aas_event.enemies_30       : return "m8f_aas_shot_on_enemies_30";
      case aas_event.enemies_40       : return "m8f_aas_shot_on_enemies_40";
      case aas_event.enemies_50       : return "m8f_aas_shot_on_enemies_50";
      case aas_event.enemies_60       : return "m8f_aas_shot_on_enemies_60";
      case aas_event.enemies_70       : return "m8f_aas_shot_on_enemies_70";
      case aas_event.enemies_80       : return "m8f_aas_shot_on_enemies_80";
      case aas_event.enemies_90       : return "m8f_aas_shot_on_enemies_90";
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
      case aas_event.gs_gold_coin     : return "m8f_aas_voice_on_gs_gold_coin";
      case aas_event.level_start      : return "m8f_aas_voice_on_level_start";
      case aas_event.one_percent      : return "m8f_aas_voice_on_one_percent";
      case aas_event.enemies_10       : return "m8f_aas_voice_on_enemies_10";
      case aas_event.enemies_20       : return "m8f_aas_voice_on_enemies_20";
      case aas_event.enemies_30       : return "m8f_aas_voice_on_enemies_30";
      case aas_event.enemies_40       : return "m8f_aas_voice_on_enemies_40";
      case aas_event.enemies_50       : return "m8f_aas_voice_on_enemies_50";
      case aas_event.enemies_60       : return "m8f_aas_voice_on_enemies_60";
      case aas_event.enemies_70       : return "m8f_aas_voice_on_enemies_70";
      case aas_event.enemies_80       : return "m8f_aas_voice_on_enemies_80";
      case aas_event.enemies_90       : return "m8f_aas_voice_on_enemies_90";
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
