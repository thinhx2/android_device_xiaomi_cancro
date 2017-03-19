#!/system/bin/sh
# Copyright (c) 2012, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#      from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#
chown -h root.system /sys/devices/platform/msm_hsusb/gadget/wakeup
chmod -h 220 /sys/devices/platform/msm_hsusb/gadget/wakeup

target=`getprop ro.board.platform`
build_type=`getprop ro.build.type`

#
# Allow USB enumeration with default PID/VID
#
baseband=`getprop ro.baseband`
debuggable=`getprop ro.debuggable`
echo 1  > /sys/class/android_usb/f_mass_storage/lun/nofua
usb_config=`getprop persist.sys.usb.config`
case "$usb_config" in
    "" | "adb" | "none") #USB persist config not set, select default configuration
        case $target in
            "msm8974")
                         if [ -z "$debuggable" -o "$debuggable" = "1" ]; then
                             setprop persist.sys.usb.config mtp,adb
                         else
                             setprop persist.sys.usb.config mtp
                         fi
            ;;
        esac
    ;;
    * )
    ;; #USB persist config exists, do nothing
esac

#
# Add support for exposing lun0 as cdrom in mass-storage
#
target=`getprop ro.product.device`
cdromname="/system/etc/cdrom_install.iso"
cdromenable=`getprop persist.service.cdrom.enable`

#
# Do target specific things
#
case "$target" in
    "msm8974")
# Select USB BAM - 2.0 or 3.0
        echo ssusb > /sys/bus/platform/devices/usb_bam/enable
    ;;
esac

#
# Add changes to support diag with rndis
#
diag_extra=`getprop persist.sys.usb.config.extra`
case "$diag_extra" in
	"diag" | "diag,diag_mdm" | "diag,diag_mdm,diag_qsc")
		case "$baseband" in
			"mdm")
				setprop persist.sys.usb.config.extra diag,diag_mdm
			;;
		        "dsda" | "sglte2" )
				setprop persist.sys.usb.config.extra diag,diag_mdm,diag_qsc
			;;
		        "sglte")
				setprop persist.sys.usb.config.extra diag,diag_qsc
			;;
		        "dsda2")
				setprop persist.sys.usb.config.extra diag,diag_mdm,diag_mdm2
			;;
		        *)
				setprop persist.sys.usb.config.extra diag
			;;
	        esac
	;;
        *)
		setprop persist.sys.usb.config.extra none
	;;
esac
