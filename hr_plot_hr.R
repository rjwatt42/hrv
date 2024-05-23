hr_plot_hr=function(hrobject) {
  
  offset<-500
  ns<-length(hrobject$hr$hr_time)
  x<-hrobject$hr$hr_time[(1+offset):ns]
  y<-hrobject$hr$hr_signal[(1+offset):ns]
  use<-(!is.na(y))
  data<-data.frame(x=x[use],y=y[use])
  
  g<-ggplot() + 
             theme(panel.background = element_rect(fill="#EEEEEE", colour="#000000"),
                   panel.grid.major = element_line(linetype="blank"),panel.grid.minor = element_line(linetype="blank"),
                   plot.background = element_rect(fill="white", colour="black"),
                   axis.title=element_text(size=12,face="bold")
             )
  
  g<-g+geom_line(data=data,aes(x=x,y=y),color="darkgrey")
  g<-g+geom_vline(xintercept=hrobject$stimuli,color="black",linewidth=0.25);
  g<-g+geom_vline(xintercept=hrobject$eventTimes,color="red",linewidth=0.25);
  g<-g+ylab('HR (bpm)')+xlab("time (secs)")  
  
  print(g)
}


