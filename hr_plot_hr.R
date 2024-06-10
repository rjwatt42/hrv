hr_plot_hr=function(hrobject,offset=400,plain=FALSE,filter=FALSE,doReturn=FALSE) {
# offset is the number of heart rate samples at the start that we ignore
# because they will be before the set up (including participant) had settled down
# 400 corresponds to 4 seconds
  
# the other arguments are all for convenience in making explanatory plots
  # plain, if true removes the events
  # filter if true filters the hr_signal and shows only the low frequencies
  # doReturn doesn't produce the graph but instead returns the ggplot2 object
  
  ns<-length(hrobject$hr$hr_time)
  x<-hrobject$hr$hr_time[(1+offset):ns]
  y<-hrobject$hr$hr_signal[(1+offset):ns]
  
  # we only plot the signal where it has meaningful values
  # (na means "not available")
  use<-(!is.na(y))
  data<-data.frame(x=x[use],y=y[use])
  
  # get the plot ready - including setting the theme to look good
  g<-ggplot() + 
             theme(panel.background = element_rect(fill="#EEEEEE", colour="#000000"),
                   panel.grid.major = element_line(linetype="blank"),panel.grid.minor = element_line(linetype="blank"),
                   plot.background = element_rect(fill="white", colour="black"),
                   axis.title=element_text(size=12,face="bold")
             )
  # plot the heart-rate line
  g<-g+geom_line(data=data,aes(x=x,y=y),color="darkgrey")
  
  if (filter) {
    yGlobalMean<-mean(y,na.rm=TRUE)
    L <- floor(length(y)/2)*2                    # Length of signal
    samples_per_second<-length(x)/(max(x)-min(x))
    freq <- samples_per_second/2*seq(0,1,length.out=L/2);
    # do the fourier transform
    y<-fft(y-mean(y))
    # remove frequencies we don't want by setting them to zero
    y[freq>0.15]<-0
    # reverse the fourier transform to get the filtered signal
    # we only want the Real part of it
    # and we reinstate the original mean value
    y<-Re(ifft(y))
    y<-(y-mean(y,na.rm=TRUE))*2+yGlobalMean
    use<-(!is.na(y))
    # then plot this
    data<-data.frame(x=x[use],y=y[use])
    g<-g+geom_line(data=data,aes(x=x,y=y),color="darkred")
  }
  
  # unless we are doing a plain plot we can add on 
  # i.  the stimulus starts
  # ii. the unexpected events
  if (!plain) {
    g<-g+geom_vline(xintercept=hrobject$stimuli,color="black",linewidth=0.25);
    g<-g+geom_vline(xintercept=hrobject$eventTimes,color="red",linewidth=0.25);
  }
  
  # set the range of the x axis
  g<-g+scale_x_continuous(limits=c(0,max(data$x)+10))
  # add axis labels
  g<-g+ylab('HR (bpm)')+xlab("time (secs)")  

  if (doReturn) return(g)
  print(g)
}


