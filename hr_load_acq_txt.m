function hrobject=hr_load_acq_txt(filename)

% read the raw .txt file
f=readlines(filename);

% decode the header lines
header={'time'};
channelHeads=0;
theline=1;
while(1==1)
    % data lines have tab characters (Ascii 9)
    % if this is a data line, we have reached the end of the header
    isData=contains(f(theline),char(9));
    if (isData) theline=theline+1; break; end
    % have we reached the section that describes each channel?
    if (channelHeads)
        % keep only alphabetic characters as these will become field names 
        fl=regexprep(f(theline),'[^a-zA-Z]*','');
        header=[header,fl];
        % channel descriptions span two lines
        theline=theline+2;
        continue
    end
    % the line that has "3 channels" immediately precedes the channel
    % descrpition
    channels=contains(f(theline),'channels');
    % so the next line is a channel description
    if (channels) channelHeads=1; end
    theline=theline+1;
end
% end of header

% now we get the data from the remaining lines
theline=theline+1;
data=str2num(char(f(theline:end)));

% put the data into a structure, using channel descriptions as field names
hrdata=[];
for i=1:size(data,2)
    hrdata.(header{i})=data(:,i);
end

% convert the timings to seconds
hrdata.time=hrdata.time*60; % in seconds

% find the events - where the digitalinput changes
hrobject.events=hrdata.time(find(diff(hrdata.Digitalinput)>0));

% finally, we downscale the data to 100Hz
hrobject.hr.samples_per_second=100;

[~,use]=unique(hrdata.time);
hrobject.hr.hr_time=0:1/hrobject.hr.samples_per_second:max(hrdata.time);
hrobject.hr.hr_signal=interp1(hrdata.time(use),hrdata.HeartRate(use),0:1/hrobject.hr.samples_per_second:max(hrdata.time));

% and return the data
return


