include "../helpers/avrBoardConf.nim"

proc build*(file: string) =
  exec "nim c -d:danger --os:any " & file

proc upload*(device: string, file: string) =
  exec "avrdude -F -V -c arduino -p atmega328p -P " & device & " -b 115200 -U flash:w:" & file & ":e"

proc size*(file: string) =
  exec "avr-size -C --mcu=atmega328p " & file

proc sizeDetails*(file: string) =
  size(file)
  echo ".data section:"
  exec "avr-nm -S --size-sort " & file & " | grep \" [Dd] \" || echo \"empty\""
  echo ""
  echo ".bss section:"
  exec "avr-nm -S --size-sort " & file & " | grep \" [Bb] \" || echo \"empty\""
  echo ""
  echo ".text section:"
  exec "avr-nm -S --size-sort " & file & " | grep \" [Tt] \" || echo \"empty\""
