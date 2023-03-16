clear;close all;clc;

addpath('data')
load("out2_2d.mat")

array_start_time = 0:0.5:9.5;
array_sample_shift = 0:1:5;
array_Doppler_frequency = -40:2:40;

band = 1;
if band==1
    f_ddc = -3e6;
    bandwidth = 9e6;
elseif band==2
    f_ddc = 9.5e6;
    bandwidth = 2e6;
end

f_c = 2.1230e9;
f_s = 25e6;
lambda = 3e8/f_c;
array_range = array_sample_shift/f_s*3e8;
%array_Doppler_frequency和array_range分别是图像的x和y轴

%设置输出的下限
thres_A_TRD = -10;
A_TRD = zeros(length(array_start_time),length(array_sample_shift),length(array_Doppler_frequency));


%meshgrid_Doppler,meshgrid_range分别是7*41矩阵
[meshgrid_Doppler,meshgrid_range] = meshgrid(array_Doppler_frequency,[array_range,2*array_range(end)-array_range(end-1)]);

%先考察第1/20段
idx_start_time = 5;

fprintf('Index of start time: 1. \n')
    
fprintf('Read data file. \n')
load('data/data_1.mat')
    
fprintf('Downconvert. \n')
%设计变频器
seq_ref_ddc = seq_ref.*exp(-1i*2*pi*f_ddc*[0:duration*f_s-1]/f_s);
seq_sur_ddc = seq_sur.*exp(-1i*2*pi*f_ddc*[0:duration*f_s-1]/f_s);

%设计低通滤波器
fprintf('LPF.\n')

f_cutoff = bandwidth;
[b,a] = butter(20,f_cutoff/(f_s/2));
seq_ref_lpf = filter(b,a,seq_ref_ddc);%处理之后的参考信号
seq_sur_lpf = filter(b,a,seq_sur_ddc);%处理之后的监测信号

%[out_2d,c_argmax,d_argmax]=cor_arg(seq_sur_lpf,seq_ref_lpf,2);

%out_final = abs(squeeze(A_TRD(idx_start_time,:,:)));
out_final = out_2d/max(max(out_2d));
out_final=abs(out_final);
out_final = 20*log10(out_final);%对原函数作分贝变换

%设置输出的下限,去除小于-10的值
out_final(out_final<thres_A_TRD) = thres_A_TRD;

%out_final = [out_final;thres_A_TRD*ones(1,size(out_final,2))];

%surf(meshgrid_Doppler,meshgrid_range,out_final)%画出三维函数
imagesc(array_Doppler_frequency,array_range,out_final);

view(0,90)
colorbar;

    xlabel('Doppler frequency (Hz)')
    ylabel('Range (m)')