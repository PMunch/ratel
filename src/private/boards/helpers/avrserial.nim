import board / [io, progmem]
import macros, strutils

type SerialPort* = object
  port*: int

macro genTemplates(): untyped =
  result = newStmtList()
  for i in [
    "udr*",
    "ucsr*a",
    "ucsr*b",
    "ucsr*c",
    "ubrr*l",
    "ubrr*h",
    "mpcm*",
    "u2x*",
    "upe*",
    "dor*",
    "fe*",
    "udre*",
    "txc*",
    "rxc*",
    "txb8*",
    "rxb8*",
    "ucsz*2",
    "txen*",
    "rxen*",
    "udrie*",
    "txcie*",
    "rxcie*",
    "ucpol*",
    "ucsz*0",
    "ucpha*",
    "ucsz*1",
    "udord*",
    "usbs*",
    "upm*0",
    "upm*1",
    "umsel*0",
    "umsel*1"
    ]:
      let
        ident = i.split "*"
        baseIdent = newIdentNode(ident[0] & ident[1])
        part1 = ident[0]
        part2 = ident[1]
      result.add quote do:
        template `baseIdent`(): untyped =
          combineIdent(serial, `part1`, `part2`)

macro combineIdent(serial: static[SerialPort], part1, part2: static[string]): untyped =
  newIdentNode(part1 & $serial.port & part2)

genTemplates()

proc setBaudRate*(serial: static[SerialPort], baud: Hz, clock = defaultClock) =
  let bytes = (clock.uint32 div (16 * baud.uint32)) - 1
  ubrrl = (bytes and 0xff).uint8
  ubrrh = (bytes shr 8).uint8

proc init*(serial: static[SerialPort], baud = 115.2.Khz) =
  ucsra = 0x00
  serial.setBaudRate(baud)
  ucsrb.update rxen, txen

proc send*(serial: static[SerialPort], c: char) =
  while not ucsra.check udre: discard
  #while (ucsra and (1'u8 shr udre)) != 0: discard
  udr = c.uint8

proc send*(serial: static[SerialPort], str: cstring) =
  for c in str:
    serial.send(c)

proc send*(serial: static[SerialPort], str: Progmem[cstring], size: int) =
  for i in 0..<size:
    serial.send(str[i])

template send*[N: static[int]](serial: static[SerialPort], data: ProgmemString[N]) =
  serial.send(cast[Progmem[cstring]](data.unsafeaddr), N)
