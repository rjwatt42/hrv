


plot(hrobject.hr.hr_time,hrobject.hr.hr_signal,'k-')
hold on
for i=1:length(hrobject.events) 
    line([0 0]+hrobject.events(i),get(gca,'ylim'),'color','r');
end
hold off
ylabel('HR (bpm)')
xlabel("time (secs)")