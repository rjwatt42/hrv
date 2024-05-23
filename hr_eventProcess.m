function hrobject=hr_eventProcess(hrobject,eventObject)

POI={
'Stim_1a' '1a1' 4.25 0.04;
'Stim_1b' '1b1' 5.333 0.04;
'Stim_1c' '1c1' 5.0 0.04;
'Stim_1d' '1d1' 6.5 0.04;
'Stim_2a' '2a1' 11.75 0.04;
'Stim_2a' '2a2' 16.5 0.04;
'Stim_2a' '2a3' 24 0.04;
'Stim_2b' '2b1' 7 0.04;
'Stim_2b' '2b2' 14 0.04;
'Stim_2b' '2b3' 22 0.04;
'Stim_3a' '3a1' 8 0.04;
'Stim_3b' '3b1' 8 0.04;
'Stim_3b' '3b2' 18.25 0.04;
'Stim_3c' '3c1' 3.5 0.04;
'Stim_3c' '3c2' 9 0.04;
'Stim_4a' '4a1' 17 0.04;
'Stim_4b' '4b1' 6 0.04;
'Stim_4c' '4c1' 8 0.04;
'Stim_4c' '4c2' 30 0.04;
'Stim_4d' '4d1' 12 0.04;
'Stim_4d' '4d2' 27.5 0.04;
};

stimStartTimes=hrobject.stimuli;

eventList={};
eventTimes=[];
for i=1:length(eventObject.stimuli)
    time=stimStartTimes(i);
    use=find(POI(:,1)==eventObject.stimuli(i));
    eventList=[eventList POI(use,2)'];
    eventTimes=[eventTimes time+[POI{use,3}]];
end


hrobject.eventList=eventList;
hrobject.eventTimes=eventTimes;

