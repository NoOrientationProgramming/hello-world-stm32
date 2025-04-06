[![Standard](https://img.shields.io/badge/standard-C%2B%2B11-blue.svg?style=plastic&logo=c%2B%2B)](https://en.wikipedia.org/wiki/C%2B%2B#Standardization)
![GitHub](https://img.shields.io/github/license/NoOrientationProgramming/hello-world-stm32?style=plastic&color=blue)

In microcontroller programming, simple log outputs are usually the only feedback available.
With [Processing()](https://github.com/NoOrientationProgramming/ProcessingCore), you get two additional features: a task viewer and a command interface.
The task viewer provides a detailed insight into the entire system, whereas the command interface gives full control over the microcontroller.

## Status

- Pre alpha
- Tested on: `NUCLEO-C071RB`

## Architecture

This repository contains the code running on the microcontroller. Highlighted in green. Check out the [SingleWireTransfering() Gateway](https://github.com/NoOrientationProgramming/hello-world-stm32) as well!

<p align="center">
  <kbd>
    <img src="https://raw.githubusercontent.com/NoOrientationProgramming/stm32-hello-world/main/doc/system/stm32-uart_3.svg" style="width: 400px; max-width:100%"/>
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
