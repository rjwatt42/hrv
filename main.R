
source("https://github.com/rjwatt42/hrv/raw/main/hr_start.R")

h<-hr_load_acq_txt('Participant1 Recording.txt')
s<-hr_load_event_txt('Participant1 Script.txt')
hrobject<-hr_eventProcess(h,s)

hrobject<-hr_spectrogram(hrobject)

hr_plot_hr(hrobject)
hr_plot_hrv(hrobject)
hr_plot_events(hrobject)


