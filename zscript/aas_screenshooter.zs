class m8f_aas_screenshooter : aas_event_handler
{

  // public: ///////////////////////////////////////////////////////////////////

  override aas_event_handler init(aas_event_source event_source, aas_event_handler dispatcher)
  {
    _event_source = event_source;
    return self;
  }

  override void on_event(int event_type)
  {
    if (shot_enabled(event_type))
    {
      _event_source.request_screenshot();
    }
  }

  // private: //////////////////////////////////////////////////////////////////

  private static bool shot_enabled(int event_type)
  {
    if (event_type == aas_event.manual)
    {
      bool shot_on_manual = CVar.GetCVar("m8f_aas_shot_on_manual").GetInt();
      return shot_on_manual;
    }

    bool enabled = CVar.GetCVar("m8f_aas_enabled").GetInt();
    if (!enabled) { return false; }

    string toggle_name = aas_event.shot_toggle_name(event_type);

    CVar variable = CVar.GetCVar(toggle_name);
    if (variable == null)
    {
      console.printf("Autoautosave Warning: variable %s not found", toggle_name);
      return false;
    }

    return variable.GetInt();
  }

  // private: //////////////////////////////////////////////////////////////////

  private aas_event_source _event_source;

} // class m8f_aas_screenshooter
