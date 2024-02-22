#!/bin/sh
# Copyright eraselk 2023-2024

# Rebuilds the process cache
rebuild_ps_cache() {
    ps_ret="$(ps -Ao pid,args)"
}

# Change task's cgroup
change_task_cgroup() {
    local pid
    local cgroup_dir="/dev/$3/$2/tasks"
    pgrep -f "$1" | while read -r pid; do
        echo "$pid" > "$cgroup_dir"
    done
}

# Change process's cgroup
change_proc_cgroup() {
    local pid
    local cgroup_dir="/dev/$3/$2/cgroup.procs"
    pgrep -f "$1" | while read -r pid; do
        echo "$pid" > "$cgroup_dir"
    done
}

# Change thread's cgroup
change_thread_cgroup() {
    local pid
    local cgroup_dir="/dev/$4/$3/tasks"
    pgrep -f "$1" | while read -r pid; do
        find "/proc/$pid/task/" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | while read -r tid; do
            echo "$tid" > "$cgroup_dir"
        done
    done
}

# Change task's CPU affinity
change_task_affinity() {
    pgrep -f "$1" | while read -r pid; do
        taskset -p "$2" "$pid" >> "$bbn_log"
    done
}

# Change task's nice value
change_task_nice() {
    pgrep -f "$1" | while read -r pid; do
        renice -n "$2" -p "$pid"
    done
}

# Change task's real-time priority (SCHED_RR)
change_task_rt() {
    pgrep -f "$1" | while read -r pid; do
        chrt -p "$2" "$pid" >> "$bbn_log"
    done
}

# Change task's real-time priority (SCHED_FIFO)
change_task_rt_ff() {
    pgrep -f "$1" | while read -r pid; do
        chrt -f -p "$2" "$pid" >> "$bbn_log"
    done
}

# Change thread's real-time priority
change_thread_rt() {
    pgrep -f "$1" | while read -r pid; do
        find "/proc/$pid/task/" -mindepth 1 -maxdepth 1 -type d -printf "%f\n" | while read -r tid; do
            chrt -p "$3" "$tid" >> "$bbn_log"
        done
    done
}

# Unpin thread
unpin_thread() {
    change_thread_cgroup "$1" "$2" "" "cpuset"
}
