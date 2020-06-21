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
class aas_screenshooter : aas_event_handler
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  override
  aas_event_handler init(aas_event_source event_source, aas_event_handler dispatcher)
  {
    _event_source = event_source;
    return self;
  }

  override
  void on_event(int event_type)
  {
    if (shot_enabled(event_type))
    {
      _event_source.request_screenshot();
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private static
  bool shot_enabled(int event_type)
  {
    if (event_type == aas_event.manual)
    {
      bool shot_on_manual = CVar.GetCVar("m8f_aas_shot_on_manual").GetInt();
      return shot_on_manual;
    }

    bool enabled = CVar.GetCVar("m8f_aas_enabled").GetInt();
    if (!enabled) { return false; }

    string toggle_name = aas_event.shot_toggle_name(event_type);

    CVar variable = CVar.GetCVar(toggle_name);
    if (variable == null)
    {
      console.printf("Autoautosave Warning: variable %s not found", toggle_name);
      return false;
    }

    return variable.GetInt();
  }

  private aas_event_source _event_source;

} // class aas_screenshooter
