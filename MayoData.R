
library(readxl)

data<-read_excel("Mayo full data.xlsx")

linModel<-lm("HRV~EFT*SumAnxiety",data)

summary(linModel)

g<-ggplot(data=data)
g<-g+geom_point(aes(x=EFT,y=HRV),shape=21,size=3)
print(g)

anxiety<-data$SumAnxiety>=median(data$SumAnxiety)
data$Anxiety<-ifelse(anxiety,"high","low")
g<-ggplot()
g<-g+geom_point(data=data,aes(x=EFT,y=HRV,fill=Anxiety),shape=21,size=3)
print(g)
