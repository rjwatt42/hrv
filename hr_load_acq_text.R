hr_load_acq_txt=function(filename) {
# this function reads the bio-pac heart-rate data
#                             and also the time of stimuli
#                             but not the identity of the stimuli
  
  # read the raw .txt file
  suppressWarnings(f<-readLines(filename))
  if (f[1]=="\xff\xfe*") 
    f<-readLines(file(filename, encoding = "UCS-2LE"))

  # decode the header lines
  header='time'
  channelHeads=FALSE
  theline=1
  while(theline<=10) {
    # have we reached the section that describes each channel?
    # the line that has "3 channels" immediately precedes the channel
    # description
    channels=grepl('channels',f[theline]);
    # so the next line is a channel description
    if (channels) {
      noChannels<-as.numeric(strsplit(f[theline]," ")[[1]][1])
      break
    }
    theline=theline+1;
    # end of header
  }
  if (!channels) return(NULL)
  
  theline=theline+1;
  for ( i in 1:noChannels) {
    # keep only alphabetic characters as these will become field names 
    fl=gsub('[^a-zA-Z]*','',f[theline])
    header=c(header,fl)
    # channel descriptions span two lines
    theline=theline+2
  }
  
  # now we get the data from the remaining lines
  theline=theline+2
  z<-f[theline:length(f)]
  z1<-lapply(strsplit(z,"\t"),as.numeric)
  data<-matrix(unlist(z1),ncol=4,byrow=TRUE)
  use<-which(diff(data[,1])>0)
  data<-data[use,]
  # put the data into a structure, using channel descriptions as field names
  hrdata=data.frame(data);
  names(hrdata)<-header[1:4]

  # convert the timings to seconds
  hrdata$time=hrdata$time*60; # in seconds
  
  # find the events - where the digitalinput changes
  stimuli=hrdata$time[which(diff(hrdata$Digitalinput)>0)];
  
  # finally, we downscale the data to 100Hz
  samples_per_second=100
  hr_time=seq(0,max(hrdata$time),1/samples_per_second)
  hr_signal=approx(hrdata$time,hrdata$HeartRate,hr_time)$y

  hr<-data.frame(hr_time=hr_time,
           hr_signal=hr_signal
  )

  hrobject<-list(hr=hr,
                 stimuli=stimuli
                 )  
  
  # and return the data
  return(hrobject)
}




