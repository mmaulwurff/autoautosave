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
 * This class represents a moment in time, in game ticks.
 */
class aas_timestamp play
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_timestamp of()
  {
    let result = new("aas_timestamp");
    result._time = 0;
    return result;
  }

  void set_time(int time)
  {
    _time = time;
  }

  int get_time()
  {
    return _time;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private int _time;

} // class aas_timestamp
