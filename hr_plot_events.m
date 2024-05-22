function hr_plot_events(hrobject)

% the window around each event to plot
window=[-0.5 1]*4; % seconds
window=window*hrobject.hr.samples_per_second;
use=window(1):window(2);

% we can adjust the position of th eplot to tak einto account the hamming
% window
    adjust=hrobject.hr.samples_per_second*hrobject.hr.spectrogram.fft_window_seconds/2;
    % but better not to
    adjust=0;

% pad out the spectrogram to provide enough window for an event right at
% the end
    hrobject.hr.spectrogram.bands=[hrobject.hr.spectrogram.bands NaN(2,window(2))];

% now plot the individual events
    ymean=0;
    for i=1:length(hrobject.eventList)
        x=use/hrobject.hr.samples_per_second;
        y=hrobject.hr.spectrogram.bands(1,round(hrobject.eventTimes(i)*hrobject.hr.samples_per_second)+use-adjust);
        ymean=ymean+y;
        plot(x,y)
        hold on
    end
% plot the average response
    plot(x,ymean/length(hrobject.eventList),'k-',linewidth=2)
    hold off

ylabel('HRV')
xlabel("time (secs)")
legend([hrobject.eventList, "All"],'Location','northeastoutside')

