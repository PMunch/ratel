import board/[io, i2c, serial]
export io

const ratelBoard* = "unor3"

proc pin(port: char, num: int): Pin {.compileTime.} =
  Pin(port: Port(portChar: port), num: num)

const
  this = UnoR3()
  I2cBus* = I2c()
  Serial* = SerialPort(port: 0)
  B* = Port(portChar: 'B')
  C* = Port(portChar: 'C')
  D* = Port(portChar: 'D')
  B0* = pin('B', 0)
  B1* = pin('B', 1)
  B2* = pin('B', 2)
  B3* = pin('B', 3)
  B4* = pin('B', 4)
  B5* = pin('B', 5)
  C0* = pin('C', 0)
  C1* = pin('C', 1)
  C2* = pin('C', 2)
  C3* = pin('C', 3)
  C4* = pin('C', 4)
  C5* = pin('C', 5)
  C6* = pin('C', 6)
  D0* = pin('D', 0)
  D1* = pin('D', 1)
  D2* = pin('D', 2)
  D3* = pin('D', 3)
  D4* = pin('D', 4)
  D5* = pin('D', 5)
  D6* = pin('D', 6)
  D7* = pin('D', 7)
  LED* = B5

{.passC: "-mmcu=atmega328p".}
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

{.passL: "-mmcu=atmega328p".}
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

