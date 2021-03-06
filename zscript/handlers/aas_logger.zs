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

class aas_logger : aas_event_handler
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  /**
   * Create aas_logger instance.
   *
   * @param log_function a function that receives one parameter of type String.
   * @param level_cvar_name a name of int CVar that controls verbosity level.
   */
  static
  aas_logger of(aas_function log_function, String level_cvar_name)
  {
    let result = new("aas_logger");

    PlayerInfo player = players[consolePlayer];

    result._level        = aas_cvar.of(level_cvar_name, player);
    result._color        = aas_cvar.of("aas_print_color", player);
    result._log_function = log_function;

    return result;
  }

  override
  void on_event(int event_type)
  {
    if (is_worth_logging(event_type, _level.get_int()))
    {
      int    color   = _color.get_int() + 97; // 97 == 'a'
      String message = String.Format("\c%c%s", color, aas_event.message(event_type));
      _log_function.f1(message);
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private static
  bool is_worth_logging(int event_type, int level)
  {
    return (event_type <= level);
  }

  private aas_cvar     _level;
  private aas_cvar     _color;
  private aas_function _log_function;

} // class aas_logger

class aas_log_function : aas_function
{
  static aas_log_function of() { return new("aas_log_function"); }
  override void f1(String s) { aas_log.print(s); }
}

class aas_print_function : aas_function
{
  static aas_print_function of() { return new("aas_print_function"); }
  override void f1(String s) { Console.MidPrint("smallfont", s, true); }
}
