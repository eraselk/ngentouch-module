#!/system/bin/sh
source /data/adb/modules/ngentouch_module/script/libcgroup.sh
# ------ apalah
sleep 40s
(
settings put secure multi_press_timeout 120
settings put secure long_press_timeout 200
settings put global block_untrusted_touches 0
# Realme
for i in /proc/touchpanel; do
echo '1' > $i/game_switch_enable
echo '1' > $i/oppo_tp_direction
echo '0' > $i/oppo_tp_limit_enable
echo '0' > $i/oplus_tp_limit_enable
echo '1' > $i/oplus_tp_direction
done
# Universal, SnapDragon, and mtk
if [[ -e "/sys/devices/virtual/touch/touch_dev/bump_sample_rate" ]]; then
echo "1" > /sys/devices/virtual/touch/touch_dev/bump_sample_rate
elif [[ -e "/sys/touchpanel/double_tap" ]]; then
echo '1' > /sys/touchpanel/double_tap
elif [[ -e "/sys/module/msm_performance/parameters/touchboost" ]]; then
echo '0' > /sys/module/msm_performance/parameters/touchboost
elif [[ -e "/sys/power/pnpmgr/touch_boost" ]]; then
echo '0' > /sys/power/pnpmgr/touch_boost
elif [[ -e "/sys/class/touch/switch/set_touchscreen" ]]; then
echo '7035' > /sys/class/touch/switch/set_touchscreen;
echo '8002' > /sys/class/touch/switch/set_touchscreen;
echo '11000' > /sys/class/touch/switch/set_touchscreen;
echo '13060' > /sys/class/touch/switch/set_touchscreen;
echo '14005' > /sys/class/touch/switch/set_touchscreen;
# Disable touch boost mtk, thanks to @nuuwy0 and @SeeNyx.
elif [[ -e "/proc/perfmgr/tchbst/user/usrtch" ]]; then
echo "enable 0" > /proc/perfmgr/tchbst/user/usrtch
fi

#Scrolling Improvement
change_task_cgroup "servicemanager" "top-app" "cpuset"
change_task_cgroup "servicemanager" "foreground" "stune"
change_task_cgroup "android.phone" "top-app" "cpuset"
change_task_cgroup "android.phone" "foreground" "stune"
#Touch Boost
change_task_cgroup "system_server" "top-app" "cpuset"
change_task_cgroup "system_server" "foreground" "stune"

# INFO
su -lp 2000 -c "cmd notification post -S bigtext -t '[🔔] NgenTouch INFO' 'Tag' 'NgenTouch Module has been running  ✅                                        Please Enjoy your Responsivess and Smoothess.'"
# exit as succesfull
exit 0
) > /dev/null
/system/bin/auto
