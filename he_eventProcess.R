hr_eventProcess=function(hrobject,eventObject) {
  
  POI=c(
    'Stim_1a', '1a1', 4.25, 
    'Stim_1b', '1b1', 5.333, 
    'Stim_1c', '1c1', 5.0, 
    'Stim_1d', '1d1', 6.5, 
    'Stim_2a', '2a1', 11.75, 
    'Stim_2a', '2a2', 16.5, 
    'Stim_2a', '2a3', 24, 
    'Stim_2b', '2b1', 7, 
    'Stim_2b', '2b2', 14, 
    'Stim_2b', '2b3', 22, 
    'Stim_3a', '3a1', 8, 
    'Stim_3b', '3b1', 8, 
    'Stim_3b', '3b2', 18.25, 
    'Stim_3c', '3c1', 3.5, 
    'Stim_3c', '3c2', 9, 
    'Stim_4a', '4a1', 17, 
    'Stim_4b', '4b1', 6, 
    'Stim_4c', '4c1', 8, 
    'Stim_4c', '4c2', 30, 
    'Stim_4d', '4d1', 12, 
    'Stim_4d', '4d2', 27.5
  )
  POI<-matrix(POI,ncol=3,byrow=TRUE)
  
  stimStartTimes=hrobject$stimuli;
  
  eventList=c();
  eventTimes=c();
  for (i in 1:length(eventObject$stimuli)) {
    time=stimStartTimes[i]
    use=which(POI[,1]==eventObject$stimuli[i])
    eventList=c(eventList, POI[use,2])
    eventTimes=c(eventTimes, time+as.numeric(POI[use,3]))
  }
  
  
  hrobject$eventList=eventList;
  hrobject$eventTimes=eventTimes;
  
  return(hrobject)
}
