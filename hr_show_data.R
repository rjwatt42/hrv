hr_show_data<-function(hrvObject,typeShow="events",whichShow="All") {
  
  if (typeShow=="events") {
    hrvData<-hrvObject$eventData
    timeBase<-hrvObject$eventsTimeBase
  } else {
    hrvData<-hrvObject$stimuliData
    timeBase<-hrvObject$stimuliTimeBase
  }
  nParticipants<-dim(hrvData)[1]
  nEvents<-dim(hrvData)[2]
  nSamples<-dim(hrvData)[3]
  if (whichShow!="All") {
    hrvData<-hrvData[,whichShow,]  
    nEvents<-length(whichShow)
    hrvData<-array(hrvData,dim=c(nParticipants,nEvents,nSamples))
  }
  
  meanParticipantHRV<-colMeans(hrvData,na.rm=TRUE)
  meanParticipantEventHRV<-colMeans(meanParticipantHRV,na.rm=TRUE)
  
  a<-rep(meanParticipantEventHRV,length.out=nSamples*nEvents*nParticipants)
  b<-aperm(array(a,dim=c(nSamples,nParticipants,nEvents)),c(2,3,1))
  sdParticipantEventHRV<-sqrt(colMeans(colMeans((hrvData-b)^2,na.rm=TRUE)))
  seParticipantEventHRV<-sdParticipantEventHRV/sqrt(nEvents*nParticipants)
  
  g<-ggplot() + 
    theme(panel.background = element_rect(fill="#EEEEEE", colour="#000000"),
          panel.grid.major = element_line(linetype="blank"),panel.grid.minor = element_line(linetype="blank"),
          plot.background = element_rect(fill="white", colour="black"),
          axis.title=element_text(size=12,face="bold")
    )
  g<-g+geom_hline(yintercept=0,color="red")
  # plot the heart-rate line
  g<-g+geom_line(data=data.frame(x=timeBase,y=meanParticipantEventHRV),
                 aes(x=x,y=y),color="black")
  g<-g+geom_line(data=data.frame(x=timeBase,y=meanParticipantEventHRV-seParticipantEventHRV),
                 aes(x=x,y=y),color="lightgrey")
  g<-g+geom_line(data=data.frame(x=timeBase,y=meanParticipantEventHRV+seParticipantEventHRV),
                 aes(x=x,y=y),color="lightgrey")
  g<-g+labs(y='HRV',x="time (secs)",title=paste0("Event=",whichShow))
  print(g)
  
}
