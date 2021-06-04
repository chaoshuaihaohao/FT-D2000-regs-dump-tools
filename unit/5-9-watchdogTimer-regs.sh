#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

#1)GMAC公共寄存器
#名称		基地址
baseaddr_table="
WDT0 0x0002800A000

WDT1 0x00028016000
"

offset_table="
WDT_WRR		0x0000	Watchdog更新寄存器

WDT_W_IIR	0x0FCC	Watchdog接口身份识别寄存器

WDT_W_IIR	0x1FCC	Watchdog接口身份识别寄存器

WDT_WCS		0x1000	Watchdog控制和状态寄存器

WDT_WOR		0x1008	Watchdog清除寄存器

WDT_WCVL	0x1010	Watchdog比较值的低32bits寄存器

WDT_WCVH	0x1014	Watchdog比较值的高32bits寄存器
"

for entry in $baseaddr_table
do
	echo $entry
	baseaddr=`echo $entry | awk -F ' ' '{print $2}'`
	for reg in $offset_table
	do
		reg_desc=`echo $reg | awk -F ' ' '{print $1}'`
		reg_offset=`echo $reg | awk -F ' ' '{print $2}'`
		reg_name=`echo $reg | awk -F ' ' '{print $3}'`

		reg_offset=$reg_offset
		addr=$(($baseaddr + $reg_offset))

		echo -e "寄存器地址:$baseaddr+$reg_offset\t\t$reg_name\t$reg_desc"
		busybox devmem $addr
	done
done
