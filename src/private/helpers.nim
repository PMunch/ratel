import macros, strutils

const board* {.strdefine.} = ""

macro generateInclude*(library: static[string] = ""): untyped =
  let
    boardIdentifier = newIdentNode(board)
    avrImport =
      if library == "":
        nnkInfix.newTree("/".ident, nnkInfix.newTree("/".ident, "private".ident, "boards".ident), boardIdentifier)
      else:
        nnkInfix.newTree("/".ident, nnkInfix.newTree("/".ident, nnkInfix.newTree("/".ident, "private".ident, "boards".ident), boardIdentifier), library.ident)
    foreignImport =
      if library == "":
        boardIdentifier
      else:
        nnkInfix.newTree("/".ident, boardIdentifier, library.ident)
  # TODO: Replace this check with an actual check once https://github.com/nim-lang/Nim/issues/19414 is fixed
  result =
    if board == "":
      quote do:
        {.error: "No board declared, you must specify the board to compile for. See the manual for instructions".}
    elif board.nimIdentNormalize in ["teensy", "unor3"]:
      quote do:
        include `avrImport`
    else:
      quote do:
        include `foreignImport`
        when not declared(ratelBoard) or ratelBoard != board:
          {.error: "Declared board '" & board & "' doesn't appear to be a Badger compatible board".}
