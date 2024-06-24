hr_extract_stimuli=function(hrobject,window=c(-4,16)
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
stimuliHRV<-matrix(0,length(hrobject$stimuliList),length(useTimes))
for (iStimulus in 1:length(hrobject$stimuliList)) {
  eventTime<-round(hrobject$stimuliTimes[iStimulus]*samples_per_second)
  thisTimes<-eventTime+useTimes-adjust
  thisData<-hrobject$spectrogram$bands[1,thisTimes]
  offset<-mean(hrobject$spectrogram$bands[1,eventTime+offsetTimes],na.rm=TRUE)
  stimuliHRV[iStimulus,]<-thisData-offset
}
useOrder<-order(hrobject$stimuliList)
stimuliHRV<-stimuliHRV[useOrder,]

timeBase<-useTimes/samples_per_second

return(list(timeBase=timeBase,stimuliHRV=stimuliHRV))
}
