#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

#1)GMAC公共寄存器
#名称		基地址
baseaddr_table="
HDA 0x000_28206000
"

offset_table="
GCAP	00	全局性能寄存器，用来说明一个frame中支持多少Stream、是否支持64位寻址

VMIN	02	版本编号低位寄存器

VMAJ	03	版本编号高位寄存器

OUTPAY	04	用来说明输入输出frame中可以最多包含多

INPAY	06	少word的数据

GCTL	08	全局控制类寄存器，说明是否接受unsolicited响应以及Flush操作CRST信号可进行controller的软复位

WAKEEN	0C	标志SDIx线是否允许产生wake中断

STATESTS	0E	标志着哪个SDIx线有codec连接

GSTS	10	标志开始了Flush操作

OUTSTRMPAY	18	表示实际中，一个输出/输入frame中的word

INSTRMPAY	1A	数量

INTCTL	20	总的中断控制寄存器，控制三大类型的中断，判断是否将中断信号输出

INTSTS	24	总的中断状态寄存器，与中断控制寄存器相配合，控制中断信号的输出

INT_MODEL	230	配置中断模式[0]表示对rirb类型的中断模式控制[4:7]：InputStream中断模式控制[11:8]:OutputStream中断模式控制配置为1，表示采用中断采用delay输出的方

式；

配置为0，表示中断采用bvalid计数的方式

[11:8]固定配置为全1；

STRM1_DELY240针对4个Inputstream，若配置为0模式的时

候，dely周期数值的配置；

4个Outputstream的dely固定是0

STRM2_DELY244

STRM3_DELY248

STRM4_DELY24c

WallClock

Counter

30

用来针对用一个系统中不同controller传输

数据时候的同步

SSYNC38

配合RUN位，实现对同一个controller中的

stream之间数据接收与发送的同步

CORBLBA40CORB在DDR中的基地址信息

CORBUBA44

CORBWP48CORB的写指针，由软件写入

CORBRP4ACORB的读指针，由硬件写入

CORBCTL4C控制着DMAC是否开始从CORB中取数据，

以及CMEI中断允许与否的控制

CORBSTS4D状态标志位，是否产生CMEI中断

CORBSIZE4ECORB允许设定尺寸以及实际尺寸

RIRBLBA50RIRB在DDR中的基地址信息

RIRBUBA54

RIRBWP58RIRB的写指针，硬件写入，软件读取

RINTCNT5A记录接收的Rsponses数量，用N表示

RIRBCTL5C

RIRB控制寄存器，控制中断的产生以及是

否允许DMAC操作RUN位

RIRBSTS5D存放中断的状态标志信息

RIRBSIZE5ERIRB允许设定尺寸以及实际尺寸

DPLBASE70内容为DMAPositionBuffer在DDR中的地

DPUBASE74址信息，Controller会更新Buffer中内容

SD1CTL80

StreamDescriptor控制寄存器，含StreamID,

SDO数量，RUN和SRST位

SD1STS83

StreamDescriptor状态寄存器，包括FIFO中

断的状态，IOC中断状态等

SD1LPIB84

LinkPositionBuffer寄存器，表明当前从已

经取出多少Byte数据到DDR中

SD1CBL88

CyclicBufferLength，用来说明当前cyclic

buffer的byte数目，由软件写入

SD1LVI8C

LastValidIndex寄存器，表示BDL列表中最

后一个可引用的条目，由软件写入

SD1FIFOS90表示当前描述符对应FIFO的尺寸

SD1FMT92

为StreamDescriptor的格式信息保存的寄存

器

SD1BDPL98内容位BDL基地址信息

SD1BDPU9C

SD5CTL100

StreamDescriptor控制寄存器，含StreamID,

SDO数量，RUN和SRST位

SD5STS103

StreamDescriptor状态寄存器，包括FIFO中

断的状态，IOC中断状态等

SD5LPIB104

LinkPositionBuffer寄存器，表明当前从已

经取出多少Byte数据到DDR中

SD5CBL108

CyclicBufferLength，用来说明当前cyclic

buffer的byte数目，由软件写入

SD5LVI10C

LastValidIndex寄存器，表示BDL列表中最

后一个可引用的条目，由软件写入

SD5FIFOS110表示当前描述符对应FIFO的尺寸

SD5FMT112

为StreamDescriptor的格式信息保存的寄存

器

SD5BDPL118内容位BDL基地址信息

SD5BDPU11C

SD2CTLA0

StreamDescriptor控制寄存器，含StreamID,

SDO数量，RUN和SRST位

SD2STSA3

StreamDescriptor状态寄存器，包括FIFO中

断的状态，IOC中断状态等

SD2LPIBA4

