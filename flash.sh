#!/bin/bash

#st-flash --format=ihex --connect-under-reset write ./build/hello-world-stm32.hex
st-flash --format=ihex --reset write ./build/hello-world-stm32.hex

