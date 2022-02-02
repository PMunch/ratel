import "../private/helpers"

when not defined(nimdoc):
  generateInclude("serial")
else:
  ## This is documentation for the serial integration. Please note that this is
  ## just documentation for the interface, different boards might have
  ## different caveats for the various procedures.
  type SerialPort* = object
    ## This is the type of a serial port, the object should be passed to all
    ## serial procedures. If your board requires runtime information to manage
    ## the serial port this will be kept in this object, and the below
    ## procedures won't be defined to use a `static` object. The board should
    ## define available serial ports.

proc setBaudRate*(serial: static[SerialPort], baud: Hz, clock = defaultClock) {.documentation.} =
  ## Sets the baud rate of the serial port. The actual baud rate might be
  ## dependent on whether or not the serial port is in "double speed" mode. If
  ## no clock is passed in the default clock for the board is used, so if the
  ## board is clocked differently the serial port speed will not be correct.

proc init*(serial: static[SerialPort], baud = 115.2.Khz) {.documentation.} =
  ## Initializes the serial port to receive and transfer, disables double speed
  ## mode, and sets the baud rate to the given rate.

proc send*(serial: static[SerialPort], c: char) {.documentation.} =
  ## Sends the given character over the given serial port. If this can be done
  ## without waiting for the byte to be completely sent it will return
  ## immediately.

proc send*(serial: static[SerialPort], str: cstring) {.documentation.} =
  ## Sends the given string over the given serial port.

proc send*(serial: static[SerialPort], str: Progmem[cstring], size: int) {.documentation.} =
  ## Sends `size` bytes of the given string stored in program memory. Typically
  ## you won't create a `Progmem[cstring]` yourself but rather obtain one from
  ## somewhere else.

when defined(nimdoc):
  template send*[N: static[int]](serial: static[SerialPort], data: ProgmemString[N]) =
    ## Sends the full string stored in program memory over the serial port.