LinkPositionBuffer寄存器，表明当前从已

经取出多少Byte数据到DDR中

SD2CBLA8

CyclicBufferLength，用来说明当前cyclic

buffer的byte数目，由软件写入

SD2LVIAC

LastValidIndex寄存器，表示BDL列表中最

后一个可引用的条目，由软件写入

SD2FIFOSB0表示当前描述符对应FIFO的尺寸

SD2FMTB2

为StreamDescriptor的格式信息保存的寄存

器

SD2BDPLB8内容位BDL基地址信息

SD2BDPUBC

SD6CTL120

StreamDescriptor控制寄存器，含StreamID,

SDO数量，RUN和SRST位

SD6STS123

StreamDescriptor状态寄存器，包括FIFO中

断的状态，IOC中断状态等

SD6LPIB124

LinkPositionBuffer寄存器，表明当前从已

经取出多少Byte数据到DDR中

SD6CBL128

CyclicBufferLength，用来说明当前cyclic

buffer的byte数目，由软件写入

SD6LVI12C

LastValidIndex寄存器，表示BDL列表中最

后一个可引用的条目，由软件写入

SD6FIFOS130表示当前描述符对应FIFO的尺寸

SD6FMT132

为StreamDescriptor的格式信息保存的寄存

器

SD6BDPL138内容位BDL基地址信息

SD6BDPU13C

SD3CTLC0

StreamDescriptor控制寄存器，含StreamID,

SDO数量，RUN和SRST位

SD3STSC3

StreamDescriptor状态寄存器，包括FIFO中

断的状态，IOC中断状态等

SD3LPIBC4

LinkPositionBuffer寄存器，表明当前从已

经取出多少Byte数据到DDR中

SD3CBLC8

CyclicBufferLength，用来说明当前cyclic

buffer的byte数目，由软件写入

SD3LVICC

LastValidIndex寄存器，表示BDL列表中最

后一个可引用的条目，由软件写入

SD3FIFOSD0表示当前描述符对应FIFO的尺寸

SD3FMTD2

为StreamDescriptor的格式信息保存的寄存

器

SD3BDPLD8内容位BDL基地址信息

SD3BDPUDC

SD7CTL140

StreamDescriptor控制寄存器，含StreamID,

SDO数量，RUN和SRST位

SD7STS143

StreamDescriptor状态寄存器，包括FIFO中

断的状态，IOC中断状态等

SD7LPIB144

LinkPositionBuffer寄存器，表明当前从已

经取出多少Byte数据到DDR中

SD7CBL148

CyclicBufferLength，用来说明当前cyclic

buffer的byte数目，由软件写入

SD7LVI14C

LastValidIndex寄存器，表示BDL列表中最

后一个可引用的条目，由软件写入

SD7FIFOS150表示当前描述符对应FIFO的尺寸

SD7FMT152

为StreamDescriptor的格式信息保存的寄存

器

SD7BDPL158内容位BDL基地址信息

SD7BDPU15C

SD4CTLE0

StreamDescriptor控制寄存器，含StreamID,

SDO数量，RUN和SRST位

SD4STSE3

StreamDescriptor状态寄存器，包括FIFO中

断的状态，IOC中断状态等

SD4LPIBE4

LinkPositionBuffer寄存器，表明当前从已

经取出多少Byte数据到DDR中

SD4CBLE8

CyclicBufferLength，用来说明当前cyclic

buffer的byte数目，由软件写入

SD4LVIEC

LastValidIndex寄存器，表示BDL列表中最

后一个可引用的条目，由软件写入

SD4FIFOSF0表示当前描述符对应FIFO的尺寸

SD4FMTF2

为StreamDescriptor的格式信息保存的寄存

器

SD4BDPLF8内容位BDL基地址信息

SD4BDPUFC

SD8CTL160

StreamDescriptor控制寄存器，含StreamID,

SDO数量，RUN和SRST位

SD8STS163

StreamDescriptor状态寄存器，包括FIFO中

断的状态，IOC中断状态等

SD8LPIB164

LinkPositionBuffer寄存器，表明当前从已

经取出多少Byte数据到DDR中

SD8CBL168

CyclicBufferLength，用来说明当前cyclic

buffer的byte数目，由软件写入

SD8LVI16C

LastValidIndex寄存器，表示BDL列表中最

后一个可引用的条目，由软件写入

SD8FIFOS170表示当前描述符对应FIFO的尺寸

SD8FMT172

为StreamDescriptor的格式信息保存的寄存

器

SD8BDPL178内容位BDL基地址信息

SD8BDPU17C





INT_APB_SPCE_CONF	0x7FFFFFC	配置APB接口地址的设备类型寄存器

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
