// Creates an aas_event when pickup up
class m8f_aas_token : Inventory
{

  Default
  {
    +Inventory.Quiet;
    +DONTGIB;
  }

  m8f_aas_token init(int type, aas_event_handler handler)
  {
    _event_type = type;
    _handler    = handler;

    return self;
  }

  override bool TryPickup(Actor toucher)
  {
    _handler.on_event(_event_type);
    GoAwayAndDie();
    return true;
  }

  // private: //////////////////////////////////////////////////////////////////

  private int _event_type;

  private aas_event_handler _handler;

} // class m8f_aas_token
