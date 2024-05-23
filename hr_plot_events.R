hr_plot_events=function(hrobject) {

# the window around each event to plot
window=c(-0.5, 1)*4; # seconds
window=window*hrobject$hr$samples_per_second;
use=window[1]:window[2]

# we can adjust the position of th eplot to tak einto account the hamming
# window
adjust=hrobject$hr$samples_per_second*hrobject$hr$spectrogram$fft_window_seconds/2;
# but better not to
adjust=0;

# pad out the spectrogram to provide enough window for an event right at
# the end
hrobject$hr$spectrogram$bands=cbind(hrobject$hr$spectrogram$bands, matrix(NA,2,window[2]));

# now plot the individual events
g<-ggplot()
ymean=0;
cols<-grDevices::hsv(seq(0,1,length.out=length(hrobject$eventList)),1,0.75)
cols<-c(cols,"#000000")
names(cols)<-c(hrobject$eventList,"All")
for (iEvent in 1:length(hrobject$eventList)) {
  x=use/hrobject$hr$samples_per_second;
  y=hrobject$hr$spectrogram$bands[1,round(hrobject$eventTimes[iEvent]*hrobject$hr$samples_per_second)+use-adjust]
  ymean=ymean+y;
  col<-rep(hrobject$eventList[iEvent],length(x))
  g<-g+geom_line(data=data.frame(x=x,y=y,col=col),aes(x=x,y=y,colour=col),linewidth=0.5)
}
# plot the average response
col<-rep("All",length(x))
g<-g+geom_line(data=data.frame(x=x,y=ymean/length(hrobject$eventList),col=col),aes(x=x,y=y,colour=col),linewidth=1.5)
g<-g+ylab("HRV")+xlab("time (secs)")
g<-g+scale_color_manual(name="",values = cols)
print(g)

}
