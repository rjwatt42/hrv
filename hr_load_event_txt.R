hr_load_event_txt=function(filename) {

# read the raw .txt file
f=readLines(filename,encoding="UTF-16")

# remove the header lines
theline=1
while(1==1) {
  if (f[theline]=='*** Header End ***') break; end
  theline=theline+1;
}

stimuli=c();
while (1==1) {
  if (f[theline]=='*** LogFrame Start ***') break; end
  if (grepl('Stimulus:',f[theline])) {
    bits=strsplit(f[theline],' ')[[1]]
    end<-length(bits)
    bits[end]=gsub('.mp3','',bits[end]);
    stimuli=c(stimuli,bits[end]);
  }
  theline=theline+1;
}

eventObject<-list(stimuli=stimuli)

return(eventObject)
}

