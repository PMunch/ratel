import "../private/helpers"

when not defined(nimdoc):
  generateInclude("times")
else:
  ## This is documentation for the times integration. Please note that this is
  ## just documentation for the interface, different boards might have
  ## different caveats for the various procedures.
proc delayMs*(ms: cdouble) {.documentation.} =
  ## Sleeps for `ms` milliseconds

proc delayUs*(us: cdouble) {.documentation.} =
  ## Sleeps for `us` microseconds

proc delayLoop*(its: uint8) {.documentation.} =
  ## Sleeps for `its` clock cycles

proc delayLoop*(its: uint16) {.documentation.} =
  ## Sleeps for `its` clock cycles

proc millis*(): culong {.documentation.} =
  ## Returns the amount of milliseconds the program has run, or at least a
  ## timestamp in milliseconds that is strictly increasing
