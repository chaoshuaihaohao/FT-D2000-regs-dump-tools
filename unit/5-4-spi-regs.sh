#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

#1)QSPI寄存器
#名称		基地址
baseaddr_table="
SPIM0 0x2800c000
SPIM1 0x28013000
"

#寄存器 偏移（ 0x） description
offset_table="

CTRLR0 00 控制寄存器0

CTRLR1 04 控制寄存器1

SSIENR 08 SPI使能寄存器

MWCR 0c Microwire控制

SER 10 从机使能寄存器

BAUDR 14 波特率选择寄存器

TXFTLR 18 发送 FIFO阙值寄存器

RXFTLR 1c 接收 FIFO阙值寄存器

TXFLR 20 发送 FIFO等级寄存器

RXFLR 24 接收 FIFO等级寄存器

SR 28 状态寄存器

IMR 2c 中断屏蔽寄存器

ISR 30 多主机竞争中断状态寄存器
RISR 34 中断状态寄存器

TXOICR 38 清除发送FIFO溢出中断寄存器

RXOICR 3c 清除接收FIFO溢出中断寄存器

RXUICR 40 清除发送FIFO下溢中断寄存器

MSTICR 44 清除多主机争用中断寄存器

ICR 48 中断清除寄存器

DMACR 4c DMA控制寄存器

DMATDLR 50 DMA发送数据等级寄存器

DMARDLR 54 DMA接收数据等级寄存器

IDR 58 识别码

ID 5c 保留

DR 60-ec 数据寄存器

RX_SAMPLE_DLY fc 接收数据延时寄存器
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

		reg_offset=0x$reg_offset
		addr=$(($baseaddr + $reg_offset))

		echo -e "寄存器地址:$baseaddr+$reg_offset\t\t$reg_name\t$reg_desc"
		busybox devmem $addr
	done
done
