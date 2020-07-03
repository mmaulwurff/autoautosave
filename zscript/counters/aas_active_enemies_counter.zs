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

class aas_active_enemies_counter : aas_enemies_counter
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_active_enemies_counter of()
  {
    return new("aas_active_enemies_counter");
  }

  override
  int count()
  {
    int result = 0;
    let i = ThinkerIterator.Create("Actor", Thinker.STAT_DEFAULT);
    Actor a;

    while (a = Actor(i.Next()))
    {
      result += is_active(a);
    }

    return result;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private static
  bool is_active(Actor a)
  {
    return (a.bIsMonster && a.Target != NULL && a.Health > 0);
  }

} // class aas_active_enemies_counter
