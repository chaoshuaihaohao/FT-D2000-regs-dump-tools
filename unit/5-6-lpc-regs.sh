#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

#1)GMAC公共寄存器
#名称		基地址
baseaddr_table="
LPC 0x00020000000
"

offset_table="
INT_APB_SPCE_CONF	0x7FFFFFC	配置APB 接口地址的设备类型寄存器

REG_LONG_TIMEOUT	0x7FFFFF8	长等待超时控制寄存器

INT_STATE		0x7FFFFF4	中断状态寄存器

CLR_INT			0x7FFFFF0	中断清除寄存器

NU_SERIRQ_CONFIG	0x7FFFFE8	配置寄存器

CLK_LPC_RSTN_O		0x7FFFFE4	控制外设复位寄存器

FIRMWR_ID_CONF_STRTB	0x7FFFFE0	firmware设备ID选择配置寄存器

DMA_CHNNLNU_CONF	0x7FFFFDC	DMA设备ID配置寄存器

INT_MASK		0x7FFFFD8	中断屏蔽寄存器

START_CYCLE		0x7FFFFD4	配置启动周期寄存器

MEM_HIGHBIT_ADDR	0x7FFFFD0	Memory访问的高5位地址

CLK_LPC_RSTN_O		0x7FFFFCC	控制外设复位寄存器
"

echo $baseaddr_table
baseaddr=`echo $baseaddr_table | awk -F ' ' '{print $2}'`

for reg in $offset_table
do
	reg_name=`echo $reg | awk -F ' ' '{print $1}'`
	reg_offset=`echo $reg | awk -F ' ' '{print $2}'`
	reg_desc=`echo $reg | awk -F ' ' '{print $3}'`

	addr=$(($baseaddr + $reg_offset))

	echo -e "寄存器地址:$baseaddr+$reg_offset\t\t$reg_name\t$reg_desc"
	busybox devmem $addr
done
