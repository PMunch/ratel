import macros, tables

{.push nodecl, header: "<avr/io.h>".}
var
  clkpr* {.importc: "CLKPR".}: uint8
  portB* {.importc: "PORTB".}: uint8
  ddrB* {.importc: "DDRB".}: uint8
  pinB* {.importc: "PINB".}: uint8

  usicr* {.importc: "USICR".}: uint8
  usisr* {.importc: "USISR".}: uint8
  usidr* {.importc: "USIDR".}: uint8
  usibr* {.importc: "USIBR".}: uint8

let
  usisie* {.importc: "USISIE".}: uint8
  usioie* {.importc: "USIOIE".}: uint8
  usiwm1* {.importc: "USIWM1".}: uint8
  usiwm0* {.importc: "USIWM0".}: uint8
  usics1* {.importc: "USICS1".}: uint8
  usics0* {.importc: "USICS0".}: uint8
  usiclk* {.importc: "USICLK".}: uint8
  usitc* {.importc: "USITC".}: uint8

  usisif* {.importc: "USISIF".}: uint8
  usioif* {.importc: "USIOIF".}: uint8
  usipf* {.importc: "USIPF".}: uint8
  usidc* {.importc: "USIDC".}: uint8
  usicnt3* {.importc: "USICNT3".}: uint8
  usicnt2* {.importc: "USICNT2".}: uint8
  usicnt1* {.importc: "USICNT1".}: uint8
  usicnt0* {.importc: "USICNT0".}: uint8
{.pop.}

type
  Board* = object
  Port* = object
    device*: Board
    portChar*: char
  Pin* = object
    port*: Port
    num*: int

include "../helpers/avrio"
const defaultClock* = 1650.Khz

