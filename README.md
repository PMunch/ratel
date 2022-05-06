# Ratel
### Next-generation, zero-cost abstraction microconroller programming in Nim

## Getting started
Getting started with Ratel is fairly simply. First you need to have [Nim](https://nim-lang.org/) installed along with the toolchain for
the controller you want to compile for. This guide is written with the Arduino Uno in mind, so for that board this would be the AVR toolchain. If you
have written code for Arduino before chances are good you already have these tools installed. Once that is done you need to install
Ratel itself:

```
nimble install ratel
```

If your board is not included in the official distribution you need to grab support for that as well. You should be able to search for all Ratel
based packages in the [package directory](https://nimble.directory/search?query=ratel). In order to compile and build for your board you
will also need the toolchain to compile C code and upload that to your board as well. The details of this should be found with the board support
library.

Once you have Ratel and your board support installed you need to set up your project. In this tutorial we'll be building for an Arduino Uno, but
this process is pretty much the same no matter the board. Simply create a `config.nims` file in your folder with the content:

```nim
import boardConf
board "unor3"

--avr.any.gcc.path: "/usr/bin"
```

This does a couple of things, starting with including the `boardConf` module from Ratel. Then it calls `board` which tells
Ratel that the board we want to build for is the Arduino Uno rev. 3. This will automatically include a set of sane defaults for compiling for this
micro-controller, along with some procedures that we'll get back to later.

The last three lines are simply telling Nim where to find the specific compiler we need to use for the CPU/OS combination we're using.
These could also be placed in your [global configuration](https://nim-lang.org/docs/nimc.html#compiler-usage-configuration-files)
as they will only be applied when compiling for these platforms.

## Writing our code
Now that our project is all set up we need to write some code, the sample from the front page is a good start. Simply save the following code in
a file with the `.nim` extension named the same as the folder it's in.

```nim
import board
import board / [times, serial, progmem]

Serial.init(9600.Hz)
Serial.send p"Hello world\n"
Led.output()

while true:
  Led.high()
  Serial.send p"Led is on\n"
  delayMs(1000)
  Led.low()
  Serial.send p"Led is off\n"
  delayMs(1000)
```

To write your own code have a browse through the documentation and check out any Ratel modules in Nimble.

## Compiling and uploading
With the project set up and the code written it is time to compile. When we imported the board configuration earlier we got some tasks for doing
this loaded into our configuration. To run these we use the `ratel` binary. So to build simply run:

```
ratel build
```

If you missed the sentence earlier about putting your file in a folder of the same name this will fail, but fret not, simply pass the file to
build with the `-f` flag. This command should have created a binary file in the same folder with the same name as your file but without
the extension. In order to check how big the resulting binary is we can simply run:

```
ratel size
```

Or if you're of the curious kind:

```
ratel sizeDetails
```

The size breakdown you get from this should be familiar to you if you have done any kind of programming with Arduino, it's the same one which is
written out in the terminal before uploading. It should look something like this:

```
AVR Memory Usage
----------------
Device: atmega328p

Program:     298 bytes (0.9% Full)
(.text + .data + .bootloader)

Data:          0 bytes (0.0% Full)
(.data + .bss + .noinit)
```

Now the final step of the process is to upload our code to the controller. You can of course do this manually with `avrdude` but Ratel
comes with a task for this as well:

```
ratel upload --device=/dev/ttyACM0
```

For me the board is connected to the USB port at `/dev/ttyACM0` but this might be different for you.

And that should be it! Your board should now be flashing an LED and printing to the serial terminal. To view the output you can either use the
serial terminal that comes with Arduino if you have that installed, or you can use a number of terminal applications. The easiest might even be to run
`tail -f /dev/ttyACM0`.
