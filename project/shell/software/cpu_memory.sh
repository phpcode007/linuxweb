#!/bin/bash

cpu_info=$(cat /proc/cpuinfo |grep -c "cores")
memoryinfo=$(awk '($1 == "MemTotal:"){print $2/1048576}' /proc/meminfo)