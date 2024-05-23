hr_plot_hr=function(hrobject) {
  
  offset<-500
  ns<-length(hrobject$hr$hr_time)
  x<-hrobject$hr$hr_time[(1+offset):ns]
  y<-hrobject$hr$hr_signal[(1+offset):ns]
  use<-(!is.na(y))
  data<-data.frame(x=x[use],y=y[use])
  
  g<-ggplot()
  g<-g+geom_line(data=data,aes(x=x,y=y),color="darkgrey")
  g<-g+geom_vline(xintercept=hrobject$stimuli,color="black");
  g<-g+geom_vline(xintercept=hrobject$eventTimes,color="red");
  g<-g+ylab('HR (bpm)')+xlab("time (secs)")  
  
  print(g)
}


