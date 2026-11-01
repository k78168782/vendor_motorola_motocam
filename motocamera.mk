#
# Motorola camera stack for fogos (moto g34 5G) — full port
#
# Drop-in replacement for vendor/motorola/motocamera/motocamera.mk
#
# Notes
#  * The four vendor/etc/permissions/android.hardware.camera.*.xml files are NOT
#    copied here on purpose: device/motorola/sm6375-common/common.mk already
#    copies them from frameworks/native/data/etc to the same destination, and a
#    second copy of the same PRODUCT_COPY_FILES destination breaks the build.
#  * camera_click.ogg / camera_focus.ogg are also left out: AOSP already installs
#    those two files into $(TARGET_COPY_OUT_PRODUCT)/media/audio/ui.
#

PRODUCT_SOONG_NAMESPACES += vendor/motorola/motocamera

MOTOCAMERA := vendor/motorola/motocamera
MOTOCAMERA_PROPRIETARY := $(MOTOCAMERA)/proprietary

# Optional parts of the stock stack. Set to false in your device mk before
# inheriting this file if you do not want them.
#   MOTOCAMERA_DESKTOP     - Moto Camera Desktop app (phone-as-webcam / desktop)
#   MOTOCAMERA_IMAGERTUNING - ImagerTuning-V app + motorola.hardware.camera.imgtuner HAL
MOTOCAMERA_DESKTOP ?= true
MOTOCAMERA_IMAGERTUNING ?= true

# ---------------------------------------------------------------------------
# Apps / jars / binaries built as Soong modules
# ---------------------------------------------------------------------------
PRODUCT_PACKAGES += \
    MotoSignatureApp \
    MotCamera3AI \
    MotCamera4 \
    MotorolaSettingsProvider \
    com.motorola.motosignature \
    moto-core_services \
    moto-settings \
    motsettings \
    libAncFaceDetect \
    libancbase_fd \
    MotoSignature2App \
    CameraExtensionsProxy \
    MotoSettingsProviderOverlayDPPCamera \
    MotorolaSettingsProvider__fogos_g__auto_generated_rro_product

# ---------------------------------------------------------------------------
# /product configuration
# ---------------------------------------------------------------------------
PRODUCT_COPY_FILES += \
    $(MOTOCAMERA_PROPRIETARY)/product/etc/sysconfig/initial-package-stopped-states-com.motorola.camera3.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/initial-package-stopped-states-com.motorola.camera3.xml \
    $(MOTOCAMERA_PROPRIETARY)/product/etc/sysconfig/hiddenapi-whitelist-com.motorola.camera3.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/hiddenapi-whitelist-com.motorola.camera3.xml \
    $(MOTOCAMERA_PROPRIETARY)/product/etc/permissions/privapp-permissions-com.motorola.camera3.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-com.motorola.camera3.xml \
    $(MOTOCAMERA_PROPRIETARY)/product/etc/permissions/deviceowner-configuration-com.motorola.camera3.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/deviceowner-configuration-com.motorola.camera3.xml \
    $(MOTOCAMERA_PROPRIETARY)/product/etc/permissions/com.motorola.moto-uirefresh.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.motorola.moto-uirefresh.xml \
    $(MOTOCAMERA_PROPRIETARY)/product/etc/permissions/com.motorola.camera3.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.motorola.camera3.xml \
    $(MOTOCAMERA_PROPRIETARY)/product/etc/permissions/com.motorola.camera3.content.ai.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.motorola.camera3.content.ai.xml \
    $(MOTOCAMERA_PROPRIETARY)/product/etc/permissions/com.motorola.camera3.fogos.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.motorola.camera3.fogos.xml \
    $(MOTOCAMERA_PROPRIETARY)/product/etc/permissions/com.motorola.camera3.lens.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/com.motorola.camera3.lens.xml \
    $(MOTOCAMERA_PROPRIETARY)/product/etc/permissions/feature-com.motorola.motcameradesktop.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/feature-com.motorola.motcameradesktop.xml \
    $(MOTOCAMERA_PROPRIETARY)/product/etc/init/init.motcamera3.lens.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.motcamera3.lens.rc \
    $(MOTOCAMERA_PROPRIETARY)/product/etc/MotoDesktopAppConfig/com.motorola.camera3.desktop-config.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/MotoDesktopAppConfig/com.motorola.camera3.desktop-config.xml

# ---------------------------------------------------------------------------
# /system configuration + the second Moto signature app
# ---------------------------------------------------------------------------
PRODUCT_COPY_FILES += \
    $(MOTOCAMERA_PROPRIETARY)/system/etc/permissions/moto-settings.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/moto-settings.xml \
    $(MOTOCAMERA_PROPRIETARY)/system/etc/permissions/moto-core_services.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/moto-core_services.xml \
    $(MOTOCAMERA_PROPRIETARY)/system/etc/permissions/com.motorola.motosignature.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/com.motorola.motosignature.xml

# ---------------------------------------------------------------------------
# /system_ext: Moto settings/libraries the camera binds to
# (androidx.window.extensions / .sidecar are NOT shipped here: the ROM already
#  installs them into system_ext/framework, and every consumer declares them
#  required="false".)
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# /vendor: tuning data for the secondary rear sensor
# ---------------------------------------------------------------------------
PRODUCT_COPY_FILES += \
    $(MOTOCAMERA_PROPRIETARY)/vendor/lib64/camera/com.qti.sensormodule.mot_fogor_s5kjns_qtech_2nd.bin:$(TARGET_COPY_OUT_VENDOR)/lib64/camera/com.qti.sensormodule.mot_fogor_s5kjns_qtech_2nd.bin \
    $(MOTOCAMERA_PROPRIETARY)/vendor/lib64/camera/com.qti.tuned.mot_fogor_s5kjns_2nd.bin:$(TARGET_COPY_OUT_VENDOR)/lib64/camera/com.qti.tuned.mot_fogor_s5kjns_2nd.bin

