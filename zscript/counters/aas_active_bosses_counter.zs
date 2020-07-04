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

class aas_active_bosses_counter : aas_enemies_counter
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_active_bosses_counter of()
  {
    let result = new("aas_active_bosses_counter");
    result._min_boss_health = aas_cvar.of("m8f_aas_min_boss_health");
    return result;
  }

  override
  int count()
  {
    int result = 0;
    let i = ThinkerIterator.Create("Actor", Thinker.STAT_DEFAULT);
    Actor a;
    int min_boss_health = _min_boss_health.get_int();

    while (a = Actor(i.Next()))
    {
      result += (is_active(a) && a.SpawnHealth() >= min_boss_health);
    }

    return result;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  static
  bool is_active(Actor a)
  {
    return (a.bIsMonster && a.Target != NULL && a.Health > 0);
  }

  private aas_cvar _min_boss_health;

} // class aas_active_bosses_counter
