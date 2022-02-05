import os, json, strutils, tables, hashes
import packages/docutils/highlite

let systemTypes = [
    "int", "int8", "int16", "int32", "int64", "uint", "uint8", "uint16", "uint32", "uint64", "float", "float32", "float64",
    "bool", "void", "chr", "char", "string", "cstring", "pointer", "range", "array", "openarray", "seq", "varargs",
    "set", "byte", "Natural", "Positive",
    "Biggestint", "Biggestfloat", "cchar", "cschar", "cshort", "cint", "csize", "cuchar", "cushort",
    "clong", "clonglong", "cfloat", "cdouble", "clongdouble", "cuint", "culong", "culonglong", "cchar",
    "Compiledate", "Compiletime", "nimversion", "nimmajor",
    "nimminor","nimpatch","cpuendian", "hostos", "hostcpu", "inf",
    "neginf", "nan", "typed", "untyped"
  ]

type Module = object
  description: string
  path: string
  elements: OrderedTable[string, seq[tuple[code, description, kind: string]]]

var
  modules: Table[string, Module]
  elements: Table[string, string]

proc highlight(code: string): tuple[code: string, name: string] =
  var toknizr: GeneralTokenizer
  initGeneralTokenizer(toknizr, code)
  var firstIdent = true
  while true:
    getNextToken(toknizr, langNim)
    let
      token = code.substr(toknizr.start, toknizr.length + toknizr.start - 1)
      kind = tokenClassToStr[toknizr.kind]
    case toknizr.kind
    of gtEof: break  # End Of File (or string)
    of gtWhitespace:
      result.code.add token
    of gtIdentifier:
      if token.nimIdentNormalize in systemTypes and not firstIdent:
        result.code.add "<span class=\"" & kind & "\"><a href=\"https://nim-lang.org/docs/system.html#" & token & "\">" & token & "</a></span>"
      elif token.nimIdentNormalize in elements and firstIdent:
        result.name = token & "_" & code.hash.toHex(8)
        result.code.add "<span class=\"" & kind & "\"><a href=\"#" & result.name & "\">" & token & "</a></span>"
      elif token.nimIdentNormalize in elements:
        result.code.add "<span class=\"" & kind & "\"><a href=\"" & elements[token.nimIdentNormalize] & ".html#" & token & "\">" & token & "</a></span>"
      elif token in ["true", "false"]:
        result.code.add "<span class=\"BoolLit\">" & token & "</span>"
      else:
        result.code.add "<span class=\"" & kind & "\">" & token & "</span>"
      firstIdent = false
    else:
      result.code.add "<span class=\"" & kind & "\">" & token & "</span>"

proc parseModule(file: string) =
  let fileComponents = splitFile(file)
  if execShellCmd("nim jsondoc -o:/tmp/output.json " & file) == 0:
    template module:untyped = modules[fileComponents.name]
    modules[fileComponents.name] = Module.default
    let documentation = parseJson(readFile("/tmp/output.json"))
    module.path = fileComponents.dir.replace("../src/", "").replace("../src", "")
    module.description = documentation["moduleDescription"].str
    for entry in documentation["entries"]:
      module.elements.mgetOrPut(entry["name"].str, @[]).add (code: entry["code"].str, description: entry["description"].str, kind: entry["type"].str)
      elements[entry["name"].str.nimIdentNormalize] = fileComponents.name

parseModule("../src/board.nim")
for file in walkFiles("../src/board/*.nim"):
  parseModule(file)

for module, content in modules:
  if content.elements.len == 0 and content.description.len == 0:
    continue
  let output = open("documentation/board/" & module & ".html", fmWrite)
  output.write("<!DOCTYPE html><html><head><link rel=\"stylesheet\" href=\"https://unpkg.com/@picocss/pico@latest/css/pico.min.css\"><link rel=\"stylesheet\" href=\"../custom.css\"><title></title></head>")
  #output.write("<body><nav><ul><img src=\"../../logo-header-small.png\"><li><strong>Ratel</strong></li></ul><ul><li>Getting started</li><li>Documentation</li></ul></nav>")
  output.write("<body><nav><nav><ul><img src=\"../../assets/logo-header-small.png\"/><li><a href=\"../../index.html\" class=\"contrast\"><strong>Ratel</strong></a></li></ul><ul><li><a href=\"../../gettingstarted.html\" class=\"contrast\">Getting started</a></li><li><a href=\"board.html\" class=\"contrast\">Documentation</a></li></ul></nav></nav>")
  output.write("<aside><h3>Navigation</h3>")
  output.write("<a href=\"board.html\">BOARD</a>")
  for navModule, navContent in modules:
    if navContent.elements.len == 0 and navContent.description.len == 0 or navContent.path.len == 0:
      continue
    output.write("<details" & (if navModule == module: " open" else: "") & "><summary><a href=\"" & navModule & ".html\">" & navModule.toUpper & "</a></summary><ul>")
    for key, entries in navContent.elements:
      let multiSpan = (if entries.len > 1: "<span>" & $entries.len & "</span>" else: "")
      output.write("<li><a href=\"" & navModule & ".html#" & key & "\">" & key & (if entries[0].kind == "skType": "" else: "()") & "</a>" & multiSpan & "</li>")
    output.write("</ul></details>")
  output.write("</aside>")
  if content.path.len == 0:
    output.write("<main><h2>" & module & "</h2>")
  else:
    output.write("<main><h2><span class=\"muted\"><a href=\"" & content.path & ".html\">" & content.path & "</a>/</span>" & module & "</h2>")
  output.write("<p>" & content.description & "</p><dl>")
  for key, entries in content.elements:
    output.write "<div id=\"" & key & "\" class=\"group\">"
    for entry in entries:
      let (code, name) =
        highlight(case entry.kind:
          of "skType":
            "type " & entry.code
          of "skConst":
            "const " & entry.code
          else:
            entry.code)
      output.write "<div id=\"" & name & "\" class=\"ident\"><dt><code>" & code & "</code></dt><dd>" & entry.description & "</dd></div>"
    output.write "</div>"

  output.write("</dl></main></body></html>")
  output.close()

