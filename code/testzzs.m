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
A_TRD = zeros(length(array_start_time),length(array_sample_shift),length(array_Doppler_frequency));%20 6 41

for idx_start_time = [1,5,11,15] %1:length(array_start_time)
    %idx_start_time = 1;
    fprintf('Index of start time: %d / %d. \n', idx_start_time, length(array_start_time))

    fprintf('Read data file. \n')
    load(sprintf('data/data_%d.mat', idx_start_time))
    
    fprintf('Downconvert. \n')
    seq_ref_ddc = seq_ref.*exp(-1i*2*pi*f_ddc*[0:duration*f_s-1]/f_s);
    seq_sur_ddc = seq_sur.*exp(-1i*2*pi*f_ddc*[0:duration*f_s-1]/f_s);

    fprintf('LPF.\n')
    [b,a] = butter(20,f_cutoff/(f_s/2));
    seq_ref_lpf = filter(b,a,seq_ref_ddc);
    seq_sur_lpf = filter(b,a,seq_sur_ddc);

    duration_plot = 0.01;
    num_t_axis_plot = duration_plot*f_s;
    num_f_axis_plot = num_t_axis_plot;
    t_axis_plot = 0:1/f_s:duration_plot-1/f_s;
    f_axis_plot = -f_s/2:f_s/(num_f_axis_plot-1):f_s/2;
   

%%  Ambiguity function
    fprintf('Ambiguity processing. \n')

    cor_n=zeros(length(array_sample_shift),length(array_Doppler_frequency));
%     for t=1:length(array_start_time)
% %         seq_zeros=[seq_sur_lpf(array_sample_shift(t)+1:end),zeros(1,array_sample_shift(t))];
% %         ref_=seq_ref_lpf;
% %         cor_n(t,:)=fftshift(fft(seq_zeros.*conj(ref_)));
%         A_TRD(t,:,:)=cor(seq_sur_lpf,seq_ref_lpf);
%     end
% %     A_TRD=cor_n(:,1:41);
    A_TRD(1,:,:)=cor(seq_sur_lpf,seq_ref_lpf,0);

end


%% Plot RD Spectrum
idx_max_range = zeros(1,length(array_start_time))-1;
idx_max_Doppler_frequency = zeros(1,length(array_start_time));
for idx_start_time = [1,5,11,15] %1:length(array_start_time)
    %idx_start_time = 1;
    fig2 = figure(2);
    ScreenSize = get(0,'ScreenSize');
    set(fig2,'Position',[0.75*ScreenSize(3)+50,0.5*ScreenSize(4)+50,0.25*ScreenSize(3)-100,0.5*ScreenSize(4)-150]);
    [meshgrid_Doppler,meshgrid_range] = ...
        meshgrid(array_Doppler_frequency,[array_range,2*array_range(end)-array_range(end-1)]);
    plot_A_RD = abs(squeeze(A_TRD(idx_start_time,:,:)));
    plot_A_RD = plot_A_RD/max(max(plot_A_RD));
    plot_A_RD = 20*log10(plot_A_RD);
    plot_A_RD(plot_A_RD<thres_A_TRD) = thres_A_TRD;
    plot_A_RD = [plot_A_RD;thres_A_TRD*ones(1,size(plot_A_RD,2))];
    surf(meshgrid_Doppler,meshgrid_range,plot_A_RD)
    view(0,90)
    colorbar

    xlim([array_Doppler_frequency(1),array_Doppler_frequency(end)])
    ylim([array_range(1),2*array_range(end)-array_range(end-1)])

    xticks([array_Doppler_frequency(1):20:array_Doppler_frequency(end)])
    yticks([array_range,2*array_range(end)-array_range(end-1)])

    xlabel('Doppler frequency (Hz)')
    ylabel('Range (m)')

    [idx_max_range(idx_start_time),idx_max_Doppler_frequency(idx_start_time)] = find(plot_A_RD==max(max(plot_A_RD)));

    temp = sprintf('Range-Doppler Spectrum [%4.1fs: %3.0fm %3.0fHz]', ...
        array_start_time(idx_start_time), ...
        array_range(idx_max_range(idx_start_time)), ...
        array_Doppler_frequency(idx_max_Doppler_frequency(idx_start_time)));
    title(temp)
end

% %% Plot TD Spectrum
% fig3 = figure(3);
% ScreenSize = get(0,'ScreenSize');
% set(fig3,'Position',[0.5*ScreenSize(3)+50,50,0.25*ScreenSize(3)-100,0.5*ScreenSize(4)-150]);
% [meshgrid_Doppler,meshgrid_start_time] = ...
%     meshgrid(array_Doppler_frequency,[array_start_time,array_start_time(end)+duration]);
% plot_A_TD = zeros(length(array_start_time),length(array_Doppler_frequency));
% for idx_start_time = 1:length(array_start_time)
%     plot_A_TD(idx_start_time,:) = abs(squeeze(A_TRD(idx_start_time,idx_max_range(idx_start_time),:)));
% end
% plot_A_TD = plot_A_TD./max(plot_A_TD,[],2);
% plot_A_TD = 20*log10(plot_A_TD);
% plot_A_TD(plot_A_TD<thres_A_TRD) = thres_A_TRD;
% plot_A_TD = [plot_A_TD;thres_A_TRD*ones(1,size(plot_A_TD,2))];
% surf(meshgrid_Doppler,meshgrid_start_time,plot_A_TD)
% view(0,90)
% colorbar
% xlim([array_Doppler_frequency(1),array_Doppler_frequency(end)])
% ylim([array_start_time(1),array_start_time(end)])
% xticks([array_Doppler_frequency(1):20:array_Doppler_frequency(end)])
% yticks([array_start_time(1):0.5:array_start_time(end)+duration])
% xlabel('Doppler frequency (Hz)')
% ylabel('Time (s)')
% title('Time-Doppler Spectrum')


