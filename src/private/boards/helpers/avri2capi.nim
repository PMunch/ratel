proc writeRegister*(bus: static[I2c], address, register, data: uint8) =
  bus.start()
  bus.send(address)
  bus.send(register)
  bus.send(data)
  bus.stop()

proc readRegister*(bus: static[I2c], address, register: uint8): uint8 =
  bus.start()
  bus.send(address)
  bus.send(register)
  bus.stop()

  bus.start()
  bus.send(address or 0x01)
  result = bus.recv(true)
  bus.stop()
