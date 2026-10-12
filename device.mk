#
# Copyright (C) 2021-2022 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

TARGET_HAS_UDFPS := true
TARGET_IS_LEGACY := true

# Inherit from sm8150-common
$(call inherit-product, device/xiaomi/sm8150-common/msmnile.mk)

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi


# Audio
PRODUCT_PACKAGES += \
    audio.primary.msmnile \
    audio_amplifier.msmnile

# Audio configs
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/audio/,$(TARGET_COPY_OUT_VENDOR)/etc)

# Boot animation
TARGET_SCREEN_HEIGHT := 2340
TARGET_SCREEN_WIDTH := 1080

# Camera
PRODUCT_PACKAGES += \
    libMegviiFacepp-0.5.2 \
    libmegface \
    libpiex_shim

# Camera motor
PRODUCT_PACKAGES += \
    vendor.xiaomi.hardware.motor@1.0-service.xml

PRODUCT_PACKAGES += \
    vendor.xiaomi.hardware.motor@1.0.vendor

# Init
$(call soong_config_set,xiaomi_msmnile,variant_lib,//$(LOCAL_PATH):libvariant_xiaomi_raphael)

# Overlays
PRODUCT_PACKAGES += \
    ApertureOverlayDevice \
    FrameworkResOverlayDevice \
    LineageSDKOverlayDevice \
    LineageSystemUIOverlayDevice \
    SettingsOverlayDevice \
    SystemUIOverlayDevice

# QDCM
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/qdcm/,$(TARGET_COPY_OUT_VENDOR)/etc)

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 28

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Inherit from vendor blobs
$(call inherit-product, vendor/xiaomi/raphael/raphael-vendor.mk)

# Screen-off fingerprint unlock. sensors.udfps (hardware/xiaomi/sensors) turns
# the touch driver's /sys/touchpanel/fp_state into the wake-up
# org.lineageos.sensor.udfps sensor that SystemUI's doze path listens to; it is
# loaded through vendor/etc/sensors/hals.conf next to sensors.ssc.
PRODUCT_PACKAGES += \
    sensors.udfps

# Boot debugging: adb comes up without the authorization prompt (the screen
# never gets past the logo), the kernel log goes into logcat and logs are
# streamed to /metadata/raphael-debug. Always on for userdebug/eng, where adbd
# also starts as root; force it on a user build with RAPHAEL_BOOT_DEBUG=true.
ifneq ($(RAPHAEL_BOOT_DEBUG)$(filter userdebug eng,$(TARGET_BUILD_VARIANT)),)
PRODUCT_PACKAGES += \
    init.raphael.debug.rc \
    raphael-debuglog.sh

PRODUCT_PRODUCT_PROPERTIES += \
    ro.adb.secure=0 \
    persist.sys.usb.config=mtp,adb \
    ro.logd.kernel=true \
    persist.logd.size=16M \
    persist.logd.logpersistd=logcatd \
    persist.logd.logpersistd.buffer=all \
    persist.logd.logpersistd.size=30

ifneq ($(filter userdebug eng,$(TARGET_BUILD_VARIANT)),)
PRODUCT_PRODUCT_PROPERTIES += \
    service.adb.root=1
endif
endif
