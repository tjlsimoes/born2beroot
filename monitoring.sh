#!/bin/bash

# Architecture
arch=$(uname -a)

# Number Physical Processors
cpu_ph=$(grep ^"core id" /proc/cpuinfo | sort -u | wc -l)

# Number Virtual Processors
cpu_v=$(grep --count ^processor /proc/cpuinfo)

# RAM
total_ram=$(free --mega | grep Mem | awk '{print $2}')
used_ram=$(free --mega | grep Mem | awk '{print $3}')
ram_util_rate=$(free --mega | grep Mem | awk '{printf "(%.2f%%)\n", $3/$2*100}')

# Disk usage
total_mem=$(df -m | grep /dev/ | grep -v /boot | awk '{total_mem += $2} END {printf "%.1fGb\n", total_mem/1024}')
used_mem=$(df -m | grep /dev/ | grep -v /boot | awk '{used_mem += $3} END {print used_mem}')
mem_util_rate=$(df -m | grep /dev/ | grep -v /boot | awk '{used_mem += $3} {total_mem += $2} END {printf "(%d%%)\n", used_mem/total_mem*100}')

# Couldn't previously defined variables be used to calculate percentages?

# CPU load
cpu_load=$(vmstat 1 2 | tail -1 | awk '{printf "%.1f%%\n", 100 - $15}')

# Last reboot
last_reboot=$(who -b | awk '{printf "%s %s", $3, $4}')

# LVM
lvm=$(if [ $(lsblk | grep lvm | wc -l) -gt 0 ]; then echo yes; else echo no; fi)

# Number of active conections
nbr_act_conn=$(ss -a | wc -l)

# Number established TCP connections
# tcp_estab=$(ss -ta | grep ESTAB | wc -l)

# Number users using server
nbr_online_users=$(users | wc -w)

# IPv4 address
ip_4=$(hostname -I)

# MAC address
mac=$(ip address | grep link/ether | awk '{print $2}')

# Number commands executed with sudo program
sudo_cmds=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall "  
        #Architecture   : $arch
        #CPU physical   : $cpu_ph
        #vCPU           : $cpu_v
        #Memory Usage   : $used_ram/$total_ram $ram_util_rate
        #Disk Usage     : $used_mem/$total_mem $mem_util_rate
        #CPU load       : $cpu_load
        #Last boot      : $last_reboot
        #LVM use        : $lvm
        #Active connections : $nbr_act_conn
        #User log       : $nbr_online_users
        #Network        : IPv4 $ip_4
        #Sudo           : $sudo_cmds"
