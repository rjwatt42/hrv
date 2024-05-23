
eventList<-c("a","b","c","d")

g<-ggplot()
cols<-grDevices::hsv(seq(0,1,length.out=10),1,1)
cl<-cols[1:(1+length(eventList))]
names(cl)<-c(eventList,"All")
ymean<-0
for (iEvent in 1:length(eventList)) {
  x<-1:100
  y<-runif(100)
  ymean<-ymean+y
  col<-rep(eventList[iEvent],length(x))
  g<-g+geom_line(data=data.frame(x=x,y=y,col=col),aes(x=x,y=y,colour=col),linewidth=0.5)
}
g<-g+geom_line(data=data.frame(x=x,y=ymean/length(eventList)),aes(x=x,y=y,colour="All"),linewidth=1.5)
g<-g+ylab("HRV")+xlab("time (secs)")
g<-g+scale_color_manual(name="",values = cl)
print(g)
