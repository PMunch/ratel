when not defined(nimdoc):
  import private/helpers

  const board* {.strdefine.} = ""

  static:
    echo "----------------------------------"
    echo "The current board: ", board
    echo "----------------------------------"

  generateInclude()
else:
  ## This is the main module import for working with Ratel. To use this module
  ## and any of the other modules in this library you need to specify a
  ## supported board with the `-d:board:<someboard>` switch. This can of course
  ## be put in a configuration file.
  ##
  ## Importing the board in Ratel does a couple different things. First of it
  ## defines all the pins, ports, and interfaces that your board supports.
  ## While these change depending on what your board actually supports the
  ## definitions looks a little something like this:
  ##
  ## .. code-block:: nim
  ##   const
  ##     this*: Board
  ##     I2cBus*: I2c
  ##     Serial*: SerialPort
  ##     B*: Port
  ##     C*: Port
  ##     B0*: Pin
  ##     B1*: Pin
  ##     B2*: Pin
  ##     C0*: Pin
  ##     C1*: Pin
  ##     C2*: Pin
  ##     LED* = B3
  ##
  ## All ports and interfaces are numbered, but a default is always set. So if
  ## we have more than one I2C bus on a board you would have `I2cBus1` and
  ## `I2cBus2`, but also a definition for `I2cBus` which would be an alias for
  ## either of the two. Which one depends on the board. The built-in LED is a
  ## similar story.
  ##
  ## The specific objects for these should be considered an implementation
  ## detail, and on some boards that require runtime state to operate them they
  ## might be runtime objects instead of constants. However Ratel tries to make
  ## sure to use mostly static compile-time objects and abstractions.
  ##
  ## Along with this the board also defines a `ratelBoard` constant holding the
  ## name of the board. This is used internally to verify that the specified
  ## board was actually imported correctly, but it can also be used for
  ## platform specific implementations.
  ##
  ## In addition the board has the required `passC` and `passL` flags to build
  ## your project for the specified board.
