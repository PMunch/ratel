import "../private/helpers"

when not defined(nimdoc):
  generateInclude("i2c")
else:
  ## This is documentation for the i2c integration. Please note that this is
  ## just documentation for the interface, different boards might have
  ## different caveats for the various procedures.

  type I2c* = object
    ## This is the type of an I2c bus, the object should be passed to all i2c
    ## procedures. If your board requires runtime information to manage the i2c
    ## bus this will be kept in this object, and the below procedures won't be
    ## defined to use a `static` object. The board should define available i2c
    ## buses.

proc init*(bus: static[I2c]) {.documentation.} =
  ## Initialises the I2C bus

proc start*(bus: static[I2c]) {.documentation.} =
  ## Starts an I2C data transfer

proc stop*(bus: static[I2c]) {.documentation.} =
  ## Stops an I2C data transfer

proc send*(bus: static[I2c], data: uint8) {.documentation.} =
  ## Sends one raw byte of data

proc recv*(bus: static[I2c], last: static[bool]): uint8 {.documentation.} =
  ## Receives one raw byte of data, the last argument determines if this is
  ## the last byte to read or not.

proc writeRegister*(bus: static[I2c], address, register, data: uint8) {.documentation.} =
  ## Writes a byte of data to the device with the given address, into the
  ## register.

proc readRegister*(bus: static[I2c], address, register: uint8): uint8 {.documentation.} =
  ## Reads a byte from the device with the given address at the given
  ## register.
