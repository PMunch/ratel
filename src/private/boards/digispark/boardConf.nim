include "../helpers/avrBoardConf.nim"

proc build*(file: string) =
  exec "nim c -d:danger --os:any " & file

proc upload*(file: string) =
  exec "avr-objcopy -j .text -j .data -O ihex " & file & " " & file & ".hex"
  exec "micronucleus --timeout 60 " & file & ".hex"
  # Add support for avrdude flashing?
  #exec "avrdude -c usbtiny -p attiny85 -U flash:w:" & file & ":e"

proc size*(file: string) =
  exec "avr-size -C --mcu=attiny85 " & file

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
