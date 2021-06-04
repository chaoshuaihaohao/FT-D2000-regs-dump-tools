#!/bin/bash
IFS=$'\n\n'

if [ `id -u` != 0 ];then
        echo "Permission denied, Please run as root!"
        exit
fi

#1)GMAC公共寄存器
#名称		基地址
baseaddr_table="
GMAC公共寄存器	0x0002820B000
"

offset_table="
REG_GMAC0_AWCACHE       0x0     Gmac0AXI总线写地址通道cache域
REG_GMAC0_ARCACHE       0x4     Gmac0AXI总线读地址通道cache域
REG_GMAC0_AWDOMAIN      0x8     Gmac0AXI总线写地址通道domain域
REG_GMAC0_ARDOMAIN      0xC     Gmac0AXI总线读地址通道domain域
REG_GMAC0_AWBAR         0x10    Gmac0AXI写地址通道bar域
REG_GMAC0_ARBAR         0x14    Gmac0AXI读地址通道bar域
REG_GMAC0_AWSNOOP       0x18    Gmac0AXI写地址通道snoop域
REG_GMAC0_ARSNOOP       0x1C    Gmac0AXI读地址通道snoop域
REG_GMAC0_AWPROT        0x20    Gmac0AXI写地址通道prot域
REG_GMAC0_ARPROT        0x24    Gmac0AXI读地址通道prot域
REG_GMAC0_AWBASE_ADDR   0x28    Gmac0AXI写地址通道base域
REG_GMAC0_ARBASE_ADDR   0x2C    Gmac0AXI读地址通道base域
REG_GMAC1_AWCACHE       0x100   Gmac1AXI写地址通道cache域
REG_GMAC1_ARCACHE       0x104   Gmac1AXI读地址通道cache域
REG_GMAC1_AWDOMAIN      0x108   Gmac1AXI写地址通道domain域
REG_GMAC1_ARDOMAIN      0x10C   Gmac1AXI读地址通道domain域
REG_GMAC1_AWBAR         0x110   Gmac1AXI写地址通道bar域
REG_GMAC1_ARBAR         0x114   Gmac1AXI读地址通道bar域
REG_GMAC1_AWSNOOP       0x118   Gmac1AXI写地址通道snoop域
REG_GMAC1_ARSNOOP       0x11C   Gmac1AXI读地址通道snoop域
REG_GMAC1_AWPROT        0x120   Gmac1AXI写地址通道prot域
REG_GMAC1_ARPROT        0x124   Gmac1AXI读地址通道prot域
REG_GMAC1_AWBASE_ADDR   0x128   Gmac1AXI写地址通道base域
REG_GMAC1_ARBASE_ADDR   0x12C   Gmac1AXI读地址通道base域
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

#2）GMAC0私有寄存器
#名称		基地址
baseaddr_table="
GMAC0私有寄存器	0x0002820C000
"

#2.1)GMAC0控制寄存器
offset_table="
MAC配置寄存器		0x0000		这是MAC的操作模式寄存器。
Mac帧过滤		0x0004		包含帧过滤控件。
哈希表高位寄存器	0x0008		包含多播哈希表的高32位。
哈希表低位寄存器	0x000c		包含多播哈希表的低32位。
GMII地址寄存器		0x0010		控制外部PHY的管理周期。
GMII数据寄存器		0x0014		包含要写入PHY寄存器或从PHY寄存器读取的数据。
流控寄存器		0x0018		控制控制帧的生成。
VLAN标记寄存器		0x001C		标识IEEE802.1QVLAN类型帧。
版本寄存器		0x0020		标识Core的版本。
调试寄存器		0x0024		给出各种内部块的状态以进行调试。
LPI控制和状态寄存器	0x0030		控制低功耗空闲（LPI）操作并提供内核的LPI状态。
LPI定时器控制寄存器	0x0034		控制LPI状态中的超时值。
中断状态寄存器		0x0038		包含中断状态。
中断屏蔽寄存器		0x003C		包含用于生成中断的掩码。
MAC地址0高寄存器	0x0040		包含第一个MAC地址的高16位。
MAC地址0低寄存器	0x0044		包含第一个MAC地址的低32位。
MAC地址1高寄存器	0x0048		包含第二个MAC地址的高16位。
MAC地址1低寄存器	0x004C		包含第二个MAC地址的低32位。
寄存器54		0X00D8		表示通过RGMII或从PHY接收的状态信号。
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


