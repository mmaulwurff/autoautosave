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

class aas_voice : aas_event_handler
{

  // public: ///////////////////////////////////////////////////////////////////

  override aas_event_handler init( aas_event_source  event_source
                                     , aas_event_handler dispatcher
                                     )
  {
    last_save_time = 0;
    return self;
  }

  override void on_event(int event_type)
  {
    int current_time          = level.time;
    int time_from_last_save_s = (current_time - last_save_time) / 35;
    if (time_from_last_save_s < 1) { return; }

    int voice_level = CVar.GetCVar("m8f_aas_voice_level").GetInt();
    if (event_type <= voice_level
        && is_voice_enabled_for(event_type)
        && event_type != aas_event.tick)
    {
      string voice_file = String.Format("aas/voice%d", event_type);
      Object.S_StartSound(voice_file, CHAN_AUTO);
      last_save_time = current_time;
    }
  }

  // private: //////////////////////////////////////////////////////////////////

  private static bool is_voice_enabled_for(int event_type)
  {
    bool is_enabled = CVar.GetCVar(aas_event.voice_toggle_name(event_type)).GetInt();
    return is_enabled;
  }

  private int last_save_time;

} // class aas_voice
