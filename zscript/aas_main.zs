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
 * This is an entry point for Autoautosave.
 */
class aas_main : EventHandler
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  override
  void NetworkProcess(ConsoleEvent event)
  {
    Array<String> command;
    event.Name.Split(command, ":");

    // all known commands has 1 argument.
    if (command.Size() != 2) return;

    if (command[0] == "aas_manual_save")
    {
      int event_type = command[1].ToInt();
      _event_source.on_event(event_type);
    }
    else if (command[0] == "aas_log")
    {
      aas_log.print(command[1]);
    }
    else if (command[0] == "aas_test")
    {
      aas_test(new(command[1])).run();
    }
  }

  override
  void PlayerEntered(PlayerEvent event)
  {
    if (event.PlayerNumber != consolePlayer) { return; }
    _event_source = aas_event_source.of();
    _event_source.on_event(aas_event.level_start);
  }

  override
  void WorldThingSpawned(WorldEvent event)
  {
    if (event == NULL || event.thing == NULL) { return; }

    _event_source.on_thing_spawned(event.thing);
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private aas_event_source _event_source;

} // class aas_main : EventHandler
