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
  aas_saver of(aas_game_actions game_actions, aas_clock clock, aas_timestamp timestamp)
  {
    let result = new("aas_saver");

    result._game_actions    = game_actions;
    result._clock           = clock;
    result._last_save_time  = timestamp;

    result._min_save_wait_s = aas_cvar.of("m8f_aas_min_save_wait");
    result._is_enabled      = aas_cvar.of("m8f_aas_enabled");
    result._min_health      = aas_cvar.of("m8f_aas_health_limit");

    return result;
  }

  override
  void on_event(int event_type)
  {
    if (is_too_frequent(event_type)) return;

    if (is_save_enabled(event_type))
    {
      _last_save_time.set_time(_clock.time());
      _game_actions.save();
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  bool is_too_frequent(int event_type)
  {
    // manual saving cannot be too frequent.
    if (event_type == aas_event.manual) return false;

    int current_time          = _clock.time();
    int time_from_last_save_s = (current_time - _last_save_time.get_time())
                              / aas_consts.TICKS_IN_SECOND;

    return time_from_last_save_s < _min_save_wait_s.get_int();
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
      aas_log.error(String.Format("variable %s not found", toggle_name));
      return false;
    }

    return variable.GetInt();
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private aas_game_actions _game_actions;
  private aas_clock        _clock;
  private aas_timestamp    _last_save_time;

  private aas_cvar _min_save_wait_s;
  private aas_cvar _is_enabled;
  private aas_cvar _min_health;

} // class aas_saver
