#!/bin/bash

#st-flash --format=ihex --connect-under-reset write ./build/stm32-hello-world.hex
st-flash --format=ihex --reset write ./build/stm32-hello-world.hex

