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

class aas_game_action_scheduler : aas_game_actions
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_game_action_scheduler of()
  {
    return new("aas_game_action_scheduler");
  }

  override
  void save()
  {
    _is_save_scheduled = true;
  }

  override
  void take_screenshot()
  {
    _is_screenshot_scheduled = true;
  }

  void tick()
  {
    if (gameaction != ga_nothing)
    {
      return;
    }

    if (_is_screenshot_scheduled)
    {
      LevelLocals.MakeScreenShot();
      _is_screenshot_scheduled = false;
      return;
    }

    if (_is_save_scheduled)
    {
      LevelLocals.MakeAutoSave();
      _is_save_scheduled = false;
      return;
    }
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private bool _is_save_scheduled;
  private bool _is_screenshot_scheduled;

} // class aas_game_action_scheduler
