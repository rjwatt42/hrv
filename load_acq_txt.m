function hrobject=load_acq_txt(filename)

f=readlines(filename);

header={'time'};
channelHeads=0;
theline=1;
while(1==1)
    isData=contains(f(theline),char(9));
    if (isData) theline=theline+1; break; end
    if (channelHeads)
        fl=regexprep(f(theline),'[^a-zA-Z]*','');
        header=[header,fl];
        theline=theline+2;
        continue
    end
    channels=contains(f(theline),'channels');
    if (channels) channelHeads=1; end
    theline=theline+1;
end


theline=theline+1;
data=str2num(char(f(theline:end)));

hrdata=[];
for i=1:size(data,2)
    hrdata.(header{i})=data(:,i);
end

hrdata.time=hrdata.time*60; % in seconds
hrobject.events=hrdata.time(find(diff(hrdata.Digitalinput)>0));

hrobject.hr.samples_per_second=100;

[~,use]=unique(hrdata.time);
hrobject.hr.hr_time=0:1/hrobject.hr.samples_per_second:max(hrdata.time);
hrobject.hr.hr_signal=interp1(hrdata.time(use),hrdata.HeartRate(use),0:1/hrobject.hr.samples_per_second:max(hrdata.time));
hrdata.time=0:1/hrobject.hr.samples_per_second:max(hrdata.time);

hrobject.hr.spectrogram.fft_window_seconds=10;
hrobject.hr.spectrogram.frequency_bands=[0.04 0.15 0.4];

hrobject=hr_spectrogram(hrobject);


