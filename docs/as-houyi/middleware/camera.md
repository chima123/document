# Camera

捷达板子上尝试Android NDK Camera C++获取图像

## 前期工作

1. adb 连接到捷达板子并修改相应权限

```
adb connect 172.25.192.122:5555
# 修改adb root权限
adb root
# 挂在文件系统为可读写模式
adb remount
# adb替换为主用户
adb shell am switch-user 0
# adb查看当前用户
adb shell am get-current-user
```

* 查看android相关log可以采用 logcat 命令来查看
```
    logcat --pid=$(pidof -s camera_test)
```

* scrcpy来获取android界面，可以直接在界面上进行一定的操作

* 可以修改 **SELinux** 模式

```
    # 设置为宽容模式：违反安全策略后不会阻止行为，只是记录
    adb shell setenforce 0
    # 查看当前模式
    getenforce
```

2. 开发内容

* 修改modules/drivers/dcamera_wrapper/DCameraTool,其中调用标准Android NDK接口来获取图像(除了获取图像外发之外还要包含图像编解码相关)
* 修改现在的相关测试以及使用外围 pylon/camera/android/android_camera 实体调用DCameraTool来进行相关测试
* 

3. 工作时便利命令简单记录

* 编译 camera_test命令
```shell
# 编译camera_test来上板端测试摄像头获取图像信息
bash hy_build.sh --os android --src ni --modules=//modules/drivers/dcamera_wrapper:camera_test

# 将编译结果adb push到板端进行测试
adb push .cache/_bazel_ad/540135163923dd7d5820f3ee4b306b32/execroot/apollo/bazel-out/arm64-v8a-fastbuild/bin/modules/drivers/dcamera_wrapper/camera_test /data/apollo

# 对 调用dcamera_wrapper的下游pylon/camera 进行编译
bash hy_build.sh --os android --src ni --modules=//pylon/example/android_camera_example:android_camera

# 将pylon/camera(android)push到板端进行测试
adb push .cache/_bazel_ad/540135163923dd7d5820f3ee4b306b32/execroot/apollo/bazel-out/arm64-v8a-fastbuild/bin/pylon/example/android_camera_example/android_camera /data/apollo
```

## Android NDK Camera2


1. 获取图像  

    捷达8155板子camera接口为标准Android NDK Camera2接口，需求为从标准接口中获取YUV_420_888(YUV420SP/NV21)图像，通过AImageReader_ImageListener回调对外发出；
获取摄像头图像相关内容可以参考 [参考链接](https://www.cnblogs.com/qi-xmu/p/17287888.html)
对应实现是在 modules/drivers/dcamera_wrapper 下

    开发过程中还需要注意：
    * 单纯的NDK C++代码在代码完成之后可能依旧获取不到对应的图像信息：通过函数 AImageReader_setImageListener 设置的回调可能没有被调用，回调函数内部图像处理也没有被出发。原因是 [纯NDK开发中没有启动binder通信](https://stackoverflow.com/questions/52710811/android-camera2-executable-failed-to-get-frames)，因此需要在AOSP中编译一个启动binder的so(as-houyi-j01 repo中只包含对应NDK，不包含AOSP进行编译)来供dcamera_wrapper中调用。


2. YUV图像格式理解

    申请的image格式为 **AIMAGE_FORMAT_YUV_420_888** ,获取的AImage中默认有三个Plane，分别对应的是YUV，但是通过查询三个plane的buff首地址可以看到其image buffer对应的存储格式为NV21(Android默认格式)，NV21存储顺序是先存Y值，再VU交替存储：YYYYVUVUVU，或者叫YUV420SP。

    [图像格式参考](https://www.cnblogs.com/vaughnhuang/articles/16043168.html)

3. H264编解码

    除了获取图像外(现在捷达板子上获取的是四个环视摄像头合一图像/一行四列)，dcamera_wrapper还负责图像的编解码，方便原始图像采集回灌。编解码依旧采用标准 AMediaCodec 进行，相关代码见 dcamera_wrapper

    [参考链接](https://blog.csdn.net/hello_1995/article/details/122091747)