class aas_event_dispatcher : aas_event_handler
{

  // public: ///////////////////////////////////////////////////////////////////

  override aas_event_handler init(aas_event_source event_source, aas_event_handler dispatcher)
  {
    _handlers.Push(new("m8f_aas_saver"        ).init(event_source, self));
    _handlers.Push(new("m8f_aas_logger"       ).init(event_source, self));
    _handlers.Push(new("m8f_aas_printer"      ).init(event_source, self));
    _handlers.Push(new("m8f_aas_voice"        ).init(event_source, self));
    _handlers.Push(new("m8f_aas_screenshooter").init(event_source, self));
    return self;
  }

  override void on_event(int event_type)
  {
    uint n_handlers = _handlers.Size();

    for (uint i = 0; i < n_handlers; ++i)
    {
      _handlers[i].on_event(event_type);
    }
  }

  // private: //////////////////////////////////////////////////////////////////

  Array<aas_event_handler> _handlers;

} // class aas_event_dispatcher