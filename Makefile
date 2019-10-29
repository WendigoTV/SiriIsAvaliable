THEOS_DEVICE_IP = 192.168.1.108
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SiriIsAvaliable

SiriIsAvaliable_FILES = Tweak.x
SiriIsAvaliable_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
