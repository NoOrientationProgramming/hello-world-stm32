
# stm32-hello-world

Status: `Pre alpha`

Tested on: `NUCLEO-C071RB`

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
