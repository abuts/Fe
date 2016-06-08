function [wout,value]=read_log_combine(win,run_start,time_unit,time_unit_out)
% Combine an array of log spectra onto one time axis

unit_list={'seconds','minutes','hours','days'};
unit_to_day=[1/86400,1/1440,1/24,1];

time=[];
log_val=[];
for i=1:length(win)
    iunit = string_find(time_unit{i},unit_list);
    time=[time;run_start(i)+unit_to_day(iunit)*get(win(i),'x')];    % absolute number of days
    log_val=[log_val;get(win(i),'y')];
end

% Make output spectrum
% Get from start of log information
run_start = time(1);
run_start_char = datestr(run_start);
run_finish = time(end);
run_finish_char = datestr(run_finish);

% create output workspace
run_duration = round(86400*(run_finish - run_start));
time = 86400*(time-time(1));
iunit = string_find(time_unit_out,{'seconds','minutes','hours','days'});
if iunit==4 || (iunit<1 && time(end)>200*3600)    % if more than 200 hours long, express time in days
    time = time/86400;
    duration = num2str(run_duration/3600, '%6.2f');
    xunit= 'days';
    short_xunit= 'days';
elseif iunit==3 || (iunit<1 && time(end)>3*3600)    % if more than three hours long, express time in hours
    time = time/3600;
    duration = num2str(run_duration/3600, '%6.2f');
    xunit= 'hours';
    short_xunit= 'hr';
elseif iunit==2 || (iunit<1 && time(end)>5*60)    % if more than five minutes long, express time in minutes
    time = time/60;
    duration = num2str(run_duration/60, '%6.2f');
    xunit= 'minutes';
    short_xunit= 'min';
else
    duration = num2str(run_duration);
    xunit= 'seconds';
    short_xunit= 'sec';
end

title=get(win(1),'title');
title= {title{1},['Log file date: ',run_start_char,' to ',run_finish_char,'   Duration: ',duration,' ',short_xunit]};
xlab=get(win(1),'xlab');
ylab=get(win(1),'ylab');
distribution = 0;
wout=spectrum(time,log_val,zeros(length(log_val),1),title,xlab,ylab,xunit,distribution);

if length(time)>1
    value.average= mean(log_val);
    value.median = median(log_val);
    value.std_dev= std(log_val,1);
    value.minimum= min(log_val);
    value.maximum= max(log_val);
end
