import "../private/helpers"

when not defined(nimdoc):
  generateInclude("progmem")
else:
  ## This is documentation for the progmem integration. Please note that this
  ## is just documentation for the interface, different boards might have
  ## different caveats for the various procedures.

  type
    Progmem*[T] = distinct T ## \
      ## Type for data stored in program memory, accesing this memory should
      ## trigger the correct behaviour for reading this data. If this is not a
      ## useful distinction on the selected board it will simply behave as the
      ## normal type.
    ProgmemString*[size: static[int]] = Progmem[array[size, char]] ## \
      ## Special type for strings stored in program memory.

  proc pgmReadByte*[T](address: ptr T): uint8 =
    ## Low level procedure for reading a single byte of program memory

  proc pgmReadWord*[T](address: ptr T): uint16 =
    ## Low level procedure for reading a two-byte word of program memory

  proc pgmReadDoubleWord*[T](address: ptr T): uint32 =
    ## Low level procedure for reading a four-byte double word of program memory

  proc memcpyPgm*[T](dest: ptr T, src: ptr T, size: csize_t): ptr T =
    ## Low level procedure for reading arbitrary amounts of data from program
    ## memory

  proc `[]`*[T](src: ptr Progmem[T]): T =
    ## Dereference operator for program memory, this will read all the memory
    ## indendpented of the size of the underlying type.

  proc readInto*[T](dst: var T, src: Progmem[T]) =
    ## Reads progmem data into a variable

  template read*[T](data: Progmem[T]): T =
    ## Creates a read statement for the progmem data

  template len*[N, T](data: Progmem[array[N, T]]): untyped =
    ## Returns the length of an array in program memory

  template `[]`*[N, T](data: Progmem[array[N, T]], idx: int): untyped =
    ## Array access for program memory allocated arrays. This will either
    ## return a progmem type for whatever is stored in the array, or simply
    ## read out the value depending on whether it's a simply type or an object.

  template `[]`*(data: Progmem[cstring], idx: int): untyped =
    ## Reads a single character from a cstring stored in program memory, this
    ## does not verify if `idx` is actually within the string.

  template p*(x: static[string]): untyped =
    ## Template to turn string literals into program memory strings. Analagous
    ## to the `F` macro in Arduino. Simply call it like this:
    ##
    ## .. code-block:: nim
    ##   serial.send p"Hello world"

  #macro createFieldReaders*(obj: typed): untyped =
  #  let impl = getImpl(obj)
  #  doAssert(impl.kind == nnkTypeDef)
  #  doAssert(impl[2].kind == nnkObjectTy)
  #  result = newStmtList()
  #  for def in impl[2][2]:
  #    let
  #      name = def[0]
  #      kind = def[1]
  #    result.add quote do:
  #      template `name`(x: Progmem[`obj`]): `kind` =
  #        cast[`kind`](
  #          when sizeof(`kind`) == 1:
  #            pgmReadByte(cast[ptr uint8](cast[int](x.unsafeAddr) + `obj`.offsetof(`name`)))
  #          elif sizeof(`kind`) == 2:
  #            pgmReadWord(cast[ptr uint16](cast[int](x.unsafeAddr) + `obj`.offsetof(`name`)))
  #          elif sizeof(`kind`) == 4:
  #            pgmReadDoubleWord(cast[ptr uint32](cast[int](x.unsafeAddr) + `obj`.offsetof(`name`)))
  #          else:
  #            var x {.noInit.} : T
  #            discard memcpyPgm(x.addr, cast[ptr T](data.unsafeAddr), sizeof(T).csize_t)[]
  #            x
  #          )

  macro progmem*(definitions: untyped): untyped =
    ## Creates a block in which you can define variables which will be stored
    ## in program memory.
