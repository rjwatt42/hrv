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
  while(1==1) {
    # data lines have tab characters (Ascii 9)
    # if this is a data line, we have reached the end of the header
    isData=grepl(as.character(9),f[theline])
    if (isData) { 
      theline=theline+1
      break
    }
    # have we reached the section that describes each channel?
    if (channelHeads) {
      # keep only alphabetic characters as these will become field names 
      fl=gsub('[^a-zA-Z]*','',f[theline])
      header=c(header,fl)
      # channel descriptions span two lines
      theline=theline+1
    }
    
    # the line that has "3 channels" immediately precedes the channel
    # descrpition
    channels=grepl('channels',f[theline]);
    # so the next line is a channel description
    if (channels) channelHeads=TRUE
    theline=theline+1;
    # end of header
  }
  # now we get the data from the remaining lines
  theline=theline+1
  z<-f[theline:length(f)]
  z1<-lapply(strsplit(z,"\t"),as.numeric)
  data<-matrix(unlist(z1),ncol=4,byrow=TRUE)
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

  hr<-list(samples_per_second=samples_per_second,
           hr_time=hr_time,
           hr_signal=hr_signal
  )

  hrobject<-list(hrdata=hrdata,
                 stimuli=stimuli,
                 hr=hr)  
  
  # and return the data
  return(hrobject)
}