# ---------------------------------------------------------------------------
# Moto Camera Desktop (optional)
# ---------------------------------------------------------------------------
ifeq ($(MOTOCAMERA_DESKTOP),true)

PRODUCT_PACKAGES += \
    MotCameraDesktop \
    motocamera_desktop_1_0 \
    motocamera_desktop_2_0 \
    motocamera_desktop_jni

PRODUCT_COPY_FILES += \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/framework/com.motorola.hardware.camera.desktop.jar:$(TARGET_COPY_OUT_SYSTEM_EXT)/framework/com.motorola.hardware.camera.desktop.jar \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/etc/permissions/com.motorola.camera.desktop.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/com.motorola.camera.desktop.xml \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/etc/permissions/privapp-permissions-com.motorola.motcameradesktop.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-com.motorola.motcameradesktop.xml \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/etc/sysconfig/hiddenapi-whitelist-com.motorola.motcameradesktop.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/sysconfig/hiddenapi-whitelist-com.motorola.motcameradesktop.xml \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/etc/public.libraries-motocameradesktop.txt:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/public.libraries-motocameradesktop.txt \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/etc/enable-disable-packages/enable-disable-com.motorola.motcameradesktop.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/enable-disable-packages/enable-disable-com.motorola.motcameradesktop.xml \
    $(MOTOCAMERA_PROPRIETARY)/product/etc/init/init.motcameradesktop.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.motcameradesktop.rc

endif

# ---------------------------------------------------------------------------
# ImagerTuning-V + motorola.hardware.camera.imgtuner HAL (optional)
#
# The app reaches the HAL through com.motorola.libimgTuner.jar ->
# libimgTuner_jni.motoimagetuner.so -> motorola.hardware.camera.imgtuner.aidl.
# The camera app itself does not use any of this, so it is safe to disable.
# If you enable it, the imgtuner service needs a SELinux domain; see README.
# ---------------------------------------------------------------------------
ifeq ($(MOTOCAMERA_IMAGERTUNING),true)

PRODUCT_PACKAGES += \
    ImagerTuning-V \
    motocamera_imgtuner_aidl_service \
    motocamera_imgtuner_hidl_service \
    motocamera_imgtuner_jni \
    motocamera_imgtuner_aidl \
    motocamera_imgtuner_1_0 \
    motocamera_imgtuner_aidl_platform \
    motocamera_imgtuner_impl

PRODUCT_COPY_FILES += \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/framework/com.motorola.libimgTuner.jar:$(TARGET_COPY_OUT_SYSTEM_EXT)/framework/com.motorola.libimgTuner.jar \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/framework/com.motorola.imager.v.jar:$(TARGET_COPY_OUT_SYSTEM_EXT)/framework/com.motorola.imager.v.jar \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/etc/permissions/com.motorola.libimgTuner.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/com.motorola.libimgTuner.xml \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/etc/permissions/com.motorola.imager.v.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/com.motorola.imager.v.xml \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/etc/permissions/com.motorola.imagertuning.v.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/com.motorola.imagertuning.v.xml \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/etc/permissions/com.motorola.imagertuning.v.fogos.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/com.motorola.imagertuning.v.fogos.xml \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/etc/permissions/privapp-permissions-com.motorola.imagertuning.v.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-com.motorola.imagertuning.v.xml \
    $(MOTOCAMERA_PROPRIETARY)/system_ext/etc/enable-disable-packages/enable-disable-com.motorola.imagertuning_u.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/enable-disable-packages/enable-disable-com.motorola.imagertuning_u.xml \
    $(MOTOCAMERA_PROPRIETARY)/vendor/etc/init/motorola.hardware.camera.imgtuner.aidl-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/motorola.hardware.camera.imgtuner.aidl-service.rc \
    $(MOTOCAMERA_PROPRIETARY)/vendor/etc/init/motorola.hardware.camera.imgtuner@1.0-service.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/motorola.hardware.camera.imgtuner@1.0-service.rc

endif

# ---------------------------------------------------------------------------
# Stock Motorola camera properties.
#
# These ship in the stock build.prop files, which a device tree regenerates, so
# they never came across with the blobs. Without them the Moto app cannot reach
# the auxiliary cameras, and the CFA (high-resolution / remosaic) capture path is
# not permitted for it at all - which is a bright-light-only code path.
#
# camera.disable_zsl_mode and persist.vendor.camera.physical.num are already set
# in the device tree (sm6375-common/vendor.prop, fogos/vendor.prop), so they are
# deliberately not repeated here.
# ---------------------------------------------------------------------------
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.camera.expose.aux=1 \
    persist.vendor.camera.privapp.list=org.codeaurora.snapcam \
    vendor.camera.aux.packagelist=com.motorola.camera3,com.motorola.motocit \
    vendor.camera.aux.packagelist2=com.motorola.ccc,com.android.settings \
    ro.vendor.camera.noiseVibratortime=180

PRODUCT_SYSTEM_PROPERTIES += \
    ro.camera.cfa.packagelist=com.motorola.coresettingsext,com.motorola.camera2,com.motorola.camera3,com.motorola.actions
