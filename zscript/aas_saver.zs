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

class aas_saver : aas_event_handler
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  override
  aas_event_handler init(aas_event_source event_source, aas_event_handler dispatcher)
  {
    last_save_time = 0;
    _dispatcher = dispatcher;

    return self;
  }

  override
  void on_event(int event_type)
  {
    int current_time          = level.time;
    int time_from_last_save_s = (current_time - last_save_time) / TICRATE;

    if (is_time_to_periodic_save(time_from_last_save_s, event_type))
    {
      emit_time_period_event();
      return;
    }

    if (is_too_frequent(time_from_last_save_s, event_type))
    {
      return;
    }

    if (is_save_enabled(event_type))
    {
      save(current_time);
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  bool is_time_to_periodic_save(int time_from_last_save_s, int event_type)
  {
    int  autosave_period_s        = CVar.GetCVar("m8f_aas_autosave_period").GetInt();
    bool is_period                = (time_from_last_save_s % autosave_period_s) == 0;
    bool is_time_to_periodic_save = event_type == aas_event.tick
      && is_period
      && CVar.GetCVar("m8f_aas_save_on_time_period").GetInt();

    return is_time_to_periodic_save;
  }

  private
  bool is_too_frequent(int time_from_last_save_s, int event_type)
  {
    // manual saving cannot be too frequent
    if (event_type == aas_event.manual) { return false; }

    int  min_save_wait_s = CVar.GetCVar("m8f_aas_min_save_wait").GetInt();
    bool is_too_frequent = time_from_last_save_s < min_save_wait_s;

    return is_too_frequent;
  }

  private
  void save(int current_time)
  {
    last_save_time = current_time;

    if (gameaction != ga_completed)
    {
      LevelLocals.MakeAutoSave();
    }
  }

  private
  void emit_time_period_event()
  {
    _dispatcher.on_event(aas_event.time_period);
  }

  private static
  bool is_save_enabled(int event_type)
  {
    if (event_type == aas_event.manual) { return true; }

    bool enabled = CVar.GetCVar("m8f_aas_enabled").GetInt();
    if (!enabled) { return false; }

    int health     = players[consoleplayer].Health;
    int min_health = CVar.GetCVar("m8f_aas_health_limit").GetInt();

    if (health < min_health) { return false; }

    string toggle_name = aas_event.toggle_name(event_type);

    CVar variable = CVar.GetCVar(toggle_name);
    if (variable == null)
    {
      console.printf("Autoautosave Warning: variable %s not found", toggle_name);
      return false;
    }

    return variable.GetInt();
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private int last_save_time;

  private aas_event_handler _dispatcher;

} // class aas_saver
