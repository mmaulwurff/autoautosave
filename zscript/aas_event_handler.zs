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
 * This is an interface for AAS event handlers.
 *
 * @note This class is unrelated to EventHandler.
 */
class aas_event_handler play abstract
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  /**
   * Initializes the event handler.
   *
   * @param event_source
   * @param dispatcher
   *
   * @returns this object.
   */
  virtual
  aas_event_handler init(aas_event_source event_source, aas_event_handler dispatcher)
  {
    return self;
  }

  /**
   * Make an action when event @a event_type happens.
   *
   * @param event_type type of event.
   */
  virtual
  void on_event(int event_type)
  {
    Console.Printf("Override aas_event_handler.on_event()!");
  }

} // class aas_event_handler
