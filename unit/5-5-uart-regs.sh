#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

#1)QSPI寄存器
#名称		基地址
baseaddr_table="
UART0 0x00028000000

UART1 0x00028001000

UART2 0x00028002000

UART3 0x00028003000
"

#寄存器 偏移（ 0x） description
offset_table="
UARTDR			0x000	数据寄存器
UARTRSR/UARTECR		0x004	接收状态寄存器/错误清除寄存器
UARTFR			0x018	标志寄存器
UARTILPR		0x020	低功耗计数寄存器
UARTIBRD		0x024	波特率整数值配置寄存器
UARTFBRD		0x028	波特率小数值配置寄存器
UARTLCR_H		0x02c	线控寄存器
UARTCR			0x030	控制寄存器
UARTIFLS		0x034	FIFO阈值选择寄存器
UARTIMSC		0x038	中断屏蔽选择/清除寄存器
UARTRIS			0x03c	中断状态寄存器
UARTMIS			0x040	中断屏蔽状态寄存器
UARTICR			0x044	中断清除寄存器
UARTDMACR		0x048	DMA 控制寄存器
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
