

plot(hrobject.hr.spectrogram.spectrogram_times,hrobject.hr.spectrogram.bands(1,:),'linewidth',2)
hold on
for i=1:length(hrobject.events) 
    line([0 0]+hrobject.events(i),get(gca,'ylim'),'color','r');
end
hold off
ylabel('HRV')
xlabel("time (secs)")
