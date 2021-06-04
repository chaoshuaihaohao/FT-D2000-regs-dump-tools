#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

#1)GMAC公共寄存器
#名称		基地址
baseaddr_table="
CAN0 0x00028207000

CAN1 0x00028207400

CAN2 0x00028207800
"

offset_table="
CAN_CTRL	0x0000	全局控制寄存器

CAN_INTR	0x0004	中断寄存器

CAN_ARB_RATE_CTRL	0x0008	仲裁段速率控制寄存器

CAN_DAT_RATE_CTRL	0x000c	数据段速率控制寄存器

CAN_ACC_ID0	0x0010	可接收识别符0寄存器

CAN_ACC_ID1	0x0014	可接收识别符1寄存器

CAN_ACC_ID2	0x0018	可接收识别符2寄存器

CAN_ACC_ID3	0x001c	可接收识别符3寄存器

CAN_ACC_ID0_MASK	0x0020	可接收识别符0掩码寄存器

CAN_ACC_ID1_MASK	0x0024	可接收识别符1掩码寄存器

CAN_ACC_ID2_MASK	0x0028	可接收识别符2掩码寄存器

CAN_ACC_ID3_MASK	0x002C	可接收识别符3掩码寄存器

CAN_XFER_STS	0x0030	传输状态寄存器

CAN_ERR_CNT	0x0034	错误计数寄存器

CAN_FIFO_CNT	0x0038	FIFO计数寄存器

CAN_DMA_CTRL	0x003c	DMA请求控制寄存器

CAN_TX_FIFO	0x100~0x1FF	发送FIFO影子寄存器

CAN_RX_FIFO	0x200~0x2FF	接收FIFO影子寄存器
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
