# Package

version       = "0.2.1"
author        = "Peter Munch-Ellingsen"
description   = "Nim for microcontrollers"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["ratel"]


# Dependencies

requires "nim >= 1.6.4"
requires "nimscripter"
requires "cligen"
