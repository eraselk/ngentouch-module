#!/bin/sh
# Copyright eraselk 2023-2024

change_task_cgroup() {
  echo "$ps_ret" | grep -i -E "$1" | awk '{print $1}' | while read -r temp_pid; do
    ls "/proc/$temp_pid/task/" | while read -r temp_tid; do
      comm=$(cat "/proc/$temp_pid/task/$temp_tid/comm")
      echo "$temp_tid" > "/dev/$3/$2/tasks"
    done
  done
}
