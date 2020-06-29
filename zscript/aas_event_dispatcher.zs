/* Copyright Alexander 'm8f' Kromm (mmaulwurff@gmail.com) 2018-2020
 *
 * This file is a part of Autoautosave.
 *
 * Autoautosave is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or (at your option) any later
 * version.
 *
 * Autoautosave is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Autoautosave.  If not, see <https://www.gnu.org/licenses/>.
 */

/**
 * This class implements aas_event_handler by storing and activating several event handlers.
 */
class aas_event_dispatcher : aas_event_handler
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_event_dispatcher of(aas_game_actions game_actions, aas_clock clock, aas_timestamp timestamp)
  {
    let result = new("aas_event_dispatcher");

    result._handlers.Push(aas_saver        .of(game_actions, clock, timestamp));
    result._handlers.Push(aas_logger       .of());
    result._handlers.Push(aas_printer      .of());
    result._handlers.Push(aas_voice        .of());
    result._handlers.Push(aas_screenshooter.of(game_actions));

    return result;
  }

  override
  void on_event(int event_type)
  {
    uint n_handlers = _handlers.Size();

    for (uint i = 0; i < n_handlers; ++i)
    {
      _handlers[i].on_event(event_type);
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private Array<aas_event_handler> _handlers;

} // class aas_event_dispatcher
