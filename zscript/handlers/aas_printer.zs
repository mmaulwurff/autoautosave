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

class aas_printer : aas_event_handler
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_printer of()
  {
    let result = new("aas_printer");
    result._screen_level = aas_cvar.of("m8f_aas_screen_level", players[consolePlayer]);
    return result;
  }

  override
  void on_event(int event_type)
  {
    if (event_type <= _screen_level.get_int())
    {
      Console.MidPrint("smallfont", aas_event.message(event_type), true);
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private aas_cvar _screen_level;

} // class aas_printer