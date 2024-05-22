
    use=(-1000:1000);
    adjust=hrobject.hr.samples_per_second*hrobject.hr.spectrogram.fft_window_seconds/2;
avHRV=0;
for i=1:length(hrobject.events) 
    avHRV=avHRV+hrobject.hr.spectrogram.bands(1,round(hrobject.events(i)*hrobject.hr.samples_per_second)+use-adjust);
end

plot(use/hrobject.hr.samples_per_second,avHRV,'linewidth',2)
ylabel('HRV')
xlabel("time (secs)")
