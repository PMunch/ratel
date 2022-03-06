include "../helpers/avrBoardConf.nim"

proc build*(file: string) =
  exec "nim c -d:danger --os:any " & file

proc upload*(file: string) =
  exec "avr-objcopy -O ihex -R .eeprom " & file & " " & file & ".hex"
  exec "teensy-loader-cli --mcu=TEENSY2 -v -w " & file & ".hex"
  exec "rm " & file & ".hex"

proc size*(file: string) =
  exec "avr-size -C --mcu=atmega32u4 " & file

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
