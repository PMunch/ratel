import board / [ io, i2c]
export io

const ratelBoard* = "digispark"

proc pin(port: char, num: int): Pin {.compileTime.} =
  Pin(port: Port(portChar: port), num: num)

const
  this = Board()
  B* = Port(portChar: 'B')
  B0* = pin('B', 0)
  B1* = pin('B', 1)
  B2* = pin('B', 2)
  B3* = pin('B', 3)
  B4* = pin('B', 4)
  B5* = pin('B', 5)
  LED* = B1
  UsiClk* = B2
  UsiData* = B0
  UsiMiso* = B1
  UsiMosi* = B0
  I2cBus* = I2c(data: UsiData, clk: UsiClk)

{.passC: "-mmcu=attiny85".}
{.passC:  "-I.".}
{.passC:  "-DF_CPU=16500000UL".}
{.passC:  "-Os".}
{.passC:  "-ffunction-sections".}
{.passC:  "-fpack-struct".}
{.passC:  "-fshort-enums".}
{.passC:  "-flto".}
{.passC:  "-Wall".}
{.passC:  "-Wstrict-prototypes".}
{.passC:  "-fno-tree-scev-cprop".}

{.passL: "-mmcu=attiny85".}
{.passL:  "-I.".}
{.passL:  "-DF_CPU=16500000UL".}
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

