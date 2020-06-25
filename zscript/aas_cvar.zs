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
 * This class provides access to a user or server Cvar.
 *
 * Accessing Cvars through this class is faster because calling Cvar.GetCvar()
 * is costly. This class caches the result of Cvar.GetCvar() and handles
 * loading a savegame.
 */
class aas_cvar
{

// public: /////////////////////////////////////////////////////////////////////////////////////////

  static
  aas_cvar of(String name, PlayerInfo player = NULL)
  {
    let result = new("aas_cvar");

    result._player = player;
    result._name   = name;
    result._cvar   = NULL;

    return result;
  }

  String get_string() { load(); return _cvar.GetString(); }
  bool   get_bool()   { load(); return _cvar.GetInt();    }
  int    get_int()    { load(); return _cvar.GetInt();    }
  double get_double() { load(); return _cvar.GetFloat();  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private
  void load()
  {
    if (is_loaded()) return;

    _cvar = Cvar.GetCvar(_name, _player);

    if (!is_loaded())
    {
      aas_log.error(String.Format("cvar %s not found", _name));
    }
  }

  private
  bool is_loaded()
  {
    return (_cvar != NULL);
  }

  private PlayerInfo     _player;
  private String         _name;
  private transient Cvar _cvar;

} // class aas_cvar
