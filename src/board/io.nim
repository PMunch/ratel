import "../private/helpers"

when not defined(nimdoc):
  generateInclude("io")
else:
  ## This is documentation for the IO integration. Please note that this is
  ## just documentation for the interface, different boards might have
  ## different caveats for the various procedures.
  type Board* = object
    ## Definition for the current board
  type Port* = object
    ## Definition for a port of pins
  type Pin* = object
    ## Definition of a pin
  const defaultClock* = 0.Hz ## \
    ## This is the default clock of the current board

  macro eachIt*(pins: static[openArray[Pin]], body: untyped): untyped =
    ## Copies the `body` for each pin in `pins` and defines `it` to be the
    ## current pin. Note that since this copies the body it should be used with
    ## care to not explode program size.
    discard

  macro direction*(port: static[Port]): untyped =
    ## Returns the direction of all pins in `port`. This is an integer wide
    ## enough to hold all the pins, inputs are set to `0` and outputs are set
    ## to `1`.
    discard

  macro direction*(pin: static[Pin]): untyped =
    ## Returns the direction of the given pin, `0` for input and `1` for
    ## output. The width of the returned number is dependent on the size of the
    ## port.
    discard

  macro state*(port: static[Port]): untyped =
    ## Returns the state of all pins in `port`. This is an integer wide enough
    ## to hold all the pins. If the pin is an input then high is `1` and low
    ## is `0`, if it is an input then `1` is pullup enabled and `0` is pullup
    ## disabled. If pullups can't be controlled on the board then input pins
    ## should not be considered.
    discard

  macro state*(pin: static[Pin]): untyped =
    ## Returns the state of the given pin. If the pin is an input then high is
    ## `1` and low is `0`, if it is an input then `1` is pullup enabled and `0`
    ## is pullup disabled. If pullups can't be controlled on the board then
    ## input pins should not be considered. The width of the returned number is
    ## dependent on the size of the port.
    discard

  macro output*(port: static[Port], mask = 0xff'u8): untyped =
    ## Sets the port to be outputs, the mask are the pins on the port that will
    ## be set to an output. The width of the mask is dependent on the size of
    ## the port.
    discard

  macro output*(pin: static[Pin]): untyped =
    ## Sets the pin to be an output
    discard

  macro high*(port: static[Port], mask = 0xff'u8): untyped =
    ## Sets the port to be high, the mask are the pins on the port that will be
    ## set to high. The width of the mask is dependent on the size of the port.
    discard

  macro high*(pin: static[Pin]): untyped =
    ## Sets the pin to high. This should only be used if the pin is an output.
    discard

  macro low*(port: static[Port], mask = 0xff'u8): untyped =
    ## Sets the port to be low, the mask are the pins on the port that will be
    ## set to low. The width of the mask is dependent on the size of the port.
    discard

  macro low*(pin: static[Pin]): untyped =
    ## Sets the pin to low. This should only be used if the pin is an output.
    discard

  macro input*(port: static[Port], mask = 0xff'u8): untyped =
    ## Sets the port to be inputs, the mask are the pins on the port that will
    ## be set to an input. The width of the mask is dependent on the size of
    ## the port.
    discard

  macro input*(pin: static[Pin]): untyped =
    ## Sets the pin to be an output
    discard

  template normal*(port: static[Port], mask = 0xff'u8): untyped =
    ## Disables the internal pullup resistor for the port, the mask are the
    ## pins on the port that will have the pullup disabled. Some boards might
    ## not support setting pullups. In that case this won't be defined.
    discard

  template normal*(pin: static[Pin]): untyped =
    ## Disables the internal pullup resistor for the pin. Some boards might not
    ## support setting pullups. In that case this won't be defined.
    discard

  template pullup*(port: static[Port], mask = 0xff'u8): untyped =
    ## Enables the internal pullup resistor for the port, the mask are the
    ## pins on the port that will have the pullup enabled. Some boards might
    ## not support setting pullups. In that case this won't be defined.
    discard

  template pullup*(pin: static[Pin]): untyped =
    ## Enables the internal pullup resistor for the pin. Some boards might not
    ## support setting pullups. In that case this won't be defined.
    discard

  macro read*(port: static[Port]): untyped =
    ## Reads all the values for the port, the width of the returned number
    ## depends on the size of the port. Pins that are not set as input should
    ## not be considered.
    discard

  macro read*(pin: static[Pin]): untyped =
    ## Reads the value of a pin, the width of the returned number depends on
    ## the size of the port. High is `1` and low is `0`, pins that are not set
    ## as input should not be considered.
    discard

  macro configure*(pins: static[openarray[Pin]], states: varargs[untyped]): untyped =
    ## Configures all the given pins to be a collection of states. Pins are
    ## sorted by ports and ports are set in one operation so they might not be
    ## set in the order they are specified. Conflicting states cause undefined
    ## behaviour.

  # TODO: Should probably not be in the spec, maybe define an iterator over `static[array[Pin]]` instead?
  #macro withPinAs*(loop: ForLoopStmt): untyped =
  #  ## ..code-block: nim
  #  ##   const pins = [A0, A1, B0]
  #  ##   for pin in withPinAs(pins, input, pullup):
  #  ##     let state = pin.read
  #  ##
  #  ## This expands to a loop where each pin in pins is configured to be
  #  ## `input` and `pullup` 
  #  expectKind loop, nnkForStmt
  #  let
  #    iterVar = loop[0]
  #    pins = loop[1][1]
  #    states = loop[1][2..^1]
  #    body = loop[2]
  #    iterVarType = genSym(nskType)
  #  var
  #    generateSym = bindSym("generateCaseStmt")
  #    generateInStmt = nnkCall.newTree(generateSym, newCall("high", pins), pins, iterVar)
  #    generateOutStmt = nnkCall.newTree(generateSym, newCall("high", pins), pins, iterVar)
  #    generateReadStmt = nnkCall.newTree(generateSym, newCall("high", pins), pins, iterVar, newIdentNode("read"))
  #  for state in states:
  #    generateInStmt.add state
  #    generateOutStmt.add:
  #      case state.strVal:
  #      of "input": newIdentNode("output")
  #      of "output": newIdentNode("input")
  #      of "pullup": newIdentNode("normal")
  #      of "normal": newIdentNode("pullup")
  #      of "high": newIdentNode("low")
  #      of "low": newIdentNode("high")
  #      else: newIdentNode("error")
  #  result = quote do:
  #    type `iterVarType` = int
  #    for i in 0..`pins`.high:
  #      let `iterVar` = `iterVarType`(i)
  #      template read(_: `iterVarType`): untyped {.used.} =
  #        `generateReadStmt`
  #      `generateInStmt`
  #      `body`
  #      `generateOutStmt`
  #  #echo result.repr

  macro check*(x: uint8, flags: varargs[untyped]): untyped =
    ## Returns true if any of the flags are not 0. A flag is the bit position
    ## in the number so `register.check 2` would check the third bit in the
    ## number. This is typically used to check values in registers.
    discard

  macro set*(x: uint8, flags: varargs[untyped]): untyped =
    ## Sets `x` to have only the flags given to be 1, all the others are set to
    ## 0.
    discard

  macro unset*(x: uint8, flags: varargs[untyped]): untyped =
    ## Sets `x` to have only the flags given to be 0, all the others are set to
    ## 1.
    discard

  macro update*(x: uint8, flags: varargs[untyped]): untyped =
    ## Sets the flags in `x` to 1, not touching flags which are not listed.
    discard

  # TODO: This should be defined as a `setClockSpeed` macro which does the
  # calculation.
  #template cpuPrescale*(n: static[uint8]): untyped =
  #  clkpr = 0x80
  #  clkpr = n

  type Hz* = distinct uint32
    ## A unit for Hertz, used to set clock speeds of interfaces and the chip
    ## itself.

  template Mhz*(n: untyped): untyped =
    ## Converts Mhz into Hz, used as `let newClock = 80.Mhz`
    discard
  template Khz*(n: untyped): untyped =
    ## Converts Khz into Hz, used as `let newClock = 100.Khz`
    discard

when not declared(direction):
  {.error: "Selected board does not implement the `direction` procedure".}
when not declared(state):
  {.error: "Selected board does not implement the `state` procedure".}

