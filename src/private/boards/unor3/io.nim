import macros, tables

{.push nodecl, header: "<avr/io.h>".}
var
  clkpr* {.importc: "CLKPR".}: uint8
  portD* {.importc: "PORTD".}: uint8
  ddrD* {.importc: "DDRD".}: uint8
  pinD* {.importc: "PIND".}: uint8
  portB* {.importc: "PORTB".}: uint8
  ddrB* {.importc: "DDRB".}: uint8
  pinB* {.importc: "PINB".}: uint8
  portC* {.importc: "PORTC".}: uint8
  ddrC* {.importc: "DDRC".}: uint8
  pinC* {.importc: "PINC".}: uint8

  twbr* {.importc: "TWBR".}: uint8
  twar* {.importc: "TWAR".}: uint8
  twcr* {.importc: "TWCR".}: uint8
  twsr* {.importc: "TWSR".}: uint8
  twdr* {.importc: "TWDR".}: uint8

  udr0* {.importc: "UDR0".}: uint8
  ucsr0a* {.importc: "UCSR0A".}: uint8
  ucsr0b* {.importc: "UCSR0B".}: uint8
  ucsr0c* {.importc: "UCSR0C".}: uint8
  ubrr0l* {.importc: "UBRR0L".}: uint8
  ubrr0h* {.importc: "UBRR0H".}: uint8

let
  twint* {.importc: "TWINT".}: uint8
  twea* {.importc: "TWEA".}: uint8
  twsta* {.importc: "TWSTA".}: uint8
  twsto* {.importc: "TWSTO".}: uint8
  twwc* {.importc: "TWWC".}: uint8
  twen* {.importc: "TWEN".}: uint8
  twie* {.importc: "TWIE".}: uint8

  mpcm0* {.importc: "MPCM0".}: uint8
  u2x0* {.importc: "U2X0".}: uint8
  upe0* {.importc: "UPE0".}: uint8
  dor0* {.importc: "DOR0".}: uint8
  fe0* {.importc: "FE0".}: uint8
  udre0* {.importc: "UDRE0".}: uint8
  txc0* {.importc: "TXC0".}: uint8
  rxc0* {.importc: "RXC0".}: uint8
  txb80* {.importc: "TXB80".}: uint8
  rxb80* {.importc: "RXB80".}: uint8
  ucsz02* {.importc: "UCSZ02".}: uint8
  txen0* {.importc: "TXEN0".}: uint8
  rxen0* {.importc: "RXEN0".}: uint8
  udrie0* {.importc: "UDRIE0".}: uint8
  txcie0* {.importc: "TXCIE0".}: uint8
  rxcie0* {.importc: "RXCIE0".}: uint8
  ucpol0* {.importc: "UCPOL0".}: uint8
  ucsz00* {.importc: "UCSZ00".}: uint8
  ucpha0* {.importc: "UCPHA0".}: uint8
  ucsz01* {.importc: "UCSZ01".}: uint8
  udord0* {.importc: "UDORD0".}: uint8
  usbs0* {.importc: "USBS0".}: uint8
  upm00* {.importc: "UPM00".}: uint8
  upm01* {.importc: "UPM01".}: uint8
  umsel00* {.importc: "UMSEL00".}: uint8
  umsel01* {.importc: "UMSEL01".}: uint8
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
const defaultClock* = 16.Mhz

