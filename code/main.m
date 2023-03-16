clear;close all;clc;

addpath('data')

array_start_time = 0:0.5:9.5;
array_sample_shift = 0:1:5;
array_Doppler_frequency = -40:2:40;
band = 1;
f_c = 2.1230e9;
f_s = 25e6;
lambda = 3e8/f_c;
array_range = array_sample_shift/f_s*3e8;

if band==1
    f_ddc = -3e6;
    bandwidth = 9e6;
elseif band==2
    f_ddc = 9.5e6;
    bandwidth = 2e6;
end

f_cutoff = bandwidth;
thres_A_TRD = -10;
A_TRD = zeros(length(array_start_time),length(array_sample_shift),length(array_Doppler_frequency));

for idx_start_time = 1:length(array_start_time)
    fprintf('[stat] Index of start time: %d / %d. \n', idx_start_time, length(array_start_time))
    
    fprintf('[stat] Read data file. \n')
    load(sprintf('data/data_%d.mat', idx_start_time))
    
    fprintf('[stat] Downconvert. \n')
    %设计变频器
    seq_ref_ddc = seq_ref.*exp(-1i*2*pi*f_ddc*[0:duration*f_s-1]/f_s);
    seq_sur_ddc = seq_sur.*exp(-1i*2*pi*f_ddc*[0:duration*f_s-1]/f_s);

    fprintf('[stat] LPF.\n')
    %设计低通滤波器
    [b,a] = butter(20,f_cutoff/(f_s/2));
    seq_ref_lpf = filter(b,a,seq_ref_ddc);
    seq_sur_lpf = filter(b,a,seq_sur_ddc);




    

    duration_plot = 0.01;
    num_t_axis_plot = duration_plot*f_s;
    num_f_axis_plot = num_t_axis_plot;
    t_axis_plot = 0:1/f_s:duration_plot-1/f_s;
    f_axis_plot = -f_s/2:f_s/(num_f_axis_plot-1):f_s/2;
     
    if idx_start_time == 1

        %参考信号
        figure(1);

        subplot(3,2,1)
            plot(t_axis_plot*1e3,real(seq_ref(1,1:num_t_axis_plot)))
            xlabel('Time(ms)')
            ylabel('Amplitude')
            axis([0,duration_plot*1e3,-0.5e-3,0.5e-3])
            title('参考信号的原始信号的时域波形')

        subplot(3,2,2)
            plot(f_axis_plot/1e6,20*log10(abs(fftshift(fft(seq_ref(1,1:num_t_axis_plot),num_f_axis_plot)))))
            xlabel('Frequency(MHz)')
            ylabel('Amplitude(dB)')
            axis([-f_s/2/1e6,f_s/2/1e6,-100,0])
            title('参考信号的原始信号的频谱')

        subplot(3,2,3)
            plot(t_axis_plot*1e3,real(seq_ref_ddc(1,1:num_t_axis_plot)))
            xlabel('Time(ms)')
            ylabel('Amplitude')
            axis([0,duration_plot*1e3,-0.5e-3,0.5e-3])
            title('参考信号的变频后信号的时域波形')

        subplot(3,2,4)
            plot(f_axis_plot/1e6,20*log10(abs(fftshift(fft(seq_ref_ddc(1,1:num_t_axis_plot),num_f_axis_plot)))))
            xlabel('Frequency(MHz)')
            ylabel('Amplitude(dB)')
            axis([-f_s/2/1e6,f_s/2/1e6,-100,0])
            title('参考信号的变频后信号的频谱')

         subplot(3,2,5)
            plot(t_axis_plot*1e3,real(seq_ref_lpf(1,1:num_t_axis_plot)))
            xlabel('Time(ms)')
            ylabel('Amplitude')
            axis([0,duration_plot*1e3,-0.5e-3,0.5e-3])
            title('参考信号的低通滤波后信号的时域波形')

         subplot(3,2,6)
            plot(f_axis_plot/1e6,20*log10(abs(fftshift(fft(seq_ref_lpf(1,1:num_t_axis_plot),num_f_axis_plot)))))
            xlabel('Frequency(MHz)')
            ylabel('Amplitude(dB)')
            axis([-f_s/2/1e6,f_s/2/1e6,-100,0])
            title('参考信号的低通滤波后信号的频谱')

         %检测信号
         figure(2);

         subplot(3,2,1)
            plot(t_axis_plot*1e3,real(seq_sur(1,1:num_t_axis_plot)))
            xlabel('Time(ms)')
            ylabel('Amplitude')
            axis([0,duration_plot*1e3,-2e-3,2e-3])
            title('监测信号的原始信号的时域波形')

         subplot(3,2,2)
            plot(f_axis_plot/1e6,20*log10(abs(fftshift(fft(seq_sur(1,1:num_t_axis_plot),num_f_axis_plot)))))
            xlabel('Frequency(MHz)')
            ylabel('Amplitude(dB)')
            axis([-f_s/2/1e6,f_s/2/1e6,-100,0])
            title('监测信号的原始信号的频谱')

         subplot(3,2,3)
            plot(t_axis_plot*1e3,real(seq_sur_ddc(1,1:num_t_axis_plot)))
            xlabel('Time(ms)')
            ylabel('Amplitude')
            axis([0,duration_plot*1e3,-2e-3,2e-3])
            title('监测信号的变频后信号的时域波形')

         subplot(3,2,4)
            plot(f_axis_plot/1e6,20*log10(abs(fftshift(fft(seq_sur_ddc(1,1:num_t_axis_plot),num_f_axis_plot)))))
            xlabel('Frequency(MHz)')
            ylabel('Amplitude(dB)')
            axis([-f_s/2/1e6,f_s/2/1e6,-100,0])
            title('监测信号的变频后信号的频谱')

         subplot(3,2,5)
            plot(t_axis_plot*1e3,real(seq_sur_lpf(1,1:num_t_axis_plot)))
            xlabel('Time(ms)')
            ylabel('Amplitude')
            axis([0,duration_plot*1e3,-2e-3,2e-3])
            title('监测信号的低通滤波后信号的时域波形')

         subplot(3,2,6)
            plot(f_axis_plot/1e6,20*log10(abs(fftshift(fft(seq_sur_lpf(1,1:num_t_axis_plot),num_f_axis_plot)))))
            xlabel('Frequency(MHz)')
            ylabel('Amplitude(dB)')
            axis([-f_s/2/1e6,f_s/2/1e6,-100,0])
            title('监测信号的低通滤波后信号的频谱')
    end
    
end



