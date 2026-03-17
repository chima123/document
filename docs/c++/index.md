# c++ 相关文档

## 查看候杰视频中一些记录

### C++11&14

包含**语言** 和 **标准库** 两部分

1. variadic template 可变参数模板

支持接收任意数量，任意类型模板参数的模板，解决了之前只能接收固定数量，固定类型模板参数的限制。是泛型编程的基础。

```cpp
template <typename... Args>
sizeof...(Args)

// 示例
void print(){
}
template <typename T, typename... Args>
void print(const T& first, const Args&... args){
    std::cout << first << std::endl; // print first argument
    print(args...); // print remaining arguments
}
```

    * 核心是参数包和**...**展开符
    * 参数包需要通过递归展开

2. nullptr and std::nullptr_t

```
// 可能存在歧义，如下面输入一个地址数字表示地址时
void f(int);
void f(void*);
```

3. auto 类型推导
4. uniform initialization 统一初始化

c++11引入的核心语法特性，通过**{}** 统一初始化对象，如
```cpp
int a = {10};
std::vector<int> v = {1, 2, 3, 4, 5};
```

安全特性：禁止窄化转换，如
```
int a = {10.0}; // 编译报错
```

数组/结构/类初始化
