function hr_plot_hr(hrobject)


plot(hrobject.hr.hr_time,hrobject.hr.hr_signal,'k-')
hold on
for i=1:length(hrobject.stimuli) 
    line([0 0]+hrobject.stimuli(i),get(gca,'ylim'),'color','k');
end
for i=1:length(hrobject.eventTimes) 
    line([0 0]+hrobject.eventTimes(i),get(gca,'ylim'),'color','r');
end
hold off
ylabel('HR (bpm)')
xlabel("time (secs)")