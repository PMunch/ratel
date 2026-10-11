--cpu:riscv32
--os:any
--define:noSignalHandler

--gc:arc
--define:useMalloc

--opt:size
--exceptions:goto

--cc:gcc
--riscv32.any.gcc.exe:"riscv32-esp-elf-gcc"
--riscv32.any.gcc.linkerexe:"riscv32-esp-elf-gcc"

proc build*(file: string) =
  exec "nim c -d:danger --os:any " & file

# The boot ROM only loads the part of the program that runs from RAM, the rest
# is written to where board.ld expects to find it once flash has been mapped.
proc upload*(device: string, file: string) =
  exec "riscv32-esp-elf-objcopy -O binary -j .flash.text " & file & " " & file & ".text"
  exec "riscv32-esp-elf-objcopy -O binary -j .flash.rodata " & file & " " & file & ".rodata"
  exec "riscv32-esp-elf-objcopy -R .flash.text -R .flash.rodata " & file & " " & file & ".ram"
  exec "esptool --chip esp32c3 elf2image --flash-mode dio --flash-freq 80m --flash-size 4MB -o " & file & ".bin " & file & ".ram"
  exec "esptool --chip esp32c3 --port " & device & " --baud 460800 write-flash 0x0 " & file & ".bin 0x10000 " & file & ".text 0x100000 " & file & ".rodata"
  exec "rm " & file & ".text " & file & ".rodata " & file & ".ram " & file & ".bin"

proc size*(file: string) =
  exec "riscv32-esp-elf-size " & file

proc sizeDetails*(file: string) =
  exec "riscv32-esp-elf-size -A " & file
