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
    int  time_from_last_save = _clock.time() - _last_save_time.get_time();
    int  autosave_period     = _autosave_period_s.get_int() * TICRATE;
    bool is_period           = (time_from_last_save % autosave_period) == (autosave_period - 1);

    return is_period
      && _save_on_time_period.get_int()
      && _clock.time() > 0;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private aas_clock     _clock;
  private aas_timestamp _last_save_time;

  private aas_cvar _autosave_period_s;
  private aas_cvar _save_on_time_period;

} // class aas_save_timer
