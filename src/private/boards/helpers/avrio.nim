macro eachIt*(pins: static[openArray[Pin]], body: untyped): untyped =
  result = newStmtList()
  let it = newIdentNode("it")
  for pin in pins:
    result.add quote do:
      block:
        const `it` = `pin`
        `body`

template expandPin(register: string): untyped {.dirty.} =
  let
    port = newIdentNode(register & $pin.port.portChar)
    num = newLit(pin.num)

template expandPort(register: string): untyped {.dirty.} =
  let portReg = newIdentNode(register & $port.portChar)

# TODO: Rewrite to work on device object

macro direction*(port: static[Port]): untyped =
  expandPort("ddr")
  quote do:
    `portReg`

macro direction*(pin: static[Pin]): untyped =
  #expandPin("ddr")
  let
    port = pin.port
    mask = newLit(1'u8 shl pin.num)
  quote do:
    direction(`port`) and `mask`

macro state*(port: static[Port]): untyped =
  expandPort("port")
  quote do:
    `portReg`

macro state*(pin: static[Pin]): untyped =
  #expandPin("ddr")
  let
    port = pin.port
    mask = newLit(1'u8 shl pin.num)
  quote do:
    state(`port`) and `mask`

macro output*(port: static[Port], mask = 0xff'u8): untyped =
  expandPort("ddr")
  quote do:
    `portReg` = `mask`

macro output*(pin: static[Pin]): untyped =
  let
    port = pin.port
    mask = newLit(1'u8 shl pin.num)
  quote do:
    output(`port`, direction(`port`) or `mask`)

macro high*(port: static[Port], mask = 0xff'u8): untyped =
  expandPort("port")
  quote do:
    `portReg` = `mask`

macro high*(pin: static[Pin]): untyped =
  let
    port = pin.port
    mask = newLit(1'u8 shl pin.num)
  quote do:
    high(`port`, state(`port`) or `mask`)

macro low*(port: static[Port], mask = 0xff'u8): untyped =
  expandPort("port")
  quote do:
    `portReg` = `mask`

macro low*(pin: static[Pin]): untyped =
  let
    port = pin.port
    mask = newLit(1'u8 shl pin.num)
  quote do:
    low(`port`, state(`port`) and not `mask`)

macro input*(port: static[Port], mask = 0xff'u8): untyped =
  expandPort("ddr")
  quote do:
    `portReg` = `mask`

macro input*(pin: static[Pin]): untyped =
  let
    port = pin.port
    mask = newLit(1'u8 shl pin.num)
  quote do:
    input(`port`, direction(`port`) and not `mask`)

template normal*(port: static[Port], mask = 0xff'u8): untyped =
  low(port, mask)

template normal*(pin: static[Pin]): untyped =
  low(pin)

template pullup*(port: static[Port], mask = 0xff'u8): untyped =
  high(port, mask)

template pullup*(pin: static[Pin]): untyped =
  high(pin)

macro read*(port: static[Port]): untyped =
  expandPort("pin")
  quote do:
    `portReg`

macro read*(pin: static[Pin]): untyped =
  let
    port = pin.port
    mask = newLit(1'u8 shl pin.num)
  quote do:
    read(`port`) and `mask`

# TODO: Rewrite to use the Port versions above
macro configure*(pins: static[openarray[Pin]], states: varargs[untyped]): untyped =
  result = newStmtList()
  var ports: Table[char, seq[int]]
  for pin in pins:
    ports.mgetOrPut(pin.port.portChar, @[]).add pin.num
  for state in states:
    expectKind state, nnkIdent
    for portName, pins in ports.pairs:
      var valueMask = newLit(0)
      for pin in pins:
        valueMask = quote do:
          `valueMask` or (1'u8 shl `pin`)
      case state.strVal:
      of "input":
        let port = newIdentNode("ddr" & $portName)
        result.add quote do:
          `port` = `port` and not `valueMask`
      of "output":
        let port = newIdentNode("ddr" & $portName)
        result.add quote do:
          `port` = `port` or `valueMask`
      of "pullup":
        let port = newIdentNode("port" & $portName)
        result.add quote do:
          `port` = `port` or `valueMask`
      of "normal":
        let port = newIdentNode("port" & $portName)
        result.add quote do:
          `port` = `port` and not `valueMask`
      of "high":
        let port = newIdentNode("port" & $portName)
        result.add quote do:
          `port` = `port` or `valueMask`
      of "low":
        let port = newIdentNode("port" & $portName)
        result.add quote do:
          `port` = `port` and not `valueMask`
      else: doAssert state.strVal in ["input", "output", "pullup", "normal", "high", "low"]
  #echo result.repr

macro generateCaseStmt(pinsCount: static[int], pinsname: untyped, iterVar: untyped, states: varargs[untyped]): untyped =
  result = quote do:
    case range[0..`pinsname`.high](`iterVar`):
    else: discard
  result.del 1
  for i in 0..pinsCount:
    var body = newStmtList()
    for state in states:
      body.add quote do:
        `state`(`pinsname`[`i`])
    result.add nnkOfBranch.newTree(newLit(i), body)
  #echo result.repr

macro withPinAs*(loop: ForLoopStmt): untyped =
  expectKind loop, nnkForStmt
  let
    iterVar = loop[0]
    pins = loop[1][1]
    states = loop[1][2..^1]
    body = loop[2]
    iterVarType = genSym(nskType)
  var
    generateSym = bindSym("generateCaseStmt")
    generateInStmt = nnkCall.newTree(generateSym, newCall("high", pins), pins, iterVar)
    generateOutStmt = nnkCall.newTree(generateSym, newCall("high", pins), pins, iterVar)
    generateReadStmt = nnkCall.newTree(generateSym, newCall("high", pins), pins, iterVar, newIdentNode("read"))
  for state in states:
    generateInStmt.add state
    generateOutStmt.add:
      case state.strVal:
      of "input": newIdentNode("output")
      of "output": newIdentNode("input")
      of "pullup": newIdentNode("normal")
      of "normal": newIdentNode("pullup")
      of "high": newIdentNode("low")
      of "low": newIdentNode("high")
      else: newIdentNode("error")
  result = quote do:
    type `iterVarType` = int
    for i in 0..`pins`.high:
      let `iterVar` = `iterVarType`(i)
      template readPin(_: `iterVarType`): untyped {.used.} =
        `generateReadStmt`
      `generateInStmt`
      `body`
      `generateOutStmt`
  #echo result.repr

template expandFlags(flags: untyped): untyped =
  var flagCollection {.inject.} = newLit(0'u8)
  for flag in flags:
    flagCollection = nnkInfix.newTree(newIdentNode("or"),
      flagCollection, nnkInfix.newTree(newIdentNode("shl"), newLit(1'u8), flag))
  #echo flagCollection.repr

macro check*(x: uint8, flags: varargs[untyped]): untyped =
  expandFlags(flags)
  quote do:
    (`x` and (`flagCollection`)) != 0

macro set*(x: uint8, flags: varargs[untyped]): untyped =
  expandFlags(flags)
  quote do:
    `x` = `flagCollection`

macro unset*(x: uint8, flags: varargs[untyped]): untyped =
  expandFlags(flags)
  quote do:
    `x` = not `flagCollection`

macro update*(x: uint8, flags: varargs[untyped]): untyped =
  expandFlags(flags)
  quote do:
    `x` = `x` or `flagCollection`

template cpuPrescale*(n: static[uint8]): untyped =
  clkpr = 0x80
  clkpr = n

type Hz* = distinct uint32

template Mhz*(n: untyped): untyped = Hz(n * 1_000_000)
template Khz*(n: untyped): untyped = Hz(n * 1_000.0)
