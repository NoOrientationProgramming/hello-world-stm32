
STM32 "Hello World" using the [Processing()](https://github.com/NoOrientationProgramming/ProcessingCore) class.

## Status

- Pre alpha
- Tested on: `NUCLEO-C071RB`

## Architecture

<p align="center">
  <kbd>
    <img src="https://raw.githubusercontent.com/NoOrientationProgramming/stm32-hello-world/main/doc/system/stm32-uart_3.svg" style="max-width:100%"/>
  </kbd>
</p>

## How to use

Clone repo with
```
git clone https://github.com/NoOrientationProgramming/stm32-hello-world.git
```

Initialize submodules with
```
git submodule update --init --recursive
```

Create output files
```
make
```

Flash to device
```
st-flash --format=ihex --reset write ./build/stm32-hello-world.hex
```
