# Copyright (C) 2014 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Boot animation
BOOT_ANIMATION_SIZE := 1080p

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

# Inherit some common CM stuff.
$(call inherit-product, vendor/ev/config/common_full_phone.mk)

# Inherit from cancro device
$(call inherit-product, device/xiaomi/cancro/cancro.mk)

PRODUCT_NAME :=ev_cancro
PRODUCT_DEVICE := cancro
PRODUCT_BRAND := Xiaomi
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_MODEL := Mi3W

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

TARGET_CONTINUOUS_SPLASH_ENABLED := true
