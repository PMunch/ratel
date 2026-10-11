ENTRY(_start)

MEMORY
{
  /* One block of RAM seen through two windows, instruction 0x40380000 is data
     0x3FC80000. The 64K above these two belong to the boot ROM. */
  iram (rwx) : ORIGIN = 0x40380000, LENGTH = 64K
  dram (rw)  : ORIGIN = 0x3FC90000, LENGTH = 256K
  /* Flash, mapped so that the low 23 bits of an address is its offset in
     flash. These offsets are where the upload task writes the two sections. */
  irom (rx)  : ORIGIN = 0x42010000, LENGTH = 960K
  drom (r)   : ORIGIN = 0x3C100000, LENGTH = 3M
}

SECTIONS
{
  /* Loaded by the boot ROM */
  .iram : { *(.iram) } > iram

  .data :
  {
    *(.data .data.*)
    PROVIDE(__global_pointer$ = . + 0x800);
    *(.sdata .sdata.*)
  } > dram

  .bss (NOLOAD) :
  {
    _sbss = .;
    *(.sbss .sbss.* .bss .bss.* COMMON)
    _ebss = .;
  } > dram

  /* The heap grows from the end of the program towards the stack */
  end = _ebss;
  _estack = ORIGIN(dram) + LENGTH(dram);

  /* Read from flash, once it is mapped */
  .flash.text : { *(.text .text.*) } > irom
  .flash.rodata : { *(.rodata .rodata.* .srodata .srodata.*) } > drom

  /DISCARD/ : { *(.eh_frame) *(.comment) *(.riscv.attributes) }
}
