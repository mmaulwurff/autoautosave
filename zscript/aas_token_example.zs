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
 * Universal Autoautosave Tokens can be used by map and mod authors. When a
 * player walks over such a token, it causes a generic Autoautosave event (with
 * a message like "Something rare!").
 *
 * Typically, Universal Autoautosave Token is an invisible object.
 *
 * The advantage of saving via a Universal Autoautosave Token instead of other
 * saving scripts is that a token can cause a text or voice message and a
 * screenshot according to player settings. Also, Autoautosave framework ensures
 * that saves aren't happening too often, if the player so desires.
 *
 * A mod that utilizes Universal Autoautosave Tokens doesn't depend on
 * Autoautosave and can be loaded without it.
 *
 * Universal Autosave Tokens come it two flavors:
 * 1. Pickup Tokens;
 * 2. Instant Tokens.
 *
 * How it works: Autoautosave watches for things spawns, and if the beginning of
 * the class name of the spawned thing matches one of the signatures,
 * Autoautosave acts accordingly.
 */

/**
 * This is an example of Pickup Universal Autoautosave Token.
 *
 * The Pickup Universal Autoautosave Token class name must start with
 * "aas_pickup_".
 *
 * How to use:
 * 1. Define a class that starts with "aas_pickup_";
 * 2. Spawn this class on a spot, and autoautosave will happen when the player
 *    walks over this spot.
 */
class aas_pickup_example : Actor
{

  // Universal Autoautosave Tokens do not have to exist after being spawned.
  States
  {
  Spawn:
    TNT1 A 0;
    stop;
  }

} // class aas_pickup_example

/**
 * This is an example of Instant Universal Autoautosave Instant Token.
 *
 * The Pickup Universal Autoautosave Token class name must start with
 * "aas_instant_".
 *
 * How to use:
 * 1. Define a class that starts with "aas_instant_";
 * 2. Spawn this class, and autoautosave happens immediately.
 */
class aas_instant_example : Actor
{

  // Universal Instant Autoautosave Tokens do not have to exist after being
  // spawned.
  States
  {
  Spawn:
    TNT1 A 0;
    stop;
  }

} // class aas_instant_example
