hr_collect_data<-function(folder) {
  
  hfiles<-dir(folder,"HR_music study*")
  sfiles<-dir(folder,"Cubicle*")
  
  hParts<-gsub("[^0-9]*","",hfiles)
  sParts<-gsub("[^0-9]*","",gsub("-1.","",sfiles,fixed=TRUE))
  
  useParts<-intersect(hParts,sParts)
  nParticipants<-length(useParts)
  
  hrvData<-c()
  for (i in 1:nParticipants) {
    useH<-grep(useParts[i],hfiles)
    h<-hr_load_acq_txt(paste0("data/",hfiles[useH]))
    if (!is.null(h)) {
      useS<-grep(useParts[i],sfiles)
      s<-hr_load_stimulus_txt(paste0("data/",sfiles[useS]))
      hrObject<-hr_eventProcess(h,s)
      
      hrObject<-hr_spectrogram(hrObject)
      hrvEvents<-hr_extract_events(hrObject)
      nEvents<-nrow(hrvEvents$eventsHRV)
      nSamples<-ncol(hrvEvents$eventsHRV)
      
      if (is.null(hrvData))
        hrvData<-array(NA,dim=c(nParticipants,nEvents,nSamples))
      hrvData[i,,]<-hrvEvents$eventsHRV
      
    } else {
      print(paste0("Failed: ",useParts[i]))
    }
  }
  return(hrvData)
}

