hr_write_results<-function(hr_data,filename) {
  
  stimData<-rowSums(hr_data$stimuliData[,,hr_data$stimuliTimeBase>=0 & hr_data$stimuliTimeBase<8],dims=2,na.rm=TRUE)
  eventData<-rowSums(hr_data$eventData[,,hr_data$eventsTimeBase>=0 & hr_data$eventsTimeBase<8],dims=2,na.rm=TRUE)
  numericalData<-data.frame(id=hr_data$ids,
                            allStimData=rowSums(stimData),
                            allEventData=rowSums(eventData),
                            stimData=stimData,
                            eventData=eventData
  )
  write.csv(numericalData,filename)
}
 
