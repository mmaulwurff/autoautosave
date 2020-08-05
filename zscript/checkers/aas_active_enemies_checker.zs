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
 * This checker watches for active enemies numbers. When active enemies number
 * exceeds the number specified in m8f_aas_group_number CVar, group_alert event
 * is emitted. When active number reaches zero, group_kill event is emitted, but
 * only if active group of enemies was detected before.
 *
 * There is a problem with enemies activating. They don't wake up immediately
 * when they see or hear the player, only when A_Look function happens in their
 * state. This class manages this problem by keeping a short history of
 * activated enemy counts, and setting a timeout before emitting the next
 * group_alert event.
 */
class aas_active_enemies_checker play
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_active_enemies_checker of( aas_event_handler   handler
                               , aas_enemies_counter counter
                               , aas_cvar            group_number
                               , int alert_event
                               , int kill_event
                               )
  {
    let result = new("aas_active_enemies_checker");

    result._handler      = handler;
    result._counter      = counter;
    result._group_number = group_number;
    result._alert_event  = alert_event;
    result._kill_event   = kill_event;

    result._is_group            = false;
    result._old_active_count    = 0;
    result._activity_statistics = aas_ring_buffer.of();

    return result;
  }

  void tick()
  {
    if (is_player_dead()) return;

    int active_enemies_count = _counter.count();
    int group_count          = _group_number.get_int();
    int newly_active_enemies = max(0, active_enemies_count - _old_active_count);

    _old_active_count = active_enemies_count;
    _timeout = max(0, _timeout - 1);

    if (_timeout == 0)
    {
      _activity_statistics.write(newly_active_enemies);
    }

    int recently_active_enemies = _activity_statistics.get_sum();

    if (recently_active_enemies >= group_count && _timeout == 0)
    {
      _is_group = true;
      _activity_statistics.clear();
      _timeout = TIMEOUT;

      on_event(_alert_event);
    }
    else if (active_enemies_count == 0 && _is_group)
    {
      _is_group = false;
      _activity_statistics.clear();

      on_event(_kill_event);
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void on_event(int event_type)
  {
    _handler.on_event(event_type);
  }

  private
  bool is_player_dead()
  {
    return players[consolePlayer].Health <= 0;
  }

  private aas_cvar _group_number;
  private int      _is_group;
  private int      _old_active_count;

  private aas_event_handler   _handler;
  private aas_enemies_counter _counter;

  private aas_ring_buffer _activity_statistics;

  const TIMEOUT = 20;
  private int _timeout;

  private int _alert_event;
  private int _kill_event;

} // class aas_active_enemies_checker

class aas_ring_buffer
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_ring_buffer of()
  {
    let result = new("aas_ring_buffer");

    result.clear();
    result._index = 0;

    return result;
  }

  void clear()
  {
    for (int i = 0; i < SIZE; ++i)
    {
      _ring[i] = 0;
    }
  }

  void write(int n)
  {
    _ring[_index] = n;

    _index = (_index + 1) % SIZE;
  }

  int get_sum() const
  {
    int result = 0;
    for (int i = 0; i < SIZE; ++i)
    {
      result += _ring[i];
    }
    return result;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  const SIZE = 20;

  private int[SIZE] _ring;
  private int       _index;

} // class aas_ring_buffer
