

h<-hr_load_acq_txt('Participant1 Recording.txt')
s<-hr_load_event_txt('Participant1 Script.txt')
hrobject<-hr_eventProcess(h,s)

hrobject<-hr_spectrogram(hrobject)

hr_plot_hr(hrobject)
hr_plot_hrv(hrobject)
hr_plot_events(hrobject)

##################
#

hr_data<-hr_collect_data("Data")
hr_show_data(hr_data,typeShow="stimuli",whichShow="All")
hr_show_data(hr_data,typeShow="events",whichShow="All")

hr_write_results(hr_data,"results.csv")
