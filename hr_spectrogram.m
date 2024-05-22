function hr_object=hr_spectrogram(hr_object)


for hi=1:length(hr_object)

    fft_size=hr_object(hi).hr.samples_per_second.*hr_object(hi).hr.spectrogram.fft_window_seconds;
    L = floor(fft_size/2)*2;                     % Length of signal
    actual_frequencies = hr_object(hi).hr.samples_per_second/2*linspace(0,1,L/2+1);
    use_frequencies=find(actual_frequencies<=2);
    
    full_signal=hr_object(hi).hr.hr_signal;
    
    h=waitbar(0,['Doing Spectrogram '  '...']);
    hrvf=zeros(length(use_frequencies),ceil(length(full_signal)-fft_size-1));
    if ~isfield(hr_object(hi).hr.spectrogram,'spectrogram_hamming'),
        hr_object(hi).hr.spectrogram.spectrogram_hamming=1;
    end
    if hr_object(hi).hr.spectrogram.spectrogram_hamming==1
        mask=hamming(fft_size,'periodic')';
    else
        mask=1;
    end
    for si=1:length(full_signal)-fft_size-1
        local_signal=full_signal(si+(0:(fft_size-1)));
        local_signal=local_signal-mean(local_signal);
        local_signal=local_signal.*mask;
        Y = fft(local_signal(1:L))/L;
        Y = abs(Y(1:L/2+1)); Y(1)=0;
        hrvf(:,si)=Y(use_frequencies);
        waitbar(si./(length(full_signal)-fft_size-1),h);
    end
    close(h);
    
    hrvf(hrvf==0)=0;
    
    hr_object(hi).hr.spectrogram.hrvf=hrvf; % hrvfs=repmat(sum(hrvf,1),size(hrvf,1),1); hr_object.hrvf1=hrvf./hrvfs;
    hr_object(hi).hr.spectrogram.spectrogram_times= hr_object(hi).hr.spectrogram.fft_window_seconds+(0:size(hr_object(hi).hr.spectrogram.hrvf,2)-1)./hr_object(hi).hr.samples_per_second;
    hr_object(hi).hr.spectrogram.spectrogram_frequencies=actual_frequencies(use_frequencies);
    
    hr_object(hi).hr.spectrogram.bands=[];
    for fi=1:length(hr_object(hi).hr.spectrogram.frequency_bands)-1
        use1=hr_object(hi).hr.spectrogram.spectrogram_frequencies>=hr_object(1).hr.spectrogram.frequency_bands(fi) ...
            & hr_object(hi).hr.spectrogram.spectrogram_frequencies<hr_object(1).hr.spectrogram.frequency_bands(fi+1);
        hr_object(hi).hr.spectrogram.bands(fi,:)=sum(hrvf(use1,:),1);
    end
end




