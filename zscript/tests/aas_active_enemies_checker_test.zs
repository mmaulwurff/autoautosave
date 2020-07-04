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

class aas_test play abstract
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  void run()
  {
    aas_log.print(String.Format("Running %s...", GetClassName()));
    _run();
  }

  virtual
  void _run()
  {

  }

} // class aas_test

class aas_mock_handler : aas_event_handler
{

  static
  aas_mock_handler of()
  {
    let result = new("aas_mock_handler");
    result._count = 0;
    return result;
  }

// public: /////////////////////////////////////////////////////////////////////////////////////////

  override
  void on_event(int event_type)
  {
    ++_count;
  }

  int get_count()
  {
    return _count;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private int _count;

} // class aas_mock_handler

class aas_mock_counter : aas_enemies_counter
{

  static
  aas_mock_counter of()
  {
    return new("aas_mock_counter");
  }

// public: /////////////////////////////////////////////////////////////////////////////////////////

  override
  int count()
  {
    return _count;
  }

  void set_count(int count)
  {
    _count = count;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private int _count;

} // class aas_mock_counter

class aas_active_enemies_checker_test : aas_test
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  override
  void _run()
  {
    let handler = aas_mock_handler.of();
    let counter = aas_mock_counter.of();
    let checker = aas_active_enemies_checker.of(handler, counter);

    for (int i = 0; i < 20; ++i)
    {
      Console.Printf("Tick #%d", i);
      counter.set_count(i * 10);
      checker.tick();
    }

    if (handler.get_count() != 1)
    {
      ThrowAbortException("must be only one event, got %d", handler.get_count());
    }
  }

} // class aas_active_enemies_checker_test
