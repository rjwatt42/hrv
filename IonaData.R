
library(readxl)

data<-read_excel("Diss_Data.xlsx","MT_cat")

modelData<-data.frame(HRV_Final=as.numeric(data$HRV_Final),
                      Listener=as.factor(data$Listener),
                      Trained=as.factor(data$Trained),
                      Rehearsal=as.factor(data$Rehersal),
                      Performer=as.factor(data$Perfomer),
                      Theorist=as.factor(data$Theorist)
)

linModelA1<-lm("HRV_Final~Listener",modelData)
linModelA2<-lm("HRV_Final~Listener+Trained",modelData)
linModelA3<-lm("HRV_Final~Listener+Trained+Rehearsal",modelData)
linModelA4<-lm("HRV_Final~Listener+Trained+Rehearsal+Performer",modelData)

models<-c(
  "Listener",
  "+Trained",
  "+Rehearsal",
  "+Performer"
)
# extract the R-squared values for each model
rsqs<-c(
summary(linModelA1)$r.squared,
summary(linModelA2)$r.squared,
summary(linModelA3)$r.squared,
summary(linModelA4)$r.squared
)
# now we get the extra effect arising from each successive term
# these are the same as correlation coefficients 
# except that they dont have a sign
effectSizes<-sqrt(diff(c(0, rsqs)))

df<-c(
  summary(linModelA1)$df[2],
  summary(linModelA2)$df[2],
  summary(linModelA3)$df[2],
  summary(linModelA4)$df[2]
)

# get p-values for these effect sizes
t<-effectSizes*sqrt(df)/sqrt(1-effectSizes^2)
p<-(1-pt(t,df))

g1<-ggplot(data.frame(model=1:4,r=effectSizes,labels=paste0("p=",format(p,digits=3))))+
  theme(panel.background = element_rect(fill="#EEEEEE", colour="#000000"),
        panel.grid.major = element_line(linetype="blank"),panel.grid.minor = element_line(linetype="blank"),
        plot.background = element_rect(fill="white", colour="white"),
        axis.title=element_text(size=12,face="bold")
  )

g1<-g1+geom_point(aes(x=model,y=r),shape=22,size=4,fill="red")
g1<-g1+scale_x_continuous(breaks=1:4,labels=models,limits=c(0.5,4.5))
g1<-g1+scale_y_continuous(limits=c(0,0.5))
g1<-g1+xlab("Model")+ylab("Additional r")

g1<-g1+geom_text(aes(x=model,y=r,label=labels),hjust=-0.25,size=3)
print(g1)


# we could go on to look at this:
linModelB1<-lm("HRV_Final~Theorist",modelData)
linModelB2<-lm("HRV_Final~Theorist+Listener+Trained+Rehearsal+Performer",modelData)
