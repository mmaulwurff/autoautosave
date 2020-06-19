// Base class for all AAS event handlers
class aas_event_handler : Thinker
{

  virtual aas_event_handler init( aas_event_source  event_source
                                , aas_event_handler dispatcher
                                ) { return self; }

  virtual void on_event(int event_type) {}

} // class aas_event_handler
