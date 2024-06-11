hr_load_stimulus_txt=function(filename) {
# this function reads the e-prime stimulus log
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

stimulusObject<-list(stimuli=stimuli)

return(stimulusObject)
}

