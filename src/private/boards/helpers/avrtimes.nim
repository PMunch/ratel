proc delayMs*(ms: cdouble) {.importc: "_delay_ms", header: "<avr/delay.h>".}
proc delayUs*(us: cdouble) {.importc: "_delay_us", header: "<avr/delay.h>".}
proc delayLoop*(its: uint8) {.importc: "_delay_loop_1", header: "<util/delay_basic.h>".}
proc delayLoop*(its: uint16) {.importc: "_delay_loop_2", header: "<util/delay_basic.h>".}
proc millis*(): culong {.importc, nodecl.}
