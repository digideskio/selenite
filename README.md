# Selenite

Selenite is a multi-purpose set of Lua extensions developed to be used in the [Sandcat Browser](https://github.com/felipedaragon/sandcat) but that can also be used separately with any application. Currently, this library extends Lua with [over 60 functions](https://github.com/felipedaragon/selenite/blob/master/docs/functions.md) and some useful classes. The project's goal is to make the development of Lua applications easier and to push the boundaries of the Lua language to do innovative things. This will always be a work in progress with new additions and regular updates.

**Name Origin:** The name Selenite comes from the Greek words selene and lithos meaning "moon stone".

## Usage

To use Selenite, you just need to load the library using `require "Selenite"`. After this you can use any of the library's functions. For a list of functions, see [here](https://github.com/felipedaragon/selenite/blob/master/docs/functions.md).

### Classes

All Selenite classes (described in `docs\classes.*`) have a "new" method that must be used for creating the object and a "release" method for freeing it.

## Download

* [Windows](https://syhunt.websiteseguro.com/pub/downloads/selenite-1.5-pre1.zip) - 32-bit & 64-bit binaries

## Dependencies

For compiling Selenite you will need [Catarinka](https://github.com/felipedaragon/catarinka), [pLua](https://github.com/felipedaragon/pLua-XE) and  [LibTar](http://www.destructor.de/libtar/).

## License #

Selenite is available under the [MIT license](http://opensource.org/licenses/MIT).

Copyright (c) Felipe Daragon, 2015