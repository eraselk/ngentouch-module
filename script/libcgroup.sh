#!/bin/sh
# Copyright eraselk 2023-2024

change_task_cgroup() {
  ps -e | grep -i -E "$1" | awk '{print $1}' | \
  xargs -I{} sh -c 'for tid in /proc/{}/task/*; do echo "${tid##*/}" > "/dev/$3/$2/tasks"; done'
}
