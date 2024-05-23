 hr_plot_hrv=function(hrobject) {

   offset<-500
   ns<-length(hrobject$hr$spectrogram$spectrogram_times)-1
   spectrogram_times<-hrobject$hr$spectrogram$spectrogram_times[(1+offset):ns]
   bands<-hrobject$hr$spectrogram$bands[,(1+offset):ns]
   
   g<-ggplot() + 
     theme(panel.background = element_rect(fill="#EEEEEE", colour="#000000"),
           panel.grid.major = element_line(linetype="blank"),panel.grid.minor = element_line(linetype="blank"),
           plot.background = element_rect(fill="white", colour="black"),
           axis.title=element_text(size=12,face="bold")
     )
   
   data<-data.frame(x=spectrogram_times,y=bands[1,],col=rep("band1",ns-offset))
   g<-g+geom_line(data=data,aes(x=x,y=y,color=col))
   data<-data.frame(x=spectrogram_times,y=bands[2,],col=rep("band2",ns-offset))
   g<-g+geom_line(data=data,aes(x=x,y=y,color=col))
   
   g<-g+geom_vline(xintercept=hrobject$stimuli,color="black");
   g<-g+geom_vline(xintercept=hrobject$eventTimes,color="red");
   
   cols<-c(band1="blue",band2="green")
   g<-g+scale_color_manual(name="frequencies",values=cols,
                           labels=c(paste0(h1$hr$spectrogram$frequency_bands[1],"-",h1$hr$spectrogram$frequency_bands[2],"Hz"),
                                    paste0(h1$hr$spectrogram$frequency_bands[2],"-",h1$hr$spectrogram$frequency_bands[3],"Hz")
                                   )
   )
   g<-g+ylab('HRV')+xlab("time (secs)")  
   
   print(g)
 }
