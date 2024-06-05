hr_plot_hr_fft=function(hrobject,offset=500,showBands=TRUE,inverse=FALSE) {
  
  frequency_bands=c(0.04, 0.15, 0.4);
  
  ns<-length(hrobject$hr$hr_time)
  x<-hrobject$hr$hr_time[(1+offset):ns]
  y<-hrobject$hr$hr_signal[(1+offset):ns]
    L <- floor(length(y)/2)*2                    # Length of signal
    samples_per_second<-length(x)/(max(x)-min(x))
    x <- samples_per_second/2*seq(0,1,length.out=L/2);
    y<-abs(fft(y-mean(y)))
    y[1]<-NA
    y<-y/max(y,na.rm=TRUE)
  use<-(!is.na(y) & x<=1)
  data<-data.frame(x=x[use],y=y[use])

  g<-ggplot() + 
    theme(panel.background = element_rect(fill="#EEEEEE", colour="#000000"),
          panel.grid.major = element_line(linetype="blank"),panel.grid.minor = element_line(linetype="blank"),
          plot.background = element_rect(fill="white", colour="black"),
          axis.title=element_text(size=12,face="bold")
    )
  
  g<-g+geom_line(data=data,aes(x=x,y=y),color="darkgrey")
  
  if (showBands) {
    g<-g+geom_vline(xintercept=frequency_bands,color="red",linewidth=0.25);
  }
  g<-g+scale_x_log10()+scale_y_log10()+ylab("Power")+xlab("Freq (Hz)")

  print(g)
}


