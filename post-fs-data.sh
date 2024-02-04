#!/system/bin/sh

# ------ PostFSData ------
# (C) gacorpkjrt°

function set_prop() {
resetprop -n "$1" "$2"
}

set_prop touch.pressure.scale 0
set_prop touch.size.isSummed 0
set_prop view.touch_slop 3
set_prop TapInterval 1ms
set_prop TapDragInterval 1ms
set_prop QuietInterval 1ms
set_prop windowsmgr.max_events_per_sec 500
set_prop MultitouchMinDistance 1px
set_prop MultitouchSettleInterval 1ms
set_prop view.scroll_friction 0
set_prop ro.min_pointer_dur 0
set_prop touch.size.calibration geometric
set_prop touch.size.scale 1
set_prop touch.size.bias 0
set_prop touch.orientation.calibration interpolated
set_prop touch.distance.calibration area
set_prop touch.distance.scale 0
set_prop touch.coverage.calibration box
set_prop touch.gestureMode spots
set_prop touch.orientationAware 0
set_prop touch.pressure.calibration amplitude
set_prop ro.surface_flinger.max_frame_buffer_acquired_buffers 3
set_prop vendor.perf.gestureflingboost.enable true
set_prop view.minimum_fling_velocity 10
set_prop ro.surface_flinger.set_touch_timer_ms 1
