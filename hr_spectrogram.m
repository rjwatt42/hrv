function hr_object=hr_spectrogram(hr_object)

fft_window_seconds=10;
frequency_bands=[0.04 0.15 0.4];
spectrogram_hamming=1;

% run through each hr recording in turn
for hi=1:length(hr_object)
    % set the process parameters
    hrobject(hi).hr.spectrogram.fft_window_seconds=fft_window_seconds;
    hrobject(hi).hr.spectrogram.frequency_bands=frequency_bands;
    hr_object(hi).hr.spectrogram.spectrogram_hamming=spectrogram_hamming;

    % find the frequencies that will be produced by the fft
    fft_size=hr_object(hi).hr.samples_per_second.*hr_object(hi).hr.spectrogram.fft_window_seconds;
    L = floor(fft_size/2)*2;                     % Length of signal
    actual_frequencies = hr_object(hi).hr.samples_per_second/2*linspace(0,1,L/2+1);
    % we don;t need anything above 2Hz
    use_frequencies=find(actual_frequencies<=2);
    
    % get the mask window
    if hr_object(hi).hr.spectrogram.spectrogram_hamming==1
        mask=hamming(fft_size,'periodic')';
    else
        mask=1;
    end
    
    % here we go!
    h=waitbar(0,['Doing Spectrogram '  '...']);
    % input signal
    full_signal=hr_object(hi).hr.hr_signal;
    % output storage
    hrvf=zeros(length(use_frequencies),ceil(length(full_signal)-fft_size-1));
    
    % at each point in the full signal, 
    for si=1:length(full_signal)-fft_size-1
        % we calculate the fft of the next 10 secs of signal
        local_signal=full_signal(si+(0:(fft_size-1)));
        % subtract the DC - necessary because of the hamming mask
        local_signal=local_signal-mean(local_signal);
        % multuply by the mask
        local_signal=local_signal.*mask;
        % do the fft
        Y = fft(local_signal(1:L))/L;
        Y = Y(1:L/2+1); Y(1)=0;
        % save the frequencies we want
        hrvf(:,si)=Y(use_frequencies);
        waitbar(si./(length(full_signal)-fft_size-1),h);
    end
    close(h);
    
    % ??
    hrvf(hrvf==0)=0;
    
    % store the results so far
    hr_object(hi).hr.spectrogram.hrvf=hrvf; % hrvfs=repmat(sum(hrvf,1),size(hrvf,1),1); hr_object.hrvf1=hrvf./hrvfs;
    hr_object(hi).hr.spectrogram.spectrogram_times= hr_object(hi).hr.spectrogram.fft_window_seconds+(0:size(hr_object(hi).hr.spectrogram.hrvf,2)-1)./hr_object(hi).hr.samples_per_second;
    hr_object(hi).hr.spectrogram.spectrogram_frequencies=actual_frequencies(use_frequencies);
    
    % now extract the power in the frequency bands we have identified
    hr_object(hi).hr.spectrogram.bands=[];
    for fi=1:length(hr_object(hi).hr.spectrogram.frequency_bands)-1
        use1=hr_object(hi).hr.spectrogram.spectrogram_frequencies>=hr_object(1).hr.spectrogram.frequency_bands(fi) ...
            & hr_object(hi).hr.spectrogram.spectrogram_frequencies<hr_object(1).hr.spectrogram.frequency_bands(fi+1);
        % could also do RMS: sqrt(sum(sqr())) but more sentivie to large values
        hr_object(hi).hr.spectrogram.bands(fi,:)=sum(abs(hrvf(use1,:)),1);
    end
end




