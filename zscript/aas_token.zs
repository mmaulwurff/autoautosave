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
