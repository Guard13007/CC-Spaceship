# CC-Starship

A project to make a ComputerCraft-based multiplayer starship simulator.

## Installation

Copy `src` and `library` folders to the root of a ComputerCraft computer. Then
either copy `startup` as well, or run `src/main.lua` yourself. Connect monitors
to use them.

## Notes / ToDo

Organized by sub-folder of `src`, these are notes about the code and an informal
todo list.

### apis

Right now, just a blank file called `consoles` which allows all files to access
the `consoles` table via CC's `os.loadAPI()`.

### bin

Programs to be run from the `terminal` console.

- `moff` Turns all monitors off and clears all consoles. You can tap them to
  turn them back on.
- `soff` Turns the ship off. Dangerous! D:

### consoles

These are classes for the different kinds of console each monitor can have (with
the exception of `select_console` which is stored in the `src` directory).

- helm: Provides an interface displaying basic data about what is near the ship,
  current velocity, and controls for changing velocity.
- lib_access: Provides a lookup and viewer for information in the ship's library
  computer (see files in `library` folder).
- terminal: Provides a terminal interface for running commands on the computer
  directly. Intended as a last-ditch backup or for debugging.

### env

These are special objects emulating their respective CC APIs so that the
`terminal` console works.

This is a list of APIs I may need to emulate for the `terminal` to function
better (not require special programs):

- [x] [shell](http://www.computercraft.info/wiki/Shell_(API))
- [ ] [fs](http://www.computercraft.info/wiki/Fs_(API))
- [ ] [help](http://www.computercraft.info/wiki/Help_(API))
- [ ] [io](http://www.computercraft.info/wiki/IO_(API))
- [ ] [multishell](http://www.computercraft.info/wiki/Multishell_(API))
- [ ] [os](http://www.computercraft.info/wiki/OS_(API))
- [ ] [paintutils](http://www.computercraft.info/wiki/Paintutils_(API))
- [ ] [peripheral](http://www.computercraft.info/wiki/Peripheral_(API))
- [ ] [term](http://www.computercraft.info/wiki/Term_(API))
- [ ] [textutils](http://www.computercraft.info/wiki/Textutils_(API))
- [ ] [window](http://www.computercraft.info/wiki/Window_(API))

#### shell

Note that my implementation of the `shell` API within the emulated environment
is minimal. As this environment is supposed to be primarily for internal use, I
am not worried about full functionality. Bear that in mind when trying to run
external programs or writing your own.

### interface

Classes for interfaces used by multiple consoles.

- `adv_keypad`: A keypad that takes 4x5 area and has support for setting up to 4
  modes in addition to a number (display is last 3 digits of the number).
- `basic_keypad`: A keypad that takes 3x5 area and displays last 3 digits of
  number.
- `keyboard`: A keyboard that takes the bottom half of the screen and supports
  ASCII input. Additionally, contains ability to add scroll keys to keyboard.
  TODO: Add symbols. (There is a `#` key used to access special symbols that
  does not function yet.)

### util

Utility functions.

- `console`: Utilities for writing to monitors.
- `String`: Extensions to the string library.
- `Table`: Extensions to the table library. Note: Not currently in use.
