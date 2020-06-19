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

class aas_event_dispatcher : aas_event_handler
{

  // public: ///////////////////////////////////////////////////////////////////

  override aas_event_handler init(aas_event_source event_source, aas_event_handler dispatcher)
  {
    _handlers.Push(new("aas_saver"        ).init(event_source, self));
    _handlers.Push(new("aas_logger"       ).init(event_source, self));
    _handlers.Push(new("aas_printer"      ).init(event_source, self));
    _handlers.Push(new("aas_voice"        ).init(event_source, self));
    _handlers.Push(new("aas_screenshooter").init(event_source, self));
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
