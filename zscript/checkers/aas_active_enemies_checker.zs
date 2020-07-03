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

class aas_active_enemies_checker play
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_active_enemies_checker of(aas_event_handler handler, aas_enemies_counter counter)
  {
    let result = new("aas_active_enemies_checker");

    result._group_number     = aas_cvar.of("m8f_aas_group_number");
    result._is_group         = false;
    result._old_active_count = 0;

    result._handler = handler;
    result._counter = counter;

    return result;
  }

  void tick()
  {
    check_active_enemies_count();
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void check_active_enemies_count()
  {
    int active_enemies_count = _counter.count();
    int group_count          = _group_number.get_int();

    if (active_enemies_count >= group_count)
    {
      _is_group = true;
    }

    int newly_active_enemies = active_enemies_count - _old_active_count;
    if (newly_active_enemies >= group_count)
    {
      on_event(aas_event.group_alert);
    }
    else if (active_enemies_count == 0)
    {
      if (_is_group)
      {
        on_event(aas_event.group_kill);
      }
      _is_group = false;
    }

    _old_active_count = active_enemies_count;
  }

  private
  void on_event(int event_type)
  {
    _handler.on_event(event_type);
  }

  private aas_cvar _group_number;
  private int      _is_group;
  private int      _old_active_count;

  private aas_event_handler   _handler;
  private aas_enemies_counter _counter;

} // class aas_active_enemies_checker
