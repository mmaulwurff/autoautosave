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
 * This class implements aas_event_handler by making a screenshots on events.
 */
class aas_screenshot_maker : aas_event_handler
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_screenshot_maker of(aas_game_actions game_actions)
  {
    let result = new("aas_screenshot_maker");

    result._game_actions   = game_actions;
    result._shot_on_manual = aas_cvar.of("m8f_aas_shot_on_manual");
    result._is_enabled     = aas_cvar.of("m8f_aas_enabled");

    return result;
  }

  override
  void on_event(int event_type)
  {
    if (shot_enabled(event_type))
    {
      _game_actions.take_screenshot();
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  bool shot_enabled(int event_type)
  {
    if (event_type == aas_event.manual) return _shot_on_manual.get_int();

    if (!_is_enabled.get_bool()) return false;

    string toggle_name = aas_event.shot_toggle_name(event_type);
    CVar   variable    = CVar.GetCVar(toggle_name);
    if (variable == NULL)
    {
      aas_log.error(String.Format("variable %s not found", toggle_name));
      return false;
    }

    return variable.GetInt();
  }

  private aas_game_actions _game_actions;

  private aas_cvar _shot_on_manual;
  private aas_cvar _is_enabled;

} // class aas_screenshot_maker
