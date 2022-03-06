import strutils, tables, os, options
import nimscripter, nimscripter / vmops
import cligen

var
  keys*: Table[string, string]
  defines*: seq[string]

proc switch*(key: string, value = "") =
  if key == "define":
    defines.add value.strip(chars = {'"'})
  else:
    keys[key] = value.strip(chars = {'"'})

proc getSetting*(key: string): string =
  keys[key]

proc isDefined*(key: string): bool =
  defines.contains key

proc runCommand(command: string, arguments: varargs[string]) =
  addVMops(tasks)
  addCallable(tasks):
    proc build(file: string)
    proc getSize(file: string)

  exportCode(tasks):
    template `--`(key, val: untyped) =
      switch(strip(astToStr(key)), strip(astToStr(val)))

    template `--`(key: untyped) =
      switch(strip(astToStr(key)))

  exportTo(tasks, switch, getSetting, isDefined)

  var searchPaths: seq[string]
  # TODO: figure out paths on Windows
  let nimblePath = getEnv("NIMBLE_PATH")
  let nimblePaths = if nimblePath.len == 0:
      @[getHomeDir() & "/.nimble/pkgs/", getHomeDir() & "/.nimble/pkgs2/", "/opt/nimble/pkgs/", "/opt/nimble/pkgs2/"]
    else:
      @[nimblePath]
  for path in nimblePaths:
    for kind, path in path.walkDir:
      if kind == pcDir: searchPaths.add path

  var
    addins = implNimscriptModule(tasks)
    interpreter = loadScript("config.nims".NimScriptPath, addins, modules = @["strutils"], searchPaths = searchPaths)

  case arguments.len:
  of 0: interpreter.get.invokeDynamic(command)
  of 1: interpreter.get.invokeDynamic(command, arguments[0])
  of 2: interpreter.get.invokeDynamic(command, arguments[0], arguments[1], returnType = void)
  of 3: interpreter.get.invokeDynamic(command, arguments[0], arguments[1], arguments[2], returnType = void)
  of 4: interpreter.get.invokeDynamic(command, arguments[0], arguments[1], arguments[2], arguments[3], returnType = void)
  else: interpreter.get.invokeDynamic(command, arguments)

proc build(file = getCurrentDir().lastPathPart().addFileExt(".nim")) =
  runCommand("build", file)

proc upload(device = "autodetect", file = getCurrentDir().lastPathPart()) =
  if device != "autodetect":
    runCommand("upload", device, file)
  else:
    runCommand("upload", file)

proc size(file = getCurrentDir().lastPathPart()) =
  runCommand("size", file)

proc sizeDetails(file = getCurrentDir().lastPathPart()) =
  runCommand("sizeDetails", file)

dispatchMulti([build], [upload], [size], [sizeDetails])

