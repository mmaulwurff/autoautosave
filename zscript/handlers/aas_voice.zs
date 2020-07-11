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
 * This class implements aas_event_handler by playing a sound when an event happens.
 */
class aas_voice : aas_event_handler
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_voice of()
  {
    let result = new("aas_voice");
    result._queue = aas_sound_queue.of();
    return result;
  }

  override
  void on_event(int event_type)
  {
    if (is_voice_enabled_for(event_type))
    {
      _queue.add(event_type);
    }
  }

  void tick()
  {
    _queue.tick();
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private static
  bool is_voice_enabled_for(int event_type)
  {
    bool is_enabled = CVar.GetCVar(aas_event.voice_toggle_name(event_type)).GetInt();
    return is_enabled;
  }

  private aas_sound_queue _queue;

} // class aas_voice

class aas_sound_queue play
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_sound_queue of()
  {
    let result = new("aas_sound_queue");
    result._timeout    = 0;
    result._voice_type = aas_cvar.of("aas_voice_type", players[consolePlayer]);
    return result;
  }

  void tick()
  {
    // Should I play something now?
    if (_timeout == 0)
    {
      // Yes, but is there something to play?
      if (_queue.size() == 0) return;

      int    event_type = _queue[0];
      string voice_file = String.Format("aas/voice%s%d", _voice_type.get_string(), event_type);
      S_StartSound(voice_file, CHAN_AUTO);

      _queue.delete(0);
      _timeout = TIMEOUT;
    }
    else
    {
      // No, wait more.
      --_timeout;
    }
  }

  void add(int event_type)
  {
    _queue.push(event_type);
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  const TIMEOUT = 2500 * TICRATE / 1000;

  /**
   * Event queue stores event types.
   */
  private array<int> _queue;
  private int        _timeout;
  private aas_cvar   _voice_type;

} // class aas_sound_queue
