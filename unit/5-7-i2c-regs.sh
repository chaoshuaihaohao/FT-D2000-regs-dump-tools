#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

#1)GMAC公共寄存器
#名称		基地址
baseaddr_table="
I2C0 0x00028006000

I2C1 0x00028007000

I2C2 0x00028008000

I2C3 0x00028009000
"

offset_table="
IC_CON		0x00	I2C控制寄存器

IC_TAR		0x04	I2C主机地址寄存器

IC_SAR		0x08	I2C从机地址寄存器

IC_HS_MADDR	0x0c	I2C高速主机模式编码地址寄存器

IC_DATA_CMD	0x10	I2C数据寄存器

IC_SS_SCL_HCNT	0x14	标准模式I2C时钟信号SCL的高电平计数寄存器

IC_SS_SCL_LCNT	0x18	标准模式I2C时钟信号SCL的低电平计数寄存器

IC_FS_SCL_HCNT	0x1c	快速模式I2C时钟信号SCL的高电平计数寄存器

IC_FS_SCL_LCNT	0x20	快速模式I2C时钟信号SCL的低电平计数寄存器

IC_HS_SCL_HCNT	0x24	高速模式I2C时钟信号SCL的高电平计数寄存器

IC_HS_SCL_LCNT	0x28	高速模式I2C时钟信号SCL的低电平计数寄存器

IC_INTR_STAT	0x2c	I2C中断状态寄存器

IC_INTR_MASK		0x30	I2C中断屏蔽寄存器

IC_RAW_INTR_STAT	0x34	I2C原始中断状态寄存器

IC_RX_TL		0x38	I2C接收FIFO阈值寄存器

IC_TX_TL		0x3c	I2C发送FIFO阈值寄存器

IC_CLR_INTR		0x40	I2C清除组合和单独中断寄存器

IC_CLR_RX_UNDER		0x44	清除RX_UNDER中断寄存器

IC_CLR_RX_OVER		0x48	清除RX_OVER中断寄存器

IC_CLR_TX_OVER		0x4c	清除TX_OVER中断寄存器

IC_CLR_RD_REQ		0x50	清除RD_REQ中断寄存器

IC_CLR_TX_ABRT		0x54	清除TX_ABRT中断寄存器

IC_CLR_RX_DONE		0x58	清除RX_DONE中断寄存器

IC_CLR_ACTIVITY		0x5c	清除ACTIVITY中断寄存器

IC_CLR_STOP_DET		0x60	清除STOP_DET中断寄存器

IC_CLR_START_DET	0x64	清除START_DET中断寄存器

IC_CLR_GEN_CALL		0x68	清除GEN_CALL中断寄存器

IC_ENABLE		0x6c	I2C使能寄存器

IC_STATUS		0x70	I2C状态寄存器

IC_TXFLR		0x74	发送FIFO等级寄存器

IC_RXFLR		0x78	接收FIFO等级寄存器

IC_SDA_HOLD		0x7c	SDA保持时间寄存器

IC_TX_ABRT_SOURCE	0x80	I2C发送异常状态寄存器

IC_SLV_DATA_NACK_ONLY	0x84	产生SLV_DATA_NACK寄存器

IC_DMA_CR		0x88	DMA控制寄存器

IC_DMA_TDLR		0x8c	DMA发送数据阈值

IC_DMA_RDLR		0x90	DMA接收数据阈值

IC_SDA_SETUP		0x94	I2CSDA建立时间寄存器

IC_ACK_GENERAL_CALL	0x98	I2CACK_Gen_Call寄存器

IC_ENABLE_STATUS	0x9c	I2C使能状态寄存器

IC_FS_SPKLEN	0xa0	FS模式尖峰滤波寄存器

IC_HS_SPKLEN	0xa4	HS模式尖峰滤波寄存器

IC_COMP_PARAM_1	0xf4	I2C版本信息寄存器
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
