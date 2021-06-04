#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

#1)QSPI寄存器
#名称		基地址
baseaddr_table="
QSPI配置寄存器基址 0x00028014000
"

#偏移	标识		说明
offset_table="
0x000	FLASH_CAPACITY	FLASH 容量设置寄存器
0x004	RD_CFG		地址访问读配置寄存器
0x008	WR_CFG		地址访问写配置寄存器
0x00C	FLUSH_REG	写缓冲flush 寄存器
0x010	CMD_PORT	命令端口寄存器
0x014	ADDR_PORT	地址端口寄存器
0x018	HD_PORT		高位数据端口寄存器
0x1C	LD_PORT		低位数据端口寄存器
0x20	FUN_SET		CS设置寄存器
0x24	WIP_RD		WIP读取设置寄存器
0x28	WP_REG		WP寄存器
0x2C	MODE_REG	Mode设置寄存器
"

echo $baseaddr_table
baseaddr=`echo $baseaddr_table | awk -F ' ' '{print $2}'`

for reg in $offset_table
do
	reg_offset=`echo $reg | awk -F ' ' '{print $1}'`
	reg_desc=`echo $reg | awk -F ' ' '{print $2}'`
	reg_name=`echo $reg | awk -F ' ' '{print $3}'`

	addr=$(($baseaddr + $reg_offset))

	echo -e "寄存器地址:$baseaddr+$reg_offset\t\t$reg_name\t$reg_desc"
	busybox devmem $addr
done
