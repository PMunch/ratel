import board / [io, times]

type I2c* = object

proc init*(bus: static[I2c]) =
  # SCL frequence = CPU frequency / (16 + (2 * TWBR * prescaler))
  # TWBR = (cpu / scl - 16) / 2
  twsr = 0x00
  twbr = 0x0C
  twcr.set twen, twint

proc start*(_: static[I2c]) =
  twcr.set twen, twint, twsta
  while not twcr.check twint: discard

proc stop*(_: static[I2c]) {.noinline.} =
  twcr.set twen, twint, twsto
  delayLoop(1'u8)
  #delayUs(100)

proc send*(_: static[I2c], data: uint8) =
  twdr = data
  twcr.set twen, twint
  while not twcr.check twint: discard

proc recv*(_: static[I2c], last: static[bool]): uint8 =
  when last:
    twcr.set twen, twint
  else:
    twcr.set twen, twint, twea
  while not twcr.check twint: discard
  return twdr
