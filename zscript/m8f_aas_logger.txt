class m8f_aas_logger : m8f_aas_event_handler
{

  // public: ///////////////////////////////////////////////////////////////////

  override void on_event(int event_type)
  {
    if (is_worth_logging(event_type))
    {
      Console.Printf(m8f_aas_event.message(event_type));
    }
  }

  // private: //////////////////////////////////////////////////////////////////

  private static bool is_worth_logging(int event_type)
  {
    int  console_level    = CVar.GetCVar("m8f_aas_console_log_level").GetInt();
    bool is_worth_logging = event_type <= console_level
      && event_type != m8f_aas_event.tick;

    return is_worth_logging;
  }

} // class m8f_aas_logger
