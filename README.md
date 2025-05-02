[![Standard](https://img.shields.io/badge/standard-C%2B%2B11-blue.svg?style=plastic&logo=c%2B%2B)](https://en.wikipedia.org/wiki/C%2B%2B#Standardization)
![GitHub](https://img.shields.io/github/license/NoOrientationProgramming/hello-world-stm32?style=plastic&color=blue)

## STM32 Hello World using CodeOrb

When working with small targets, simple log outputs are often the only feedback available.
With [CodeOrb](https://github.com/NoOrientationProgramming/code-orb#codeorb-start) on the PC and the
[SystemCore](https://github.com/NoOrientationProgramming/SystemCore) on the target,
you get two additional features: a task viewer and a command interface.
The task viewer provides a detailed insight into the entire system, whereas the command interface gives full control over the microcontroller.

## Status

- Pre alpha

## Targets

- Tested on: `NUCLEO-C071RB`

## Architecture

This repository contains the code running on the microcontroller. Highlighted in blue. Check out [CodeOrb](https://github.com/NoOrientationProgramming/code-orb#codeorb-start) the microcontroller debugger as well!

<p align="center">
  <kbd>
    <img src="https://raw.githubusercontent.com/NoOrientationProgramming/hello-world-stm32/main/doc/system/stm32-uart_3.svg" style="width: 400px; max-width:100%"/>
  </kbd>
</p>

## How to use

Clone repo with
```
git clone https://github.com/NoOrientationProgramming/hello-world-stm32.git
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
st-flash --format=ihex --reset write ./build/hello-world-stm32.hex
```
