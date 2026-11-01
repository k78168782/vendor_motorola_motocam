## Motorola Camera app for AOSP/LOS build — fogos (moto g34 5G) / sm6375 — Android 16

add `$(call inherit-product, vendor/motorola/motocamera/motocamera.mk)` into your fogos device mk.

Original repo: https://gitea.com/JNWSG/vendor_motorola_MotCamera4

### What this port contains
- MotCamera4 (com.motorola.camera3, stock v9.1.30.65) — product/priv-app, privileged, overrides Aperture + Camera2
- MotCamera3AI (content AI plugin)
- MotoSignatureApp + com.motorola.motosignature shared lib (hard requirement of MotCamera4)
- CameraExtensionsProxy, MotoSignature2App, MotorolaSettingsProvider + motsettings
- Face-detection libs (libAncFaceDetect / libancbase_fd)
- Optional: Moto Camera Desktop + ImagerTuning-V + motorola.hardware.camera.imgtuner HAL (gated by MOTOCAMERA_DESKTOP / MOTOCAMERA_IMAGERTUNING, default true)
- Stock camera tuning blobs for the secondary rear sensor
- Stock Motorola camera properties (aux camera exposure, CFA packagelist, etc.)
- SELinux starting point in `sepolicy/camera.te`

### Android 16 notes
- The stock odex/vdex (ART oat files from the stock Android build) were removed: they are incompatible with Android 16 and ART regenerates them from the APK at install time. `dex_preopt.enabled = false` is set on all prebuilt APKs.
- `MotCamera4.apk` is the real stock APK (recovered from Git LFS, ~227 MB).
- `persist.vendor.camera.expose.aux=1` and the aux/CFA packagelists are set in motocamera.mk; `camera.disable_zsl_mode` and `persist.vendor.camera.physical.num` are expected in your device vendor.prop (sm6375-common / fogos).

### Device tree integration (android_device_motorola_fogos)
1. In fogos.mk:
       $(call inherit-product, vendor/motorola/motocamera/motocamera.mk)
2. In BoardConfig.mk:
       BOARD_SEPOLICY_DIRS += vendor/motorola/motocamera/sepolicy
3. Make sure the camera hardware feature XMLs are copied (they are NOT duplicated here to avoid build breakage — they should come from frameworks/native via your device/common mk).
4. The vendor camera HAL + sensor tuning blobs live in proprietary_vendor_motorola_fogos (camera.qcom.so, com.qti.sensormodule.*, libmmcamera.*, etc.) — keep that repo in your vendor tree.

### Build
m -j$(nproc) MotCamera4 MotoSignatureApp com.motorola.motosignature
# the prebuilt APKs are installed into the product image automatically
