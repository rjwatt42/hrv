

hr_time<-seq(0,5*60,1) # seconds
hr_signal<-(cos(hr_time/5)*2+cos(hr_time/20)*5+70)
demo<-list(hr=list(hr_time=hr_time,hr_signal=hr_signal))
hr_plot_hr(demo,offset=0)

