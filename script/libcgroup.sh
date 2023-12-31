# $1:task_name $2:cgroup_name $3:"cpuset"/"stune"
change_task_cgroup() {
	for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
		for temp_tid in $(ls "/proc/$temp_pid/task/"); do
			comm="$(cat "/proc/$temp_pid/task/$temp_tid/comm")"
			echo "$temp_tid" >"/dev/$3/$2/tasks"
		done
	done
}

# $1:process_name $2:cgroup_name $3:"cpuset"/"stune"
change_proc_cgroup() {
	for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
		comm="$(cat "/proc/$temp_pid/comm")"
		echo "$temp_pid" >"/dev/$3/$2/cgroup.procs"
	done
}

# $1:task_name $2:thread_name $3:cgroup_name $4:"cpuset"/"stune"
change_thread_cgroup() {
	for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
		for temp_tid in $(ls "/proc/$temp_pid/task/"); do
			comm="$(cat "/proc/$temp_pid/task/$temp_tid/comm")"
			[[ "$(echo "$comm" | grep -i -E "$2")" != "" ]] && echo "$temp_tid" >"/dev/$4/$3/tasks"
		done
	done
}

# $1:task_name $2:cgroup_name $3:"cpuset"/"stune"
change_main_thread_cgroup() {
	for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
		comm="$(cat "/proc/$temp_pid/comm")"
		echo "$temp_pid" >"/dev/$3/$2/tasks"
	done
}

# $1:task_name $2:hex_mask(0x00000003 is CPU0 and CPU1)
change_task_affinity() {
	for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
		for temp_tid in $(ls "/proc/$temp_pid/task/"); do
			comm="$(cat "/proc/$temp_pid/task/$temp_tid/comm")"
			taskset -p "$2" "$temp_tid" >>"$bbn_log"
		done
	done
}

# $1:task_name $2:thread_name $3:hex_mask(0x00000003 is CPU0 and CPU1)
change_thread_affinity() {
	for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
		for temp_tid in $(ls "/proc/$temp_pid/task/"); do
			comm="$(cat "/proc/$temp_pid/task/$temp_tid/comm")"
			[[ "$(echo "$comm" | grep -i -E "$2")" != "" ]] && taskset -p "$3" "$temp_tid" >>"$bbn_log"
		done
	done
}

# $1:task_name $2:nice(relative to 120)
change_task_nice() {
	for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
		for temp_tid in $(ls "/proc/$temp_pid/task/"); do
			renice -n +40 -p "$temp_tid"
			renice -n -19 -p "$temp_tid"
			renice -n "$2" -p "$temp_tid"
		done
	done
}

# $1:task_name $2:thread_name $3:nice(relative to 120)
change_thread_nice() {
	for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
		for temp_tid in $(ls "/proc/$temp_pid/task/"); do
			comm="$(cat "/proc/$temp_pid/task/$temp_tid/comm")"
			[[ "$(echo "$comm" | grep -i -E "$2")" != "" ]] && {
				renice -n +40 -p "$temp_tid"
				renice -n -19 -p "$temp_tid"
				renice -n "$3" -p "$temp_tid"
			}
		done
	done
}

# $1:task_name $2:priority(99-x, 1<=x<=99) (SCHED_RR)
change_task_rt() {
	for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
		for temp_tid in $(ls "/proc/$temp_pid/task/"); do
			comm="$(cat "/proc/$temp_pid/task/$temp_tid/comm")"
			chrt -p "$temp_tid" "$2" >>"$bbn_log"
		done
	done
}

# $1:task_name $2:priority(99-x, 1<=x<=99) (SCHED_FIFO)
change_task_rt_ff() {
	for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
		for temp_tid in $(ls "/proc/$temp_pid/task/"); do
			comm="$(cat "/proc/$temp_pid/task/$temp_tid/comm")"
			chrt -f -p "$temp_tid" "$2" >>"$bbn_log"
		done
	done
}

# $1:task_name $2:thread_name $3:priority(99-x, 1<=x<=99)
change_thread_rt() {
	for temp_pid in $(echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}'); do
		for temp_tid in $(ls "/proc/$temp_pid/task/"); do
			comm="$(cat "/proc/$temp_pid/task/$temp_tid/comm")"
			[[ "$(echo "$comm" | grep -i -E "$2")" != "" ]] && chrt -p "$3" "$temp_tid" >>"$bbn_log"
		done
	done
}

unpin_thread() { change_thread_cgroup "$1" "$2" "" "cpuset"; }

# 0-3
pin_thread_on_pwr() {
	unpin_thread "$1" "$2"
	change_thread_affinity "$1" "$2" "0f"
}

# 0-6
pin_thread_on_mid() {
	unpin_thread "$1" "$2"
	change_thread_affinity "$1" "$2" "7f"
}

# 4-7
pin_thread_on_perf() {
	unpin_thread "$1" "$2"
	change_thread_affinity "$1" "$2" "f0"
}

# 0-7
pin_thread_on_all() {
	unpin_proc "$1"
	change_task_affinity "$1" "ff"
}

# $1:task_name $2:thread_name $3:hex_mask
pin_thread_on_custom() {
	unpin_thread "$1" "$2"
	change_thread_affinity "$1" "$2" "$3"
}

# $1:task_name
unpin_proc() { change_task_cgroup "$1" "" "cpuset"; }

# 0-3
pin_proc_on_pwr() {
	unpin_proc "$1"
	change_task_affinity "$1" "0f"
}

# 0-6
pin_proc_on_mid() {
	unpin_proc "$1"
	change_task_affinity "$1" "7f"
}

# 4-7
pin_proc_on_perf() {
	unpin_proc "$1"
	change_task_affinity "$1" "f0"
}

# 0-7
pin_proc_on_all() {
	unpin_proc "$1"
	change_task_affinity "$1" "ff"
}

# $1:task_name $2:hex_mask
pin_proc_on_custom() {
	unpin_proc "$1"
	change_task_affinity "$1" "$2"
}

rebuild_ps_cache() { ps_ret="$(ps -Ao pid,args)"; }
