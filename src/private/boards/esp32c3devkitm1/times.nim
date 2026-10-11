import board / io

const
  timerOp = Reg 0x6002_3004
  timerHigh = Reg 0x6002_3040
  timerLow = Reg 0x6002_3044

proc ticks(): uint64 =
  # The system timer counts at 16Mhz whatever the clock of the core
  timerOp[] = 1 shl 30
  while (timerOp[] and (1 shl 29)) == 0: discard
  (timerHigh[].uint64 shl 32) or timerLow[]

proc delayTicks(duration: uint64) =
  let stop = ticks() + duration
  while ticks() < stop: discard

template delayUs*(us: cdouble) = delayTicks(uint64(us * 16))
template delayMs*(ms: cdouble) = delayUs(ms * 1000)

proc millis*(): culong = culong(ticks() div 16_000)

proc cycles*(): uint32 =
  {.emit: ["__asm__ volatile(\"csrr %0, 0x7e2\" : \"=r\"(", result, "));"].}

proc delayLoop*(its: uint16) =
  let start = cycles()
  while cycles() - start < its: discard
