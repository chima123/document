# as-houyi依赖三方库的交叉编译

## UBUNTU22下进行QNX交叉编译

qnx交叉编译工具链和对应的rootfs可以从对应的项目中获取，如为**as-houyi-honda** repo
编译对应三方库，在其repo的env_for_build脚本中会下载相应的工具链和rootfs到其repo的toolchain目录下，
如 **qnx710** 目录。

!!!note
    1. qnx编译之前需要利用rootfs中提供脚本配QNX_SOURCEQNX_SOURCE置其需要使用的环境变量，如 **qnx710/qnxsdp-env.sh** 需要先source一下来配置对应的环境变量
    2. QNX编译一般需要提前设置宏 **_QNX_SOURCE**
    3. as-houyi-XXX 所需三方库一般是在 **as-houyi-third_party**

### 交叉编译工具链：

主要包含：

* 编译器(compiler)用于将源代码转换为目标平台的机器码，如gcc/g++
* 汇编器(assembler)用于将汇编代码转换为目标平台机器码,如as
* 连接器(linker)用于将多个目标文件链接为一个可执行文件，如ld
* 解释器(interpteter)用于在目标平台上执行可执行文件，如gdb

理解目标三元组：

* Build：表示**编译**交叉编译器的平台
* Host：表示交叉编译器将运行的平台
* Target：表示交叉编译器运行生成的可执行文件或库所针对的平台

一般交叉编译器中，Build和Host平台是相同的，三元组用信息唯一的指定了一个目标，此信息包含处理器架构，操作系统版本，C库类别，目标文件类型等。三元组格式一般情况下为 [< arch >-< sys/vendor >-< other >-< other >] (不严格规定，可能包含其中的两个，三个或者四个字段)，如 x86_64-linux-gnu 等

### rootfs

根文件系统为目标指定目标平台最小操作系统环境，包含但不局限于内核模块/库文件/配置文件/命令行工具等等。

当要编译动态三方库时，即不将库直接嵌入可执行文件中，而是在运行时加载，此时就需要使rootfs来提供环境进行测试验证

### libevent

以libevent举例，为 as-houyi-honda 的qnx平台进行交叉编译，对应的编译脚本和交叉编译工具链文件(make文件)为 [build_qnx.sh](libevent_qnx/build_qnx7.sh) 和 [build_qnx.cmake](libevent_qnx/build_qnx7.cmake)

编译时将编译脚本和工具链文件拷贝到对应的源码文件下执行编译脚本开始进行编译

其中注意：

1. cmake时会进行相应的环境检查，此时出现错误有些是可以忽略的。<font color="red">如在libevent编译时遇到cmake返回报错时犯了错误：cmake检查错误并提示可以查看对应的 CMakeFiles/CmakeError.log 文件，此时在此文件中一通查找发现各种错误，却忽略了原始的命令行输出(直接回滚查看对应错误信息并进行查询)，造成处理方向错误长时间卡顿不前</font>

2. make时候出现编译错误

```
/home/ad/Projects/as/as-houyi-third_party/libevent/libevent-release-2.1.7-rc/./arc4random.c:172:31: error: operator '&&' has no left operand
 #if EVENT__HAVE_DECL_CTL_KERN && EVENT__HAVE_DECL_KERN_RANDOM && EVENT__HAVE_DECL_RANDOM_UUID
```
即 EVENT__HAVE_DECL_CTL_KERN 为定义导致 && 符号之前无内容造成宏错误，此处出错原因时当前宏的上一句造成的，当前代码如下:

``` C++
#if defined(EVENT__HAVE_SYS_SYSCTL_H) && defined(EVENT__HAVE_SYSCTL)
#if EVENT__HAVE_DECL_CTL_KERN && EVENT__HAVE_DECL_KERN_RANDOM && EVENT__HAVE_DECL_RANDOM_UUID
#define TRY_SEED_SYSCTL_LINUX
static int
arc4_seed_sysctl_linux(void)
{
......
......
}
#endif
......
#endif
```

此处的原因时生成随机数函数时针对linux的，而非qnx的，在下面代码中有另外的通用的随机数生成函数，因此宏
```c
#if defined(EVENT__HAVE_SYS_SYSCTL_H) && defined(EVENT__HAVE_SYSCTL)
```
不该进入，或者说 EVENT__HAVE_SYSCTL 不该有效，但此处不知为何检测 sysctl函数时有效导致 EVENT__HAVE_SYSCTL 宏被定义，在此不细究原议案， 编译时直接将当前行进行修改如下:
```c
#if defined(EVENT__HAVE_SYS_SYSCTL_H) && defined(EVENT__HAVE_SYSCTL) && defined(testtest)
```
即随便定义一个不存在宏确保不会使下面linux系统特有的随机函数有效即可

3. 源文件修改

在 CMakeList.txt 中为确保宏 _QNX_SOURCE 确实有效在其中添加了
```c
add_definitions(-D_QNX_SOURCE)
```

在 signal.c 文件中添加QNX相关的信号中断
```c
// For QNX
#ifndef SA_RESTART
#define SA_RESTART 0x0040
#endif /* !SA_RESTART */
```
当前宏是用来设置信号处理函数的行为：当系统调用被信号中断之后自动重启该系统调用，而不是让系统调用返回一个错误码来表示被中断