# Camera

捷达板子上尝试Android NDK Camera C++获取图像

## 前期工作

1. adb 连接到捷达板子上

```
adb connect 172.25.192.122:5555
```

2. 更改板端权限之后才可以OpenCamera成功

```
# 修改adb root权限
adb root
# 挂在文件系统为可读写模式
adb remount
# adb替换为主用户
adb shell am switch-user 0
# adb查看当前用户
adb shell am get-current-user
```

## 其他工具

* 查看android相关log可以采用logcat命令来查看
```
logcat --pid=$(pidof -s camera_test)
```

* scrcpy来获取android界面，可以直接在界面上进行一定的操作

* 可以修改 **SELinux** 模式

```
    # 设置为宽容模式，违反安全策略后不会阻止行为，只是记录
    adb shell setenforce 0
    # 查看当前模式
    getenforce
```

## 开发内容

1. 测试NDKCamera在板子上可以获取图像
2. 修改modules/drivers/dcamera_wrapper/DCameraTool,其中调用那个NDKCamera来获取图像
    这个需要重构。。。
    包含图像获取，编解码等
3. 用pylon/camera/android/android_camera 实体调用DCameraTool
    理论上不需要修改android_camera，只要重写DCameraTool就可以
    可以在pylon/example/android_camera_example 测试一下android_camera是否OK

4. 进一步测试可以使用 pylon/example/camera_component_test
5. 再进一步测试可以使用  pylon/mainboard 来测试，跟上 pylon/example/dag/camera_all.dag 跑一下

## 工作时便利命令简单记录

### 编译 camera_test命令
bash hy_build.sh --os android --src ni --modules=//modules/drivers/dcamera_wrapper:camera_test

adb push .cache/_bazel_ad/540135163923dd7d5820f3ee4b306b32/execroot/apollo/bazel-out/arm64-v8a-fastbuild/bin/modules/drivers/dcamera_wrapper/camera_test /data/apollo

### 编译 android_camera命令
bash hy_build.sh --os android --src ni --modules=//pylon/example/android_camera_example:android_camera

adb push .cache/_bazel_ad/540135163923dd7d5820f3ee4b306b32/execroot/apollo/bazel-out/arm64-v8a-fastbuild/bin/pylon/example/android_camera_example/android_camera /data/apollo


