hr_load_event_txt=function(filename) {
# this function reads the e-prime events log
#    which contains the identities of the stimuli
  
# read the raw .txt file
  suppressWarnings(f<-readLines(filename))
  if (f[1]=="\xff\xfe*") 
    f<-readLines(file(filename, encoding = "UCS-2LE"))

# remove the header lines
theline=1
while(1==1) {
  if (f[theline]=='*** Header End ***') break; end
  theline=theline+1;
}

events=c();
while (1==1) {
  if (f[theline]=='*** LogFrame Start ***') break; end
  if (grepl('Stimulus:',f[theline])) {
    bits=strsplit(f[theline],' ')[[1]]
    end<-length(bits)
    bits[end]=gsub('.mp3','',bits[end]);
    events=c(events,bits[end]);
  }
  theline=theline+1;
}

eventObject<-list(events=events)

return(eventObject)
}

