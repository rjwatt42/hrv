function hr_object=hr_calc_hr(hr_object,the_hr,the_times)

samples_per_second=16;

if length(hr_object)>1,
    h=waitbar(0,'Calculating HR');
end
for hi=1:length(hr_object)
    if nargin==3
        % hr_object=hr_calc_hr(hr_object,times,hr);
        hr_object(hi).hr.phr=the_hr;
        hr_object(hi).hr.time_phr=the_times;
        
        this_start_time=min(hr_object(hi).hr.time_phr);
        this_end_time=max(hr_object(hi).hr.time_phr);
        
        hr_object(hi).hr.samples_per_second=samples_per_second;
        hr_object(hi).hr.hr_time_pts=this_start_time:1/hr_object(hi).hr.samples_per_second:this_end_time;
        p_signal=interp1(hr_object(hi).hr.time_phr,hr_object(hi).hr.phr,hr_object(hi).hr.hr_time_pts);
        hr_object(hi).hr.hr_signal=p_signal;
    end
    
    if ~isfield(hr_object(hi).hr,'smooth_recording') || isempty(hr_object(hi).hr.smooth_recording)
        hr_object=hr_calc_smooth_hr(hr_object);
    end
    local_n=101;
    local_mean=nlfilter(hr_object(hi).hr.smooth_recording,[1 local_n],@mean);
    
    local_recording=hr_object(hi).hr.smooth_recording(local_n:end-local_n)-local_mean(local_n:end-local_n);
    local_times=hr_object(hi).hr.smooth_times(local_n:end-local_n);
    
    r1=nlfilter(local_recording,[1 41],@max);
    ppulses=find(local_recording==r1);
    
    r1=nlfilter(local_recording,[1 41],@min);
    npulses=find(local_recording==r1);
    
    %%
    ratio_test=1.35;
    
    phr=60./diff(local_times(ppulses));
    time_phr=(local_times(ppulses(2:end))+local_times(ppulses(1:end-1)))/2;
    
    nhr=60./diff(local_times(npulses));
    time_nhr=(local_times(npulses(2:end))+local_times(npulses(1:end-1)))/2;
    
    % full_hr=[phr nhr];
    % full_hr_time=[time_phr time_nhr];
    % [full_hr_time,use]=sort(full_hr_time);
    % full_hr=full_hr(use);
    %
    %
    % while 1==1;
    %     waste=find(full_hr(2:end)./full_hr(1:end-1)>ratio_test & full_hr(2:end)>mean(full_hr))+1;
    %     if isempty(waste), break; end
    %     full_hr(waste)=[]; full_hr_time(waste)=[];
    %     waste=find(full_hr(2:end)./full_hr(1:end-1)<(1./ratio_test) & full_hr(2:end)<mean(full_hr))+1;
    %     full_hr(waste)=[]; full_hr_time(waste)=[];
    % end
    waste=phr>200;
    phr(waste)=[]; time_phr(waste)=[];
    while 1==1;
        waste=find(phr(2:end)./phr(1:end-1)>ratio_test & phr(2:end)>mean(phr))+1;
        if isempty(waste), break; end
        phr(waste)=[]; time_phr(waste)=[];
        waste=find(phr(2:end)./phr(1:end-1)<(1./ratio_test) & phr(2:end)<mean(phr))+1;
        phr(waste)=[]; time_phr(waste)=[];
    end
    
    waste=nhr>200;
    nhr(waste)=[]; time_nhr(waste)=[];
    while 1==1;
        waste=find(nhr(2:end)./nhr(1:end-1)>ratio_test & nhr(2:end)>mean(nhr))+1;
        if isempty(waste), break; end
        nhr(waste)=[]; time_nhr(waste)=[];
        waste=find(nhr(2:end)./nhr(1:end-1)<(1./ratio_test) & nhr(2:end)<mean(nhr))+1;
        nhr(waste)=[]; time_nhr(waste)=[];
    end
    
    hr_object(hi).hr.ppulses=ppulses;
    hr_object(hi).hr.npulses=npulses;
    
    hr_object(hi).hr.phr=phr;
    hr_object(hi).hr.time_phr=time_phr;
    hr_object(hi).hr.nhr=nhr;
    hr_object(hi).hr.time_nhr=time_nhr;
    % hr_object.full_hr=full_hr;
    % hr_object.full_hr_time=full_hr_time;
    
    this_start_time=max(min(hr_object(hi).hr.time_phr),min(hr_object(hi).hr.time_nhr));
    this_end_time=min(max(hr_object(hi).hr.time_phr),max(hr_object(hi).hr.time_nhr));
    
    % this_start_time=min(hr_object.full_hr_time);
    % this_end_time=max(hr_object.full_hr_time);
    
    hr_object(hi).hr.samples_per_second=16;
    hr_object(hi).hr.hr_time_pts=this_start_time:1/hr_object(hi).hr.samples_per_second:this_end_time;
    
    p_signal=interp1(hr_object(hi).hr.time_phr,hr_object(hi).hr.phr,hr_object(hi).hr.hr_time_pts);
    n_signal=interp1(hr_object(hi).hr.time_nhr,hr_object(hi).hr.nhr,hr_object(hi).hr.hr_time_pts);
    hr_object(hi).hr.hr_signal=(p_signal+n_signal)/2;
    
    t_off=10*hr_object(hi).hr.samples_per_second;
    for ti=0:length(hr_object(hi).hr.hr_time_pts)-t_off
        hr_object(hi).hr.hrv(ti+t_off)=std(hr_object(hi).hr.hr_signal(ti+1:ti+t_off));
    end
    % hr_signal=interp1(hr_object.full_hr_time,hr_object.full_hr,hr_object.hr_time_pts);
    % hr_object.hr_signal=hr_signal;
if length(hr_object)>1,
    waitbar(hi./length(hr_object),h);
end
end
if length(hr_object)>1,
    close(h);
end

