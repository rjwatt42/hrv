
library(ggplot2)
library(grDevices)
library(gsignal)


h<-hr_load_acq_txt('Participant1 Recording.txt')
s<-hr_load_event_txt('Participant1 Script.txt')

h<-hr_spectrogram(h)
h<-hr_eventProcess(h,s)

hr_plot_hr(h)
hr_plot_hrv(h)
hr_plot_events(h)


