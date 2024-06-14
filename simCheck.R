
hr_time<-seq(0,60,0.01)
hr_signal<-(hr_time>30)*10+60

hrsimobject<-list(hr=list(hr_time=hr_time,
                       hr_signal=hr_signal))


hrsimobject<-hr_spectrogram(hrsimobject)

hr_plot_hrv(hrsimobject)

