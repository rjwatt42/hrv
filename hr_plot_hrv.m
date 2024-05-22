function hr_plot_hrv(hrobject)

plot(hrobject.hr.spectrogram.spectrogram_times,hrobject.hr.spectrogram.bands(1,:),'linewidth',2)
hold on
for i=1:length(hrobject.stimuli) 
    line([0 0]+hrobject.stimuli(i),get(gca,'ylim'),'color','k');
end
for i=1:length(hrobject.eventTimes) 
    line([0 0]+hrobject.eventTimes(i),get(gca,'ylim'),'color','r');
end
hold off
ylabel('HRV')
xlabel("time (secs)")
