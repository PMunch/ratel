import board / [io, times]

type I2c* = object
  data*: Pin
  clk*: Pin

let # Maybe make this a const..
  Send8Bits = (1'u8 shl usisif) or (1'u8 shl usioif) or (1'u8 shl usipf) or (1'u8 shl usidc) or 0x0'u8 shl usicnt0
  Send1Bits = (1'u8 shl usisif) or (1'u8 shl usioif) or (1'u8 shl usipf) or (1'u8 shl usidc) or 0xe'u8 shl usicnt0

template delay2() = delayUs(2)
template delay4() = delayUs(1)
template tick() {.dirty.} = usicr.set usiwm1, usics1, usiclk, usitc # Set usitc to produce clock, rest is same as in the initializer

proc init*(bus: static[I2c]) =
  # SCL frequence = CPU frequency / (16 + (2 * TWBR * prescaler))
  # TWBR = (cpu / scl - 16) / 2
  #twsr = 0x00
  #twbr = 0x0C
  #twcr.set twen, twint
  [bus.data, bus.clk].configure(output, pullup)
  usidr = 0xff
  usicr.set usiwm1, usics1, usiclk # Wire-mode 1 = i2c, usics1 + usiclk = software strobe clock source
  usisr.set usisif, usioif, usipf, usidc # Clear flags, reset counter

proc start*(bus: static[I2c]) =
  # Release SCL to ensure that repeated starts can be run
  bus.clk.high()
  while bus.clk.read == 0: discard
  delay4()

  # Generate start condition
  bus.data.low()
  delay4()
  bus.clk.low()
  bus.data.high()
  while not usisr.check(usisif): discard

proc stop*(bus: static[I2c]) {.noinline.} =
  bus.data.low()
  bus.clk.high()
  while bus.clk.read == 0: discard
  delay4()
  bus.data.high()
  delay2()

template doWhile(body, condition: untyped): untyped =
  while true:
    body
    if not condition: break

proc transfer(bus: static[I2c]) =
  # Transfer data in USIDR according to USISR
  doWhile:
    delay2()
    tick()
    while bus.clk.read == 0: discard # Waiting for SCL to go high
    delay4()
    tick()
  do: not usisr.check usioif # Repeat clock generation at SCL until the counter overflows and a byte is transferred
  delay2()

proc transferRecv(bus: static[I2c]): uint8 =
  transfer(bus)
  result = usidr
  usidr = 0xff
  bus.data.output()

  #usisr.set usioif # Clear overflow flag

proc send*(bus: static[I2c], data: uint8) =
  bus.clk.low()
  usidr = data
  usisr = Send8Bits
  transfer(bus)
  bus.data.input()
  usisr = Send1Bits
  let nack = (transferRecv(bus) and 1)

proc recv*(bus: static[I2c], last: static[bool]): uint8 =
  bus.data.input()
  usisr = Send8Bits
  result = transferRecv(bus)
  when last:
    usidr = 0xff
  else:
    usidr = 0x00
  usisr = Send1Bits
  transfer(bus)
