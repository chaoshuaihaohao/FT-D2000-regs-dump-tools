#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

#1)GMAC公共寄存器
#名称		基地址
baseaddr_table="
GPIO0控制寄存器 0x00028004000

GPIO1控制寄存器 0x00028005000
"

offset_table="
GPIO_SWPORTA_DR		0x00	A组端口输出寄存器

GPIO_SWPORTA_DDR	0x04	A组端口方向控制寄存器

GPIO_EXT_PORTA		0x08	A组端口输入寄存器

GPIO_SWPORTB_DR		0x0c	B组端口输出寄存器

GPIO_SWPORTB_DDR	0x10	B组端口方向控制寄存器

GPIO_EXT_PORTB		0x14	B组端口输入寄存器

GPIO_INTEN		0x18	A组端口中断使能寄存器

GPIO_INTMASK		0x1c	A组端口中断屏蔽寄存器

GPIO_INTTYPE_LEVEL	0x20	A组端口中断等级寄存器

GPIO_INT_POLARITY	0x24	A组端口中断极性寄存器

GPIO_INTSTATUS		0x28	A组端口中断状态寄存器

GPIO_RAW_INTSTATUS	0x2c	A组端口原始中断状态寄存器

GPIO_LS_SYNC		0x30	配置中断同步寄存器

GPIO_DEBOUNCE		0x34	防反跳配置寄存器

GPIO_PORTA_EOI		0x38	A组端口中断清除寄存器
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
