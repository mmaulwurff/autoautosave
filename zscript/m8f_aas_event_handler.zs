// Base class for all Aas event handlers
class m8f_aas_event_handler : Thinker
{

  virtual m8f_aas_event_handler init( m8f_aas_event_source  event_source
                                    , m8f_aas_event_handler dispatcher
                                    ) { return self; }

  virtual void on_event(int event_type) {}

} // class m8f_aas_event_handler