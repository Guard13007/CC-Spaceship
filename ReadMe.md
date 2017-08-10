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

### consoles

These are classes for the different kinds of console each monitor can have (with
the exception of `select_console` which is stored in the `src` directory).

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

### interface

Classes for interfaces used by multiple consoles.

### util

Utility functions.
