import board / [io, serial]
export io

const ratelBoard* = "esp32c3devkitm1"

const
  Serial* = SerialPort(base: 0x6000_0000)
  IO0* = Pin(num: 0)
  IO1* = Pin(num: 1)
  IO2* = Pin(num: 2)
  IO3* = Pin(num: 3)
  IO4* = Pin(num: 4)
  IO5* = Pin(num: 5)
  IO6* = Pin(num: 6)
  IO7* = Pin(num: 7)
  IO8* = Pin(num: 8)
  IO9* = Pin(num: 9)
  IO10* = Pin(num: 10)
  IO18* = Pin(num: 18)
  IO19* = Pin(num: 19)
  IO20* = Pin(num: 20)
  IO21* = Pin(num: 21)

{.passC: "-march=rv32imc_zicsr -mabi=ilp32".}
{.passC: "-ffunction-sections".}
{.passC: "-fdata-sections".}

{.passL: "-march=rv32imc_zicsr -mabi=ilp32".}
{.passL: "-nostartfiles".}
{.passL: "-Wl,--gc-sections".}
# The linker script sits in the folder named after this file
{.passL: "-T" & currentSourcePath[0..^5] & "/board.ld".}

const
  rtcWatchdog = Reg 0x6000_8090
  rtcWatchdogProtect = Reg 0x6000_80A8
  superWatchdog = Reg 0x6000_80AC
  superWatchdogProtect = Reg 0x6000_80B0
  timerWatchdog = Reg 0x6001_F048
  timerWatchdogProtect = Reg 0x6001_F064
  cpuClock = Reg 0x600C_0008
  systemClock = Reg 0x600C_0058
  cacheControl = Reg 0x600C_4004
  flashPages = 0x600C_5000'u32

# Programming the cache is left to the routines in the boot ROM
{.push cdecl, nodecl.}
proc cacheDisable() {.importc: "((void (*)(void))0x4000051c)".}
proc cacheInvalidate() {.importc: "((void (*)(void))0x400004d8)".}
proc cacheEnable(autoload: uint32) {.importc: "((void (*)(unsigned int))0x40000520)".}
{.pop.}

proc nimMain() {.importc: "NimMain", cdecl.}

var bss {.importc: "_sbss".}, bssEnd {.importc: "_ebss".}: uint32

# The C library keeps its state where this points, `malloc` needs it
type Reent {.importc: "struct _reent", header: "<reent.h>".} = object
var reent: Reent
proc getReent(): ptr Reent {.exportc: "__getreent".} = addr reent

# The boot ROM loads this into RAM and runs it with flash still unreadable, so
# nothing before `cacheEnable` can call or read anything outside of this proc.
proc reset() {.exportc, codegenDecl: "__attribute__((section(\".iram\"))) $# $#$#".} =
  # Interrupts off, cycle counter on
  asm """
    csrci mstatus, 8
    csrwi 0x7e0, 1
    csrwi 0x7e1, 1
  """

  # The boot ROM leaves watchdogs running for a bootloader to feed
  rtcWatchdogProtect[] = 0x50D8_3AA1
  rtcWatchdog[] = 0
  timerWatchdogProtect[] = 0x50D8_3AA1
  timerWatchdog[] = 0
  superWatchdogProtect[] = 0x8F1D_312A'u32
  superWatchdog[] = superWatchdog[] or (1'u32 shl 31) # Feeds itself, it can't be stopped

  # 160Mhz, a third of the 480Mhz PLL which the boot ROM has already started
  cpuClock[] = cpuClock[] and not 3'u32 or 0b101
  systemClock[] = systemClock[] and not (3'u32 shl 10) or (1 shl 10)

  # Map the 4M of flash in order, one 64K page at a time
  cacheDisable()
  for page in 0'u32..<128:
    Reg(flashPages + 4 * page)[] = if page < 64: page else: 0x100
  cacheInvalidate()
  cacheEnable(0)
  cacheControl[] = cacheControl[] and not 3'u32 # Let both buses through

  zeroMem(addr bss, cast[uint](addr bssEnd) - cast[uint](addr bss))
  nimMain()
  while true: discard

proc start() {.exportc: "_start", codegenDecl: "__attribute__((naked, section(\".iram\"))) $# $#$#".} =
  asm """
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop
    la sp, _estack
    j reset
  """
