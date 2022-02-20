import private/helpers
import macros

macro board*(x: static[string]): untyped =
  let define = "board:" & x
  quote do:
    switch("define", `define`)
    generateInclude("boardConf", `x`)
