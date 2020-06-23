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

  static
  aas_saver of(aas_event_handler dispatcher, aas_game_actions game_actions)
  {
    let result = new("aas_saver");

    result._last_save_time = 0;
    result._dispatcher     = dispatcher;
    result._game_actions   = game_actions;

    result._autosave_period_s   = aas_cvar.of("m8f_aas_autosave_period");
    result._save_on_time_period = aas_cvar.of("m8f_aas_save_on_time_period");
    result._min_save_wait_s     = aas_cvar.of("m8f_aas_min_save_wait");
    result._is_enabled          = aas_cvar.of("m8f_aas_enabled");
    result._min_health          = aas_cvar.of("m8f_aas_health_limit");

    return result;
  }

  override
  void on_event(int event_type)
  {
    int current_time          = level.time;
    int time_from_last_save_s = (current_time - _last_save_time) / TICRATE;

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
    int  is_second_start          = (level.time % TICRATE == 0);
    int  autosave_period_s        = _autosave_period_s.get_int();
    bool is_period                = (time_from_last_save_s % autosave_period_s) == 0;
    bool is_time_to_periodic_save = event_type == aas_event.tick
      && is_second_start
      && is_period
      && _save_on_time_period.get_int();

    return is_time_to_periodic_save;
  }

  private
  bool is_too_frequent(int time_from_last_save_s, int event_type)
  {
    // manual saving cannot be too frequent
    if (event_type == aas_event.manual) { return false; }

    bool is_too_frequent = time_from_last_save_s < _min_save_wait_s.get_int();

    return is_too_frequent;
  }

  private
  void save(int current_time)
  {
    _last_save_time = current_time;

    _game_actions.save();
  }

  private
  void emit_time_period_event()
  {
    _dispatcher.on_event(aas_event.time_period);
  }

  private
  bool is_save_enabled(int event_type)
  {
    if (event_type == aas_event.manual) return true;

    if (!_is_enabled.get_bool()) return false;

    int health     = players[consoleplayer].Health;
    int min_health = _min_health.get_int();

    if (health < min_health) return false;

    string toggle_name = aas_event.toggle_name(event_type);

    CVar variable = CVar.GetCVar(toggle_name);
    if (variable == NULL)
    {
      console.printf("Autoautosave Warning: variable %s not found", toggle_name);
      return false;
    }

    return variable.GetInt();
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private int _last_save_time;

  private aas_event_handler _dispatcher;
  private aas_game_actions  _game_actions;

  private aas_cvar _autosave_period_s;
  private aas_cvar _save_on_time_period;
  private aas_cvar _min_save_wait_s;
  private aas_cvar _is_enabled;
  private aas_cvar _min_health;

} // class aas_saver
