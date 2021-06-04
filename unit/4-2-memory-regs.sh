#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

#1)Memory 控制器 0
#名称		基地址
baseaddr_table="
Memory控制器0 0x00028200000
"

#寄存器名称	偏移	功能描述
offset_table="
DDRC_PADDR	0x0080	Memory控制器地址寄存器
DDRC_PDATA	0x0084	Memory控制器数据寄存器
ECC_ENABLE	0x07a0	ECC使能寄存器
ECC_U_ADDR_L	0x07b8	ECC不可纠地址低位寄存器
ECC_U_ADDR_H	0x07bc	ECC不可纠地址高位寄存器
ECC_U_DATA_L	0x07c0	ECC不可纠数据低位寄存器
ECC_U_DATA_H	0x07c4	ECC不可纠数据高位寄存器
ECC_C_ADDR_L	0x07c8	ECC可纠地址低位寄存器
ECC_C_ADDR_H	0x07cc	ECC可纠地址高位寄存器
ECC_C_DATA_L	0x07d0	ECC可纠数据低位寄存器
ECC_C_DATA_H	0x07d4	ECC可纠数据高位寄存器
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
