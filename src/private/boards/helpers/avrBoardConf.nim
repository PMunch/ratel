--cpu:avr
--os:any
--define:noSignalHandler

--gc:arc
--define:useMalloc

--opt:size
--exceptions:goto

--noMain

--avr.any.gcc.path:"/usr/bin"
--avr.any.gcc.exe:"avr-gcc"
--avr.any.gcc.linkerexe:"avr-gcc"

# Make sure that the random module can be used
--define:standalone
