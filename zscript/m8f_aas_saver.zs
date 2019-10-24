class m8f_aas_saver : m8f_aas_event_handler
{

  // public: ///////////////////////////////////////////////////////////////////

  override m8f_aas_event_handler init(m8f_aas_event_source event_source, m8f_aas_event_handler dispatcher)
  {
    last_save_time = 0;
    _dispatcher = dispatcher;

    return self;
  }

  override void on_event(int event_type)
  {
    int current_time          = level.time;
    int time_from_last_save_s = (current_time - last_save_time) / 35;

    if (is_time_to_periodic_save(time_from_last_save_s, event_type))
    {
      emit_time_period_event();
      return;
    }

    if (is_too_frequent(time_from_last_save_s, event_type))
    {
      return;
    }

    if (is_save_enabled(event_type))
    {
      save(current_time);
    }
  }

  // private: //////////////////////////////////////////////////////////////////

  private bool is_time_to_periodic_save(int time_from_last_save_s, int event_type)
  {
    int  autosave_period_s        = CVar.GetCVar("m8f_aas_autosave_period").GetInt();
    bool is_period                = (time_from_last_save_s % autosave_period_s) == 0;
    bool is_time_to_periodic_save = event_type == m8f_aas_event.tick
      && is_period
      && CVar.GetCVar("m8f_aas_save_on_time_period").GetInt();

    return is_time_to_periodic_save;
  }

  private bool is_too_frequent(int time_from_last_save_s, int event_type)
  {
    // manual saving cannot be too frequent
    if (event_type == m8f_aas_event.manual) { return false; }

    int  min_save_wait_s = CVar.GetCVar("m8f_aas_min_save_wait").GetInt();
    bool is_too_frequent = time_from_last_save_s < min_save_wait_s;

    return is_too_frequent;
  }

  // private: //////////////////////////////////////////////////////////////////

  private void save(int current_time)
  {
    last_save_time = current_time;

    if (gameaction != ga_completed)
    {
      LevelLocals.MakeAutoSave();
    }
  }

  // private: //////////////////////////////////////////////////////////////////

  private void emit_time_period_event()
  {
    _dispatcher.on_event(m8f_aas_event.time_period);
  }

  private static bool is_save_enabled(int event_type)
  {
    if (event_type == m8f_aas_event.manual) { return true; }

    bool enabled = CVar.GetCVar("m8f_aas_enabled").GetInt();
    if (!enabled) { return false; }

    int health     = players[consoleplayer].Health;
    int min_health = CVar.GetCVar("m8f_aas_health_limit").GetInt();

    if (health < min_health) { return false; }

    string toggle_name = m8f_aas_event.toggle_name(event_type);

    CVar variable = CVar.GetCVar(toggle_name);
    if (variable == null)
    {
      console.printf("Autoautosave Warning: variable %s not found", toggle_name);
      return false;
    }

    return variable.GetInt();
  }

  // private: //////////////////////////////////////////////////////////////////

  private int last_save_time;

  private m8f_aas_event_handler _dispatcher;

} // class m8f_aas_saver
