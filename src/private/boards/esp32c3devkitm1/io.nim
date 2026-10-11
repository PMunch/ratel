type
  Volatile {.importc: "volatile unsigned int", nodecl.} = uint32
  Reg* = distinct uint32
  Pin* = object
    num*: int
  Hz* = distinct uint32

template `[]`*(reg: Reg): uint32 = cast[ptr Volatile](reg)[]
template `[]=`*(reg: Reg, value: uint32) = cast[ptr Volatile](reg)[] = value

const
  gpioOut* = Reg 0x6000_4004
  gpioOutSet* = Reg 0x6000_4008
  gpioOutClear* = Reg 0x6000_400C
  gpioEnable* = Reg 0x6000_4020
  gpioEnableSet* = Reg 0x6000_4024
  gpioEnableClear* = Reg 0x6000_4028
  gpioIn* = Reg 0x6000_403C

  # Fields of a pin's IO MUX register
  pullupEnable = 1'u32 shl 8
  inputEnable = 1'u32 shl 9
  function = 7'u32 shl 12
  gpioFunction = 1'u32 shl 12

template mask(pin: Pin): uint32 = 1'u32 shl pin.num
template ioMux(pin: Pin): Reg = Reg(0x6000_9004 + 4 * pin.num)
template outSelect(pin: Pin): Reg = Reg(0x6000_4554 + 4 * pin.num)

template direction*(pin: static[Pin]): uint32 = gpioEnable[] and pin.mask
template state*(pin: static[Pin]): uint32 = gpioOut[] and pin.mask
template read*(pin: static[Pin]): uint32 = gpioIn[] and pin.mask
template high*(pin: static[Pin]) = gpioOutSet[] = pin.mask
template low*(pin: static[Pin]) = gpioOutClear[] = pin.mask
template pullup*(pin: static[Pin]) = pin.ioMux[] = pin.ioMux[] or pullupEnable
template normal*(pin: static[Pin]) = pin.ioMux[] = pin.ioMux[] and not pullupEnable

template output*(pin: static[Pin]) =
  pin.ioMux[] = pin.ioMux[] and not function or gpioFunction
  pin.outSelect[] = 0x80 # Driven by gpioOut rather than a peripheral
  gpioEnableSet[] = pin.mask

template input*(pin: static[Pin]) =
  pin.ioMux[] = pin.ioMux[] and not function or gpioFunction or inputEnable
  gpioEnableClear[] = pin.mask

template Mhz*(n: untyped): untyped = Hz(n * 1_000_000)
template Khz*(n: untyped): untyped = Hz(n * 1_000.0)

const defaultClock* = 160.Mhz
