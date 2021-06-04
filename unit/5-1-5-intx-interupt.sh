#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

offset_table="
PEU0_INTX_STAT	0x29900000
PEU1_INTX_STAT	0x29A00000

PEU0_C0_INTX 0x29900184

PEU0_C1_INTX 0x29910184

PEU0_C2_INTX 0x29920184

PEU1_C0_INTX 0x29930184

PEU1_C1_INTX 0x29940184

PEU1_C2_INTX 0x29950184
"

baseaddr=`echo $baseaddr_table | awk -F ' ' '{print $2}'`

for reg in $offset_table
do
	reg_name=`echo $reg | awk -F ' ' '{print $1}'`
	echo $reg_name
	reg_offset=`echo $reg | awk -F ' ' '{print $2}'`

	addr=$reg_offset

	echo -e "寄存器地址:$addr\t\t$reg_name"
	busybox devmem $addr
done
