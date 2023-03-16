%Plot RD Spectrum

addpath('data')

array_start_time = 0:0.5:9.5;

%
array_sample_shift = 0:5;
array_Doppler_frequency = -40:2:40;


band = 1;
f_c = 2.1230e9;
f_s = 25e6;
lambda = 3e8/f_c;

array_range = array_sample_shift/f_s*3e8;

[meshgrid_Doppler,meshgrid_range] = meshgrid(array_Doppler_frequency,[array_range,array_range(end)+duration]);

idx_max_range = zeros(1,length(array_start_time))-1;
idx_max_Doppler_frequency = zeros(1,length(array_start_time));

for idx_start_time = [1,5,11,15]

    n=1;

    fprintf('[stat] Index of start time: %d. \n', idx_start_time)
    
    fprintf('[stat] Read data file. \n')
    load(sprintf('data/data_%d.mat', idx_start_time))
    
    fprintf('[stat] Downconvert. \n')
    %设计变频器
    seq_ref_ddc = seq_ref.*exp(-1i*2*pi*f_ddc*[0:duration*f_s-1]/f_s);
    seq_sur_ddc = seq_sur.*exp(-1i*2*pi*f_ddc*[0:duration*f_s-1]/f_s);

    fprintf('[stat] LPF.\n')
    %设计低通滤波器
    [b,a] = butter(20,f_cutoff/(f_s/2));
    seq_ref_lpf = filter(b,a,seq_ref_ddc);%处理之后的参考信号
    seq_sur_lpf = filter(b,a,seq_sur_ddc);%处理之后的监测信号


    plot_A_RD = abs(squeeze(A_TRD(idx_start_time,:,:)));
    plot_A_RD = plot_A_RD/max(max(plot_A_RD));
    plot_A_RD = 20*log10(plot_A_RD);%对原函数作分贝变换
    plot_A_RD(plot_A_RD<thres_A_TRD) = thres_A_TRD;

    plot_A_RD = [plot_A_RD;thres_A_TRD*ones(1,size(plot_A_RD,2))];

    
    surf(meshgrid_Doppler,meshgrid_range,plot_A_RD)%画出三维函数

    view(0,90)
    colorbar

    xlim([array_Doppler_frequency(1),array_Doppler_frequency(end)])
    ylim([array_range(1),2*array_range(end)-array_range(end-1)])

    xticks(array_Doppler_frequency(1):20:array_Doppler_frequency(end))
    yticks([array_range,2*array_range(end)-array_range(end-1)])

    xlabel('Doppler frequency (Hz)')
    ylabel('Range (m)')

    [idx_max_range(idx_start_time),idx_max_Doppler_frequency(idx_start_time)] = find(plot_A_RD==max(max(plot_A_RD)));
    
    %temp = sprintf('Range-Doppler Spectrum [%4.1fs: %3.0fm %3.0fHz]',array_start_time(idx_start_time),array_range(idx_max_range(idx_start_time)), array_Doppler_frequency(idx_max_Doppler_frequency(idx_start_time)));
    %title(temp)

    
end



