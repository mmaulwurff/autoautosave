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

class aas_save_timer play
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_save_timer of(aas_clock clock, aas_timestamp timestamp)
  {
    let result = new("aas_save_timer");

    result._clock          = clock;
    result._last_save_time = timestamp;

    result._autosave_period_s   = aas_cvar.of("m8f_aas_autosave_period");
    result._save_on_time_period = aas_cvar.of("m8f_aas_save_on_time_period");

    return result;
  }

  bool is_periodic_save()
  {
    int current_time          = _clock.time();
    int time_from_last_save_s = (current_time - _last_save_time.get_time()) / TICRATE;

    return is_time_to_periodic_save(time_from_last_save_s);
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  bool is_time_to_periodic_save(int time_from_last_save_s)
  {
    int  is_second_start          = (_clock.time() % TICRATE == 0);
    int  autosave_period_s        = _autosave_period_s.get_int();
    bool is_period                = (time_from_last_save_s % autosave_period_s) == 0;
    bool is_time_to_periodic_save = is_second_start && is_period && _save_on_time_period.get_int();

    return is_time_to_periodic_save;
  }

  private aas_clock     _clock;
  private aas_timestamp _last_save_time;

  private aas_cvar _autosave_period_s;
  private aas_cvar _save_on_time_period;

} // class aas_save_timer
