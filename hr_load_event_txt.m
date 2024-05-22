function eventObject=hr_load_event_txt(filename)

% read the raw .txt file
f=readlines(filename);

% remove the header lines
theline=1;
while(1==1)
    if (f(theline)=='*** Header End ***') break; end
    theline=theline+1;
end

stimuli={};
while (1==1)
    if (f(theline)=='*** LogFrame Start ***') break; end
    if contains(f(theline),'Stimulus:')
        bits=strsplit(f(theline),' ');
        bits(end)=strrep(bits(end),'.mp3','');
        stimuli=[stimuli,bits(end)];
    end
    theline=theline+1;
end

eventObject.stimuli=stimuli;



