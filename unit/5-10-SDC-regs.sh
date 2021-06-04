#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

#1)Memory 控制器 0
#名称		基地址
baseaddr_table="
SDC 0x00028207C00
"

#寄存器名称	偏移	功能描述
offset_table="
CONTROLL_SETTING_REG	0x00	控制器配置寄存器

ARGUMENT_REG		0x04	参数寄存器

CMD_SETTING_REG		0x08	命令寄存器

CLOCK_DIV_REG		0x0C	时钟分频寄存器

SOFTWARE_RESET_REG	0x10	复位控制寄存器

POWER_CONTROLL_REG	0x14	电源控制寄存器

TIMEOUT_CMD_REG		0x18	cmd超时设置寄存器

TIMEOUT_DATA_REG	0x1C	数据超时设置寄存器

NORMAL_INT_EN_REG	0x20	中断使能寄存器

ERROR_INT_EN_REG	0x24	error中断使能寄存器

BD_ISR_EN_REG		0x28	数据传输中断使能寄存器

CAPABILIES_REG		0x2c	状态寄存器

SD_DRV_REG		0x30	SD卡驱动相位寄存器

SD_SAMP_REG		0x34	SD卡采样相位寄存器

SD_SEN_REG		0x38	卡检测控制器

HDS_AXI_REG_CONF1	0x3c	AXI边界配置寄存器1

DAT_IN_M_RX_BD		0x40	SDBDRX地址寄存器

DAT_IN_M_TX_BD		0x60	SDBDTX地址寄存器

BLK_CNT_REG		0x80	块读写配置寄存器

HDS_AXI_REG_CONF2	0xa8	AXI边界配置寄存器2

NORMAL_INT_STATUS_REG	0xc0	中断状态寄存器

ERROR_INT_STATUS_REG	0xc4	error中断寄存器

BD_ISR_REG		0xc8	数据传输中断状态寄存器

BD_STATUS		0xcc	bd描述符寄存器

STATUS_REG		0xd0	状态寄存器

BLOCK			0xd4	块长度寄存器

CMD_RESP_1		0xe0	命令响应寄存器1

CMD_RESP_2		0xe4	命令响应寄存器2

CMD_RESP_3		0xe8	命令响应寄存器3

CMD_RESP_4		0xec	命令响应寄存器4
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



#2)Memory 控制器 1
#名称		基地址
baseaddr_table="
Memory控制器1	0x00028201000
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
