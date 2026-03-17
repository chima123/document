# XD期间相关文档

## BMW匹配服务工具链自动化

### 1. 操作流程

#### * OD的批量获取

华为云上导航组通过kafka吐出相应轨迹信息，张京将其接收并存储

#### * 通过OD获取高德上的轨迹信息，赵萌正在开发

    * 过滤OD信息，只保留TOP50城（有对应的cities_list.txt文件）
    * 调用高德API将OD变换为轨迹json文件（按照城市存储在对应的城市名称文件夹中）

#### * 调用BMW的docker，输入轨迹信息，docker内部调用匹配服务（调用四维地图），返回匹配结果

docker内部启动脚本：run-all.sh，输入轨迹json文件路径 and 地图文件，输出匹配结果
（bmw-result-all文件夹中对应的信息）


#### * 匹配结果统计

现在是同样物理机器上JAVA环境中进行统计，python汇总，最终获取docker输出的匹配结果和统计汇总表格

### 2. 验证

查询sample下文件目录
``` bash

navinfo@navinfo:~/XD/FM-M3-0310$ du -h --max-depth=1

8.6K  Getxy.py
8.4G  PRODUCT/
 80K  ROOT.NDS        TODO 这个不像是输入地图文件，需要确定
272K  SAM25_HAD_CN.PKG
 619  SAM25_HAD_CN.SIG
42G   amap-route-json-all/      获取的高德轨迹json文件夹
109G  bmw-result-all/           docker跑出的匹配结果文件夹
 446  cities_list.txt
1.4K  copy_csv.py
1.3K  copy_json.py
2.6K  copy_with_rename.sh*
6.9K  excel.py
6.8G  live.log                  docker运行时生成的日志文件
26G   navinfo/
20M   output/
2.3K  output_csv.py
203M  outputcsv/
5.0K  renamejson.py
1.1K  run-all.sh

```
