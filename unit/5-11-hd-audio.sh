#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

#1)GMAC公共寄存器
#名称		基地址
baseaddr_table="
HDA 0x00028206000
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
INT_MODEL	230	配置中断模式[0]表示对rirb类型的中断模式控制[4:7]：InputStream中断模式控制[11:8]:OutputStream中断模式控制配置为1，表示采用中断采用delay输出的方式；配置为0，表示中断采用bvalid计数的方式[11:8]固定配置为全1；
STRM1_DELY	240	针对4个Inputstream，若配置为0模式的时候，dely周期数值的配置；4个Outputstream的dely固定是0
STRM2_DELY	244	
STRM3_DELY	248
STRM4_DELY	24c
WallClockCounter	30	用来针对用一个系统中不同controller传输数据时候的同步
SSYNC		38	配合RUN位，实现对同一个controller中的stream之间数据接收与发送的同步
CORBLBA		40	CORB在DDR中的基地址信息
CORBUBA		44
CORBWP		48	CORB的写指针，由软件写入
CORBRP		4A	CORB的读指针，由硬件写入
CORBCTL		4C	控制着DMAC是否开始从CORB中取数据，以及CMEI中断允许与否的控制
CORBSTS		4D	状态标志位，是否产生CMEI中断
CORBSIZE	4E	CORB允许设定尺寸以及实际尺寸
RIRBLBA		50	RIRB在DDR中的基地址信息
RIRBUBA		54
RIRBWP		58	RIRB的写指针，硬件写入，软件读取
RINTCNT		5A	记录接收的Rsponses数量，用N表示
RIRBCTL		5C	RIRB控制寄存器，控制中断的产生以及是否允许DMAC操作RUN位
RIRBSTS		5D	存放中断的状态标志信息
RIRBSIZE	5E	RIRB允许设定尺寸以及实际尺寸
DPLBASE		70	内容为DMAPositionBuffer在DDR中的地
DPUBASE		74	址信息，Controller会更新Buffer中内容
SD1CTL		80	StreamDescriptor控制寄存器，含StreamID,SDO数量，RUN和SRST位
SD1STS		83	StreamDescriptor状态寄存器，包括FIFO中断的状态，IOC中断状态等
SD1LPIB		84	LinkPositionBuffer寄存器，表明当前从已经取出多少Byte数据到DDR中
SD1CBL		88	CyclicBufferLength，用来说明当前cyclicbuffer的byte数目，由软件写入
SD1LVI		8C	LastValidIndex寄存器，表示BDL列表中最后一个可引用的条目，由软件写入
SD1FIFOS	90	表示当前描述符对应FIFO的尺寸
SD1FMT		92	为StreamDescriptor的格式信息保存的寄存器
SD1BDPL		98	内容位BDL基地址信息
SD1BDPU		9C
SD5CTL		100	StreamDescriptor控制寄存器，含StreamID,SDO数量，RUN和SRST位
SD5STS		103	StreamDescriptor状态寄存器，包括FIFO中断的状态，IOC中断状态等
SD5LPIB		104	LinkPositionBuffer寄存器，表明当前从已经取出多少Byte数据到DDR中
SD5CBL		108	CyclicBufferLength，用来说明当前cyclicbuffer的byte数目，由软件写入
SD5LVI		10C	LastValidIndex寄存器，表示BDL列表中最后一个可引用的条目，由软件写入
SD5FIFOS	110	表示当前描述符对应FIFO的尺寸
SD5FMT		112	为StreamDescriptor的格式信息保存的寄存器
SD5BDPL		118	内容位BDL基地址信息
SD5BDPU		11C
SD2CTL		A0	StreamDescriptor控制寄存器，含StreamID,SDO数量，RUN和SRST位
SD2STS		A3	StreamDescriptor状态寄存器，包括FIFO中断的状态，IOC中断状态等
SD2LPIB		A4	LinkPositionBuffer寄存器，表明当前从已经取出多少Byte数据到DDR中
SD2CBL		A8	CyclicBufferLength，用来说明当前cyclicbuffer的byte数目，由软件写入
SD2LVI		AC	LastValidIndex寄存器，表示BDL列表中最后一个可引用的条目，由软件写入
SD2FIFOS	B0	表示当前描述符对应FIFO的尺寸
SD2FMT		B2	为StreamDescriptor的格式信息保存的寄存器
SD2BDPL		B8	内容位BDL基地址信息
SD2BDPU		BC
SD6CTL		120	StreamDescriptor控制寄存器，含StreamID,SDO数量，RUN和SRST位
SD6STS		123	StreamDescriptor状态寄存器，包括FIFO中断的状态，IOC中断状态等
SD6LPIB		124	LinkPositionBuffer寄存器，表明当前从已经取出多少Byte数据到DDR中
SD6CBL		128	CyclicBufferLength，用来说明当前cyclicbuffer的byte数目，由软件写入
SD6LVI		12C	LastValidIndex寄存器，表示BDL列表中最后一个可引用的条目，由软件写入
SD6FIFOS	130	表示当前描述符对应FIFO的尺寸
SD6FMT		132	为StreamDescriptor的格式信息保存的寄存器
SD6BDPL		138	内容位BDL基地址信息
SD6BDPU		13C
SD3CTL		C0	StreamDescriptor控制寄存器，含StreamID,SDO数量，RUN和SRST位
SD3STS		C3	StreamDescriptor状态寄存器，包括FIFO中断的状态，IOC中断状态等
SD3LPIB		C4	LinkPositionBuffer寄存器，表明当前从已经取出多少Byte数据到DDR中
SD3CBL		C8	CyclicBufferLength，用来说明当前cyclicbuffer的byte数目，由软件写入
SD3LVI		CC	LastValidIndex寄存器，表示BDL列表中最后一个可引用的条目，由软件写入
SD3FIFOS	D0	表示当前描述符对应FIFO的尺寸
SD3FMT		D2	为StreamDescriptor的格式信息保存的寄存器
SD3BDPL		D8	内容位BDL基地址信息
SD3BDPU		DC
SD7CTL		140	StreamDescriptor控制寄存器，含StreamID,SDO数量，RUN和SRST位
SD7STS		143	StreamDescriptor状态寄存器，包括FIFO中断的状态，IOC中断状态等
SD7LPIB		144	LinkPositionBuffer寄存器，表明当前从已经取出多少Byte数据到DDR中
SD7CBL		148	CyclicBufferLength，用来说明当前cyclicbuffer的byte数目，由软件写入
SD7LVI		14C	LastValidIndex寄存器，表示BDL列表中最后一个可引用的条目，由软件写入
SD7FIFOS	150	表示当前描述符对应FIFO的尺寸
SD7FMT		152	为StreamDescriptor的格式信息保存的寄存器
SD7BDPL		158	内容位BDL基地址信息
SD7BDPU		15C
SD4CTL		E0	StreamDescriptor控制寄存器，含StreamID,SDO数量，RUN和SRST位
SD4STS		E3	StreamDescriptor状态寄存器，包括FIFO中断的状态，IOC中断状态等
SD4LPIB		E4	LinkPositionBuffer寄存器，表明当前从已经取出多少Byte数据到DDR中
SD4CBL		E8	CyclicBufferLength，用来说明当前cyclicbuffer的byte数目，由软件写入
SD4LVI		EC	LastValidIndex寄存器，表示BDL列表中最后一个可引用的条目，由软件写入
SD4FIFOS	F0	表示当前描述符对应FIFO的尺寸
SD4FMT		F2	为StreamDescriptor的格式信息保存的寄存器
SD4BDPL		F8	内容位BDL基地址信息
SD4BDPU		FC
SD8CTL		160	StreamDescriptor控制寄存器，含StreamID,SDO数量，RUN和SRST位
SD8STS		163	StreamDescriptor状态寄存器，包括FIFO中断的状态，IOC中断状态等
SD8LPIB		164	LinkPositionBuffer寄存器，表明当前从已经取出多少Byte数据到DDR中
SD8CBL		168	CyclicBufferLength，用来说明当前cyclicbuffer的byte数目，由软件写入
SD8LVI		16C	LastValidIndex寄存器，表示BDL列表中最后一个可引用的条目，由软件写入
SD8FIFOS	170	表示当前描述符对应FIFO的尺寸
SD8FMT		172	为StreamDescriptor的格式信息保存的寄存器
SD8BDPL		178	内容位BDL基地址信息
SD8BDPU		17C
"

echo $baseaddr_table
baseaddr=`echo $baseaddr_table | awk -F ' ' '{print $2}'`

for reg in $offset_table
do
	reg_name=`echo $reg | awk -F ' ' '{print $1}'`
	reg_offset=`echo $reg | awk -F ' ' '{print $2}'`
	reg_desc=`echo $reg | awk -F ' ' '{print $3}'`

	addr=$(($baseaddr + 0x$reg_offset))

	echo -e "寄存器地址:$baseaddr+0x$reg_offset\t\t$reg_name\t$reg_desc"
	busybox devmem $addr
done
