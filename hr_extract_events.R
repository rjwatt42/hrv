hr_extract_events=function(hrobject,window=c(-4, 8)
                        ) {

# window: the window around each event is seconds

samples_per_second<-1/diff(hrobject$hr$hr_time[1:2])

window=window*samples_per_second
useTimes<-window[1]:window[2]
offsetTimes<-window[1]:0

# we can adjust the position of the plot to take into account the hamming
# window
adjust<-samples_per_second*hrobject$spectrogram$fft_window_seconds/2
# but better not to
adjust<-0

# pad out the spectrogram to provide enough window for an event right at
# the end
hrobject$spectrogram$bands<-cbind(hrobject$spectrogram$bands, matrix(NA,2,window[2]))

ymean<-0
eventsHRV<-matrix(0,length(hrobject$eventList),length(useTimes))
for (iEvent in 1:length(hrobject$eventList)) {
  eventTime<-round(hrobject$eventTimes[iEvent]*samples_per_second)
  thisTimes<-eventTime+useTimes-adjust
  thisData<-hrobject$spectrogram$bands[1,thisTimes]
  offset<-mean(hrobject$spectrogram$bands[1,eventTime+offsetTimes],na.rm=TRUE)
  eventsHRV[iEvent,]<-thisData-offset
}
useOrder<-order(hrobject$eventList)
eventsHRV<-eventsHRV[useOrder,]

eventsTimes<-useTimes/samples_per_second

return(list(eventsTimes=eventsTimes,eventsHRV=eventsHRV))
}
