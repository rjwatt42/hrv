hr_plot_hr=function(hrobject,offset=500,plain=FALSE,filter=FALSE,doReturn=FALSE) {
  
  ns<-length(hrobject$hr$hr_time)
  x<-hrobject$hr$hr_time[(1+offset):ns]
  y<-hrobject$hr$hr_signal[(1+offset):ns]
  ym<-mean(y,na.rm=TRUE)
  use<-(!is.na(y))
  data<-data.frame(x=x[use],y=y[use])
  
  g<-ggplot() + 
             theme(panel.background = element_rect(fill="#EEEEEE", colour="#000000"),
                   panel.grid.major = element_line(linetype="blank"),panel.grid.minor = element_line(linetype="blank"),
                   plot.background = element_rect(fill="white", colour="black"),
                   axis.title=element_text(size=12,face="bold")
             )
  
  g<-g+geom_line(data=data,aes(x=x,y=y),color="darkgrey")
  if (filter) {
    L <- floor(length(y)/2)*2                    # Length of signal
    samples_per_second<-length(x)/(max(x)-min(x))
    freq <- samples_per_second/2*seq(0,1,length.out=L/2);
    y<-fft(y-mean(y))
    y[freq>0.15]<-0
    y<-Re(ifft(y))
    y<-(y-mean(y,na.rm=TRUE))*2+ym
    use<-(!is.na(y))
    data<-data.frame(x=x[use],y=y[use])
    g<-g+geom_line(data=data,aes(x=x,y=y),color="darkred")
  }
  
  if (!plain) {
    g<-g+geom_vline(xintercept=hrobject$stimuli,color="black",linewidth=0.25);
    g<-g+geom_vline(xintercept=hrobject$eventTimes,color="red",linewidth=0.25);
  }
  g<-g+scale_x_continuous(limits=c(0,max(data$x)+10))
  g<-g+ylab('HR (bpm)')+xlab("time (secs)")  

  if (doReturn) return(g)
  print(g)
}


