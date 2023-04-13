# Motion-detection-via-communication-signal
SUSTech EE205 Signal and System

## 无线信号传播
![README_page-0002](https://user-images.githubusercontent.com/117464811/231815584-f43b73a6-b915-454d-bb8c-8cebe5bd5438.jpg)

## 主动雷达vs被动雷达
![README_page-0003](https://user-images.githubusercontent.com/117464811/231815715-5cd9f7f3-d497-4efd-a802-36deaf4cdd5c.jpg)

### 被动雷达基本原理
![README_page-0004](https://user-images.githubusercontent.com/117464811/231815823-f22d53da-8056-4c90-aef7-97ae9f335399.jpg)
![README_page-0005](https://user-images.githubusercontent.com/117464811/231815969-53a52e8a-8485-4c92-92d0-bd294469f3a6.jpg)

## 实验场景
![README_page-0006](https://user-images.githubusercontent.com/117464811/231816112-dee1bd0c-2ff8-42dd-b4fe-e615620c4f6b.jpg)

## 信号处理流程
![README_page-0007](https://user-images.githubusercontent.com/117464811/231816220-59bdc18b-4647-4bc6-85a5-e957cb063f71.jpg)

### 滤波
![README_page-0008](https://user-images.githubusercontent.com/117464811/231816325-211a0dc6-c95f-421b-a025-c43056832e21.jpg)

### 模糊函数
![README_page-0009](https://user-images.githubusercontent.com/117464811/231816779-a79c26fc-be42-455b-8616-7c73586f65d9.jpg)

## mat数据文件
20个 data_x.mat 分别对应 0-0.5s 0.5-1s 9.5-10s 的数据。

使用load('data_x.mat') 读取后，seq_ref和 seq_sur 分别为该 0.5s 的参考信号和监测信号得采样点；cut_time对应开始 采样 时刻， duration=0.5sf_c和 f_s 分别为载波频率和采样频率。

遍历的多普勒频移可取[40:2:40] Hz ，时延的采样点个数可取 [0:6]。

## 作业提交
![README_page-0011](https://user-images.githubusercontent.com/117464811/231816704-5630eccb-94e8-4a7d-b92e-38983369768e.jpg)
