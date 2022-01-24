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
  portF* {.importc: "PORTF".}: uint8
  ddrF* {.importc: "DDRF".}: uint8
  pinF* {.importc: "PINF".}: uint8
  portC* {.importc: "PORTC".}: uint8
  ddrC* {.importc: "DDRC".}: uint8
  pinC* {.importc: "PINC".}: uint8
  portE* {.importc: "PORTE".}: uint8
  ddrE* {.importc: "DDRE".}: uint8
  pinE* {.importc: "PINE".}: uint8

  twbr* {.importc: "TWBR".}: uint8
  twcr* {.importc: "TWCR".}: uint8
  twsr* {.importc: "TWSR".}: uint8
  twdr* {.importc: "TWDR".}: uint8

  udr1* {.importc: "UDR1".}: uint8
  ucsr1a* {.importc: "UCSR1A".}: uint8
  ucsr1b* {.importc: "UCSR1B".}: uint8
  ucsr1c* {.importc: "UCSR1C".}: uint8
  ubrr1l* {.importc: "UBRR1L".}: uint8
  ubrr1h* {.importc: "UBRR1H".}: uint8

let
  twint* {.importc: "TWINT".}: uint8
  twea* {.importc: "TWEA".}: uint8
  twsta* {.importc: "TWSTA".}: uint8
  twsto* {.importc: "TWSTO".}: uint8
  twwc* {.importc: "TWWC".}: uint8
  twen* {.importc: "TWEN".}: uint8
  twie* {.importc: "TWIE".}: uint8

  mpcm1* {.importc: "MPCM1".}: uint8
  u2x1* {.importc: "U2X1".}: uint8
  upe1* {.importc: "UPE1".}: uint8
  dor1* {.importc: "DOR1".}: uint8
  fe1* {.importc: "FE1".}: uint8
  udre1* {.importc: "UDRE1".}: uint8
  txc1* {.importc: "TXC1".}: uint8
  rxc1* {.importc: "RXC1".}: uint8
  txb81* {.importc: "TXB81".}: uint8
  rxb81* {.importc: "RXB81".}: uint8
  ucsz12* {.importc: "UCSZ12".}: uint8
  txen1* {.importc: "TXEN1".}: uint8
  rxen1* {.importc: "RXEN1".}: uint8
  udrie1* {.importc: "UDRIE1".}: uint8
  txcie1* {.importc: "TXCIE1".}: uint8
  rxcie1* {.importc: "RXCIE1".}: uint8
  ucpol1* {.importc: "UCPOL1".}: uint8
  ucsz10* {.importc: "UCSZ10".}: uint8
  ucpha1* {.importc: "UCPHA1".}: uint8
  ucsz11* {.importc: "UCSZ11".}: uint8
  udord1* {.importc: "UDORD1".}: uint8
  usbs1* {.importc: "USBS1".}: uint8
  upm10* {.importc: "UPM10".}: uint8
  upm11* {.importc: "UPM11".}: uint8
  umsel10* {.importc: "UMSEL10".}: uint8
  umsel11* {.importc: "UMSEL11".}: uint8
{.pop.}

type
  Teensy* = object
  Port* = object
    device*: Teensy
    portChar*: char
  Pin* = object
    port*: Port
    num*: int

include "../helpers/avrio"
const defaultClock* = 16.Mhz
