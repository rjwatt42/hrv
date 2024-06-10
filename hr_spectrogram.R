hr_spectrogram=function(hr_object,fft_window_seconds=10,frequency_bands=c(0.04, 0.15, 0.4),
                        timePoints=NULL) {
  
  spectrogram_hamming<-TRUE
  
  # run through each hr recording in turn
  for (hi in 1:1) {
    # set the process parameters
    hr_object$hr$spectrogram$fft_window_seconds=fft_window_seconds;
    hr_object$hr$spectrogram$frequency_bands=frequency_bands;
    hr_object$hr$spectrogram$spectrogram_hamming=spectrogram_hamming;
    samples_per_second<-1/diff(hr_object$hr$hr_time[1:2])
    
    # find the frequencies that will be produced by the fft
    fft_size=samples_per_second*fft_window_seconds;
    L = floor(fft_size/2)*2;                     # Length of signal
    actual_frequencies = samples_per_second/2*seq(0,1,length.out=L/2+1);
    # we don;t need anything above 2Hz
    use_frequencies=which(actual_frequencies<=2);
    
    # get the mask window
    if (spectrogram_hamming)
      mask=hamming(fft_size,'periodic')
    else
      mask=1
    
    # here we go!
    # input signal
    full_signal=hr_object$hr$hr_signal
    full_signal[1]<-0
    # output storage
    hrvf=matrix(0,length(use_frequencies),ceiling(length(full_signal)-fft_size-1));
    
    # at each point in the full signal, 
    for (si in 1:(length(full_signal)-fft_size-1)) {
      # we calculate the fft of the next 10 secs of signal
      local_signal=full_signal[si+(0:(fft_size-1))];
      # subtract the DC - necessary because of the hamming mask
      local_signal=local_signal-mean(local_signal,na.rm=TRUE)
      # multiply by the mask
      local_signal=local_signal*mask
      # do the fft
      Y = fft(local_signal[1:L])/L
      Y = Y[1:(L/2+1)]
      Y[1]=0
      # save the frequencies we want
      hrvf[,si]=Y[use_frequencies]
    }
    
    # store the results so far
    hr_object$hr$spectrogram$hrvf=hrvf; # hrvfs=repmat(sum(hrvf,1),size(hrvf,1),1); hr_object$hrvf1=hrvf$/hrvfs;
    hr_object$hr$spectrogram$spectrogram_times= fft_window_seconds+(0:ncol(hr_object$hr$spectrogram$hrvf)-1)/samples_per_second;
    hr_object$hr$spectrogram$spectrogram_frequencies=actual_frequencies[use_frequencies];
    
    # now extract the power in the frequency bands we have identified
    bands=matrix(0,(length(hr_object$hr$spectrogram$frequency_bands)-1),ncol(hrvf));
    for (fi in 1:(length(hr_object$hr$spectrogram$frequency_bands)-1)) {
      use1=hr_object$hr$spectrogram$spectrogram_frequencies>=hr_object$hr$spectrogram$frequency_bands[fi] &
        hr_object$hr$spectrogram$spectrogram_frequencies<hr_object$hr$spectrogram$frequency_bands[fi+1]
      # could also do RMS: sqrt(sum(sqr())) but more sensitive to large values
      if (sum(use1)>1)      bands[fi,]=colSums(abs(hrvf[use1,]))
      else                  bands[fi,]=abs(hrvf[use1,])
    }
    if (!is.null(timePoints)) {
      useTimes<-hr_object$hr$spectrogram$spectrogram_times
      useTimes<-useTimes[2:length(useTimes)]
      use<-c()
      for (i in 1:length(timePoints))
      use<-c(use,which.min(abs(useTimes-timePoints[i])))
      newBands<-bands*0
      newBands[,use]<-bands[,use]
      bands<-newBands
    }
    hr_object$hr$spectrogram$bands<-bands
  }
  return(hr_object)
}