#2.2)GMAC0 DMA寄存器
#寄存器		偏移	描述
offset_table="
总线模式寄存器			0x1000	控制主机接口模式
发送轮询请求寄存器		0x1004	主机使用它来指示DMA轮询传输描述符列表
发送轮询请求寄存器		0x1008	主机使用它来指示DMA轮询接收描述符列表
接收描述符列表地址寄存器	0x100c	将DMA指向接收描述符列表的开头
发送描述符列表地址寄存器	0x1010	将DMA指向传输描述符列表的开头
状态寄存器			0x1014	软件驱动程序（应用程序）在中断服务程序或轮询期间读取该寄存器以确定DMA的状态
操作模式寄存器			0x1018	建立接收和发送操作模式和命令
中断使能寄存器			0x101c	启用状态寄存器报告的中断
丢帧和缓冲区溢出计数器寄存器	0x1020	包含丢弃帧的计数器，因为没有主机接收描述符可用，并且由于接收FIFO溢出而丢弃帧
接收中断看门狗定时器寄存器	0x1024	从DMA接收中断（RI）的看门狗超时
AXI总线模式寄存器		0x1028	控制AXI主行为（主要控制突发分裂和未完成请求的数量）
AXI状态寄存器			0X102C	在GMAC-AHB配置中给出AHB主接口的空闲状态。在GMAC-AXI配置中给出AXI主机读或写通道的空闲状态
当前主机发送描述符寄存器	0X1048	指向DMA读取的当前发送描述符的开始
当前主机接收描述符寄存器	0X104C	指向DMA读取的当前发送描述符的开始
当前主机发送缓冲地址寄存器	0X1050	指向DMA读取的当前发送缓冲区地址
当前主机发送缓冲地址寄存器	0x1054	指向DMA读取的当前接收缓冲区地址
硬件功能寄存器			0x1058	表示核心的可选功能的存在
"
echo $baseaddr_table GMAC0 DMA寄存器
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

#3）GMAC1私有寄存器
#名称		基地址
baseaddr_table="
GMAC1私有寄存器	0x00028210000
"

#3.1)GMAC1控制寄存器
offset_table="
MAC配置寄存器		0x0000		这是MAC的操作模式寄存器。
Mac帧过滤		0x0004		包含帧过滤控件。
哈希表高位寄存器	0x0008		包含多播哈希表的高32位。
哈希表低位寄存器	0x000c		包含多播哈希表的低32位。
GMII地址寄存器		0x0010		控制外部PHY的管理周期。
GMII数据寄存器		0x0014		包含要写入PHY寄存器或从PHY寄存器读取的数据。
流控寄存器		0x0018		控制控制帧的生成。
VLAN标记寄存器		0x001C		标识IEEE802.1QVLAN类型帧。
版本寄存器		0x0020		标识Core的版本。
调试寄存器		0x0024		给出各种内部块的状态以进行调试。
LPI控制和状态寄存器	0x0030		控制低功耗空闲（LPI）操作并提供内核的LPI状态。
LPI定时器控制寄存器	0x0034		控制LPI状态中的超时值。
中断状态寄存器		0x0038		包含中断状态。
中断屏蔽寄存器		0x003C		包含用于生成中断的掩码。
MAC地址0高寄存器	0x0040		包含第一个MAC地址的高16位。
MAC地址0低寄存器	0x0044		包含第一个MAC地址的低32位。
MAC地址1高寄存器	0x0048		包含第二个MAC地址的高16位。
MAC地址1低寄存器	0x004C		包含第二个MAC地址的低32位。
寄存器54		0X00D8		表示通过RGMII或从PHY接收的状态信号。
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


#3.2)GMAC1 DMA寄存器
#寄存器		偏移	描述
offset_table="
总线模式寄存器			0x1000	控制主机接口模式
发送轮询请求寄存器		0x1004	主机使用它来指示DMA轮询传输描述符列表
发送轮询请求寄存器		0x1008	主机使用它来指示DMA轮询接收描述符列表
接收描述符列表地址寄存器	0x100c	将DMA指向接收描述符列表的开头
发送描述符列表地址寄存器	0x1010	将DMA指向传输描述符列表的开头
状态寄存器			0x1014	软件驱动程序（应用程序）在中断服务程序或轮询期间读取该寄存器以确定DMA的状态
操作模式寄存器			0x1018	建立接收和发送操作模式和命令
中断使能寄存器			0x101c	启用状态寄存器报告的中断
丢帧和缓冲区溢出计数器寄存器	0x1020	包含丢弃帧的计数器，因为没有主机接收描述符可用，并且由于接收FIFO溢出而丢弃帧
接收中断看门狗定时器寄存器	0x1024	从DMA接收中断（RI）的看门狗超时
AXI总线模式寄存器		0x1028	控制AXI主行为（主要控制突发分裂和未完成请求的数量）
AXI状态寄存器			0X102C	在GMAC-AHB配置中给出AHB主接口的空闲状态。在GMAC-AXI配置中给出AXI主机读或写通道的空闲状态
当前主机发送描述符寄存器	0X1048	指向DMA读取的当前发送描述符的开始
当前主机接收描述符寄存器	0X104C	指向DMA读取的当前发送描述符的开始
当前主机发送缓冲地址寄存器	0X1050	指向DMA读取的当前发送缓冲区地址
当前主机发送缓冲地址寄存器	0x1054	指向DMA读取的当前接收缓冲区地址
硬件功能寄存器			0x1058	表示核心的可选功能的存在
"
echo $baseaddr_table GMAC1 DMA寄存器
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
