import board/[io, i2c, serial]
export io

const ratelBoard* = "teensy"

proc pin(port: char, num: int): Pin {.compileTime.} =
  Pin(port: Port(portChar: port), num: num)

const
  this = Board()
  I2cBus* = I2c()
  Serial* = SerialPort(port: 1)
  D* = Port(portChar: 'D')
  B* = Port(portChar: 'B')
  F* = Port(portChar: 'F')
  C* = Port(portChar: 'C')
  E* = Port(portChar: 'E')
  B0* = pin('B', 0)
  B1* = pin('B', 1)
  B2* = pin('B', 2)
  B3* = pin('B', 3)
  B4* = pin('B', 4)
  B5* = pin('B', 5)
  B6* = pin('B', 6)
  B7* = pin('B', 7)
  D0* = pin('D', 0)
  D1* = pin('D', 1)
  D2* = pin('D', 2)
  D3* = pin('D', 3)
  D4* = pin('D', 4)
  D5* = pin('D', 5)
  D6* = pin('D', 6)
  D7* = pin('D', 7)
  F0* = pin('F', 0)
  F1* = pin('F', 1)
  F4* = pin('F', 4)
  F5* = pin('F', 5)
  F6* = pin('F', 6)
  F7* = pin('F', 7)
  C6* = pin('C', 6)
  C7* = pin('C', 7)
  E6* = pin('E', 6)
  LED* = D6

{.passC: "-mmcu=atmega32u4".}
{.passC:  "-I.".}
{.passC:  "-DF_CPU=16000000UL".}
{.passC:  "-Os".}
{.passC:  "-ffunction-sections".}
{.passC:  "-fpack-struct".}
{.passC:  "-fshort-enums".}
{.passC:  "-flto".}
{.passC:  "-Wall".}
{.passC:  "-Wstrict-prototypes".}
{.passC:  "-fno-tree-scev-cprop".}

{.passL: "-mmcu=atmega32u4".}
{.passL:  "-I.".}
{.passL:  "-DF_CPU=16000000UL".}
{.passL:  "-Os".}
{.passL:  "-ffunction-sections".}
{.passL:  "-fpack-struct".}
{.passL:  "-fshort-enums".}
{.passL:  "-flto".}
{.passL:  "-Wall".}
{.passL:  "-Wstrict-prototypes".}
{.passL:  "-Wl,--relax".}
{.passL:  "-Wl,--gc-sections".}
{.passL:  "-lm".}

