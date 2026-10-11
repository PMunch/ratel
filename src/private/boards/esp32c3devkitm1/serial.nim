import board / io

type SerialPort* = object
  base*: uint32

template fifo(serial: SerialPort): Reg = Reg(serial.base)
template clockDivider(serial: SerialPort): Reg = Reg(serial.base + 0x14)
template status(serial: SerialPort): Reg = Reg(serial.base + 0x1C)

proc setBaudRate*(serial: static[SerialPort], baud: Hz, clock = 40.Mhz) =
  # The boot ROM clocks the port from the crystal, not from `defaultClock`
  let divider = clock.uint32 * 16 div baud.uint32
  serial.clockDivider[] = (divider shr 4) or ((divider and 0xf) shl 20)

proc init*(serial: static[SerialPort], baud = 115.2.Khz) =
  serial.setBaudRate(baud)

proc send*(serial: static[SerialPort], c: char) =
  while (serial.status[] shr 16 and 0x3ff) >= 126: discard
  serial.fifo[] = c.uint32

proc send*(serial: static[SerialPort], str: cstring) =
  for c in str:
    serial.send(c)
