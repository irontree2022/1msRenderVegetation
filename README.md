# 1msRenderVegetation
基于Unity，在1ms内渲染大规模植被

## 辅助课程的Unity插件获取方式
https://cloud.189.cn/t/bei6JbqQ7zYz (访问码:3vvv)

https://pan.baidu.com/s/18CAa6Di16U9_LwPZZL6LIA (提取码：qoba)

https://115.com/s/sw6porx3wfq (访问码:c523)

# 整体课程安排
## 技术验证Demo
1. 基于Job System实现GPU Instancing
2. 基于ComputeShader 实现GPU Instancing
## 基础渲染框架
1. 管理模型原型
2. 植被预处理
    - 数据存储结构、序列化以及反序列化
    - 植被数据解析
    - 空间分割
3. 实时剔除
    - 快速计算区块可见性
    - 合并可见区块
    - 视锥剔除
    - 植被 LOD
4. GPU 实例渲染
    - 处理复杂模型
    - 渲染复杂模型
## 渲染技术进阶
1. 阴影优化
2. 遮挡剔除
3. 植被碰撞检测
4. 运行时植被增删改查
5. 世界迁移
6. 图片存储植被数据
7. 超量草皮渲染
## 高性能渲染框架
1. 目标
2. 梳理渲染逻辑
    - 渲染核心
       - 数据驱动
    - 功能扩展
       - 植被碰撞检测
       - 增删改查植被数据
       - 世界迁移
3. 构建灵活的高性能渲染框架
    - 构建核心渲染器
    - 支持编辑时渲染
       - 地形植被编辑工具
    - 支持运行时扩展功能
       - 植被碰撞检测
       - 增删改查植被数据
       - 世界迁移
# 技术讨论群
QQ群：263192020

![QQ群：263192020](https://github.com/irontree2022/1msRenderVegetation/blob/main/Images/%E3%80%901ms%E5%86%85%E6%B8%B2%E6%9F%93%E5%A4%A7%E8%A7%84%E6%A8%A1%E6%A4%8D%E8%A2%AB%E3%80%91%E6%8A%80%E6%9C%AF%E8%AE%A8%E8%AE%BA%E7%BE%A4%E7%BE%A4%E8%81%8A%E4%BA%8C%E7%BB%B4%E7%A0%81.png?raw=true)


# 获得最新内容
## 微信公众号
关注微信公众号：铁树站

及时获得最新内容

![扫码_关注微信公众号_铁树站](https://github.com/irontree2022/1msRenderVegetation/blob/main/%E5%85%B3%E6%B3%A8%E5%BE%AE%E4%BF%A1%E5%85%AC%E4%BC%97%E5%8F%B7_%E9%93%81%E6%A0%91%E7%AB%99/%E6%89%AB%E7%A0%81_%E5%85%B3%E6%B3%A8%E5%BE%AE%E4%BF%A1%E5%85%AC%E4%BC%97%E5%8F%B7_%E9%93%81%E6%A0%91%E7%AB%99.png?raw=true)

## 哔哩哔哩
该课程的图文文章和视频同步更新，视频观看地址可在 [https://space.bilibili.com/409009139](https://space.bilibili.com/409009139)

## Youtube
[https://www.youtube.com/playlist?list=PLA5WGod9c3SrYzhOECmZatFYSqAEbIVY1](https://www.youtube.com/playlist?list=PLA5WGod9c3SrYzhOECmZatFYSqAEbIVY1)

## Unity中文课堂
目前课程已在Unity中文课堂上上架，可以在 [https://learn.u3d.cn/tutorial/1ms-render-vegetation](https://learn.u3d.cn/tutorial/1ms-render-vegetation) 购买学习。

# 联系我
irontree2022@163.com

# 疑难杂症汇总
## HDRP 复刻时 shader 修改后报错
![HDRP 复刻时 shader修改后报错.png](https://github.com/irontree2022/1msRenderVegetation/blob/main/Images/HDRP%20%E5%A4%8D%E5%88%BB%E6%97%B6%20shader%E4%BF%AE%E6%94%B9%E5%90%8E%E6%8A%A5%E9%94%99.png?raw=true)

我查了这个问题是因为HDRP在 Packages/com.unity.render-pipelines.high-definition/Runtime/ShaderLibrary/ShaderVariables.hlsl 中 将 unity_ObjectToWorld  和 unity_WorldToObject 重定义为：

// To get instancing working, we must use UNITY_MATRIX_M / UNITY_MATRIX_I_M as UnityInstancing.hlsl redefine them
#define unity_ObjectToWorld Use_Macro_UNITY_MATRIX_M_instead_of_unity_ObjectToWorld
#define unity_WorldToObject Use_Macro_UNITY_MATRIX_I_M_instead_of_unity_WorldToObject

你可以在GPUInstancing_indirect.cginc中的setup()上面添加两行：

//...//

#define unity_ObjectToWorld unity_ObjectToWorld

#define unity_WorldToObject unity_WorldToObject

// setup函数作用是给每个实例数据在渲染前得到实际矩阵和逆矩阵，相当于每个实例数据的初始化操作。

void setup()

// ... //


这两行：

#define unity_ObjectToWorld unity_ObjectToWorld

#define unity_WorldToObject unity_WorldToObject

是将那两个变量用宏重新定义回来

我通过 https://forum.unity.com/threads/problem-with-drawmeshinstance-with-hdrp-or-lwrp.646723/ 这里面找的解决办法。

刚才试了ok，运行能够正常渲染出来。你可以试试看

## Linux Vulkan ComputeShader报错
![Linux Vulkan ComputeShader报错.png](https://github.com/irontree2022/1msRenderVegetation/blob/main/Images/Linux%20Vulkan%20ComputeShader%E6%8A%A5%E9%94%99.png?raw=true)
你说得：Shader error in 'FrustumCulling': glslang: 'input' : Reserved word. at kernel FrustumCulling at line 31 (on vulkan) 你看，它提示说input是保留字，你把这个input属性名改成inputDatas 之类得名称，然后在C#代码里面原来给 input 赋值的地方改成给 inputDatas赋值，我想这样就可以解决了.

## 找不到float3的定义
![找不到float3的定义.png](https://github.com/irontree2022/1msRenderVegetation/blob/main/Images/%E6%89%BE%E4%B8%8D%E5%88%B0float3%E7%9A%84%E5%AE%9A%E4%B9%89.png?raw=true)
C# 中使用的 float3 不是Unity 常见的结构体，是项目添加的包：Mathematics，使用这个包里面的数学相关的结构体。

