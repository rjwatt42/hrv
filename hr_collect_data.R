hr_collect_data<-function(folder,recover=TRUE) {
  
  hfiles<-dir(folder,"HR_music study*")
  sfiles<-dir(folder,"Cubicle*")
  
  hParts<-gsub("[^0-9]*","",hfiles)
  sParts<-gsub("[^0-9]*","",gsub("-1.","",sfiles,fixed=TRUE))
  
  useParts<-intersect(hParts,sParts)
  nParticipants<-length(useParts)
  print(nParticipants)
  
  hrvEventData<-c()
  hrvStimuliData<-c()
  for (i in 1:nParticipants) {
    useH<-grep(useParts[i],hfiles)
    h<-hr_load_acq_txt(paste0("data/",hfiles[useH]),recover=recover)
    if (!is.null(h)) {
      useS<-grep(useParts[i],sfiles)
      s<-hr_load_stimulus_txt(paste0("data/",sfiles[useS]))
      hrObject<-hr_eventProcess(h,s)

      hrObject<-hr_spectrogram(hrObject)
      
      hrvEvents<-hr_extract_events(hrObject)
      nEvents<-nrow(hrvEvents$eventsHRV)
      nSamples<-ncol(hrvEvents$eventsHRV)
      if (is.null(hrvEventData))
        hrvEventData<-array(NA,dim=c(nParticipants,nEvents,nSamples))
      hrvEventData[i,,]<-hrvEvents$eventsHRV
      
      hrvStimuli<-hr_extract_stimuli(hrObject)
      nStimuli<-nrow(hrvStimuli$stimuliHRV)
      nSamples<-ncol(hrvStimuli$stimuliHRV)
      if (is.null(hrvStimuliData))
        hrvStimuliData<-array(NA,dim=c(nParticipants,nStimuli,nSamples))
      hrvStimuliData[i,,]<-hrvStimuli$stimuliHRV
      
      print(paste0("Success: ",useParts[i]))
    } else {
      print(paste0("Failed: ",useParts[i]))
    }
  }
  
  result<-list(ids=useParts,eventsTimeBase=hrvEvents$timeBase,eventData=hrvEventData,
               stimuliTimeBase=hrvStimuli$timeBase,stimuliData=hrvStimuliData)
  return(result)
}

