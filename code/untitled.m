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