##########################################################################################################################
# File automatically-generated by tool: [projectgenerator] version: [4.6.0-B36] date: [Mon Mar 24 21:18:35 CET 2025] 
##########################################################################################################################

# ------------------------------------------------
# Generic Makefile (based on gcc)
#
# ChangeLog :
#	2017-02-10 - Several enhancements + project update mode
#   2015-07-22 - first version
# ------------------------------------------------

######################################
# target
######################################
TARGET = stm32-hello-world


######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -Og


#######################################
# paths
#######################################
# Build path
BUILD_DIR = build

######################################
# source
######################################
# C sources
C_SOURCES =  \
Core/Src/main.c \
Core/Src/stm32c0xx_it.c \
Core/Src/stm32c0xx_hal_msp.c \
Drivers/BSP/STM32C0xx_Nucleo/stm32c0xx_nucleo.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_cortex.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_rcc.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_rcc_ex.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_flash.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_flash_ex.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_gpio.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_dma.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_dma_ex.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_pwr.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_pwr_ex.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_exti.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_tim.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_tim_ex.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_uart.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_uart_ex.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_usart.c \
Drivers/STM32C0xx_HAL_Driver/Src/stm32c0xx_hal_usart_ex.c \
Core/Src/system_stm32c0xx.c

CPP_SOURCES = \
src/StmSupervising.cpp

CORE_SOURCES = \
ProcessingCore/Processing.cpp

# ASM sources
ASM_SOURCES =  \
startup_stm32c071xx.s

# ASM sources
ASMM_SOURCES = 


#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)g++
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)g++
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m0plus

# fpu
# NONE for Cortex-M0/M0+/M3

# float-abi


# mcu
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# macros for gcc
# AS defines
AS_DEFS = 

# C defines
C_DEFS =  \
-DUSE_NUCLEO_64 \
-DUSE_HAL_DRIVER \
-DSTM32C071xx


# AS includes
AS_INCLUDES = 

# C includes
C_INCLUDES =  \
-ICore/Inc \
-IDrivers/STM32C0xx_HAL_Driver/Inc \
-IDrivers/STM32C0xx_HAL_Driver/Inc/Legacy \
-IDrivers/BSP/STM32C0xx_Nucleo \
-IDrivers/CMSIS/Device/ST/STM32C0xx/Include \
-IDrivers/CMSIS/Include

C_INCLUDES += \
 -IProcessingCore \
 -Isrc

# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

CFLAGS += $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"

# User
CFLAGS += \
	-fno-exceptions \
	-fno-unwind-tables \
	-fno-asynchronous-unwind-tables \
	-fno-rtti \
	-fno-non-call-exceptions \
	-fno-use-cxa-atexit \
	-fno-threadsafe-statics

CFLAGS += \
	-DCONFIG_PROC_NUM_MAX_CHILDREN_DEFAULT=1 \
	-DCONFIG_PROC_SHOW_ADDRESS_IN_ID=0 \
	-DCONFIG_PROC_HAVE_LIB_C_CUSTOM=0 \
	-DCONFIG_PROC_INFO_BUFFER_SIZE=512

#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = STM32C071XX_FLASH.ld

# libraries
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

LDFLAGS += \
	-specs=nosys.specs

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(CPP_SOURCES:.cpp=.o)))
vpath %.cpp $(sort $(dir $(CPP_SOURCES)))
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(CORE_SOURCES:.cpp=.o)))
vpath %.cpp $(sort $(dir $(CORE_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASMM_SOURCES:.S=.o)))
vpath %.S $(sort $(dir $(ASMM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.cpp Makefile | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.cpp=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@
$(BUILD_DIR)/%.o: %.S Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@		

#######################################
# clean up
#######################################
clean:
	-rm -fR $(BUILD_DIR)
  
#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

# *** EOF ***
