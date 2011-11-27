
# Directory in which the ST's STM32 example has been unzipper
STDIR = STM32_F105-07_F2xx_USB-Host-Device_Lib_V2.0.0

# Set CROSS_COMPILE to match your EABI toolchain, e.g.:
# make CROSS_COMPILE=/path/to/arm-2011.03/bin/arm-none-eabi-
CC      = $(CROSS_COMPILE)gcc
AS      = $(CROSS_COMPILE)as
LD      = $(CROSS_COMPILE)gcc
CP      = ${CROSS_COMPILE}objcopy
PROJECT = usbhost

# We need to add stubs or implementations for certain C library functions:
CSTUBS = ./newlib_stubs.c

# And the vector table for the chip matching our target
# and the above evaluation board:
VECTOR = $(STDIR)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F2xx/startup/TrueSTUDIO/startup_stm32f2xx.s

# We need to specify a linker script for the linker
LDSCRIPT = $(STDIR)/Project/USB_Host_Examples/HID/TrueSTUDIO/STM322xG-EVAL_USBH-HS/stm32_flash.ld
LDFLAGS  = -T$(LDSCRIPT)

# Grep for <locationURI> in 
# Project/<example>/<example>/TrueSTUDIO/<board>/.project and 
# remove non-source files, like *.txt and .metadata
# These are from
# Project/USB_Host_Examples/HID/TrueSTUDIO/STM322xG-EVAL_USBH-HS/.project:
SRC = $(CSTUBS) \
      $(VECTOR) \
      $(STDIR)/Project/USB_Host_Examples/HID/src/main.c \
      $(STDIR)/Project/USB_Host_Examples/HID/src/stm32fxxx_it.c \
      $(STDIR)/Project/USB_Host_Examples/HID/src/usb_bsp.c \
      $(STDIR)/Project/USB_Host_Examples/HID/src/usbh_usr.c \
      $(STDIR)/Project/USB_Host_Examples/HID/src/usbh_usr_lcd.c \
      $(STDIR)/Libraries/CMSIS/CM3/CoreSupport/core_cm3.c \
      $(STDIR)/Project/USB_Host_Examples/HID/src/system_stm32f2xx.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/stm32f2xx_dma.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/stm32f2xx_exti.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/stm32f2xx_flash.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/stm32f2xx_gpio.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/stm32f2xx_i2c.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/stm32f2xx_pwr.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/stm32f2xx_rcc.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/stm32f2xx_sdio.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/stm32f2xx_spi.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/stm32f2xx_usart.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/misc.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/stm32f2xx_fsmc.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/stm32f2xx_syscfg.c \
      $(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/src/stm32f2xx_tim.c \
      $(STDIR)/Utilities/STM32_EVAL/Common/lcd_log.c \
      $(STDIR)/Utilities/STM32_EVAL/STM322xG_EVAL/stm322xg_eval_lcd.c \
      $(STDIR)/Utilities/STM32_EVAL/stm32_eval.c \
      $(STDIR)/Libraries/STM32_USB_OTG_Driver/src/usb_core.c \
      $(STDIR)/Libraries/STM32_USB_OTG_Driver/src/usb_hcd.c \
      $(STDIR)/Libraries/STM32_USB_OTG_Driver/src/usb_hcd_int.c \
      $(STDIR)/Libraries/STM32_USB_HOST_Library/Core/src/usbh_core.c \
      $(STDIR)/Libraries/STM32_USB_HOST_Library/Core/src/usbh_hcs.c \
      $(STDIR)/Libraries/STM32_USB_HOST_Library/Core/src/usbh_ioreq.c \
      $(STDIR)/Libraries/STM32_USB_HOST_Library/Core/src/usbh_stdreq.c \
      $(STDIR)/Libraries/STM32_USB_HOST_Library/Class/HID/src/usbh_hid_core.c \
      $(STDIR)/Libraries/STM32_USB_HOST_Library/Class/HID/src/usbh_hid_keybd.c \
      $(STDIR)/Libraries/STM32_USB_HOST_Library/Class/HID/src/usbh_hid_mouse.c

#  C source files
CFILES = $(filter %.c, $(SRC))
#  Assembly source files
ASMFILES = $(filter %.s, $(SRC))

# Object filse
COBJ = $(CFILES:.c=.o)
SOBJ = $(ASMFILES:.s=.o)
OBJ  = $(COBJ) $(SOBJ)

# This list is made with trial and error. Run make, find the missing header,
# add the path to the list.
INC = -I$(STDIR)/Libraries/STM32_USB_HOST_Library/Core/inc/ \
      -I$(STDIR)/Libraries/STM32_USB_HOST_Library/Class/HID/inc/ \
      -I$(STDIR)/Project/USB_Host_Examples/HID/inc/ \
      -I$(STDIR)/Utilities/STM32_EVAL/ \
      -I$(STDIR)/Libraries/STM32_USB_OTG_Driver/inc/ \
      -I$(STDIR)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F2xx/ \
      -I$(STDIR)/Libraries/CMSIS/CM3/CoreSupport/ \
      -I$(STDIR)/Utilities/STM32_EVAL/ \
      -I$(STDIR)/Utilities/STM32_EVAL/STM322xG_EVAL/ \
      -I$(STDIR)/Utilities/STM32_EVAL/Common/ \
      -I$(STDIR)/Libraries/STM32F2xx_StdPeriph_Driver/inc/

# Compile thumb for Cortex M3 with debug info
CFLAGS  = -g -mthumb -mcpu=cortex-m3
ASFLAGS = $(CFLAGS)

# Define certain features matching our target
FEATURES = -DUSE_STM322xG_EVAL \
           -DUSE_STDPERIPH_DRIVER \
           -DUSE_USB_OTG_HS \
           -DUSE_ULPI_PHY \
           -DUSB_OTG_FS_LOW_PWR_MGMT_SUPPORT

all: $(SRC) $(PROJECT).elf $(PROJECT).bin

$(PROJECT).bin: $(PROJECT).elf
	$(CP) -O binary $(PROJECT).elf $@

$(PROJECT).elf: $(OBJ)
	$(LD) $(LDFLAGS) $(OBJ) -o $@

$(COBJ): %.o: %.c
	$(CC) -c $(FEATURES) $(INC) $(CFLAGS) $< -o $@

$(SOBJ): %.o: %.s
	$(AS) -c $(ASFLAGS) $< -o $@

clean:
	rm -f $(PROJECT) $(OBJ)

.PHONY: clean
