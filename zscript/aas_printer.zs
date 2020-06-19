class m8f_aas_printer : aas_event_handler
{

  override void on_event(int event_type)
  {
    int screen_level = CVar.GetCVar("m8f_aas_screen_level").GetInt();
    if (event_type <= screen_level
        && event_type != aas_event.tick)
      {
        Console.MidPrint("smallfont", aas_event.message(event_type), true);
      }
  }

} // class m8f_aas_printer
