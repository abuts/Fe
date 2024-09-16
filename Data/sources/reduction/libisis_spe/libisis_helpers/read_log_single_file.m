function [w, value, run_start, xunit, mess] = read_log_single_file (run_log, log_parameter, time_origin, time_units)
% READ_LOG reads a log file for a given run number and parameter name and
%          returns 
%          (i)the value of the logged variable as a function of time
%          from the beginning of the run, in a spectrum object,
%          (ii) the average, median, standard deviation, minimum and maximum
%          values of the logged parameter during the run
%
% Notes:
%          The path on which the log file is searched for is the one set with
%          the set_disk, set_dir, set_inst, set_ext and ass commands.
%
% Syntax:
%   >> w = read_log (irun, parameter_name)
%   >> [w, val] = read_log (irun, parameter_name)
%
% Input:
% ------
%   irun    Run number, or array of run numbers
%
%   name    Name of logged parameter to be read
%          e.g. 't_head', 'tankpressure1'
%
% Output:
% -------
%   w       Spectrum containing logged parameter as a function of time from the
%          start of the run
%   value   Structure with fields:
%          val.average, val.median, val.std_dev, val.minimum, val.maximum
%
% --- Optional input parameter:
%
%   The spectrum is returned in elasped seconds, minutes or hours according to
%   how long the run was. To overide the default choice enter the units as the
%   final parameter ('s','m','h')
% e.g.
%   >> w = read_log (7045, 't_head', 's')
%
%
% --- Optional output parameter for silent return from error
%
%   >> w = [w, val, mess] = read_log (irun...)
%
%   If read_log encounters an error e.g. unable to find log file, no values logged
%   then w, val are returned as empty, and mess is filled with the error message.
%   If values were logged, but not between the start and end times of the run, then
%   val is returned as the last logged value before the run began, and a warning
%   message is placed in mess.
%

global genie_file genie_disk genie_directory genie_instrument genie_run genie_run_char genie_extension genie_dae genie_crpt

w = spectrum(NaN,NaN);
value.average= NaN;
value.median = NaN;
value.std_dev= NaN;
value.minimum= NaN;
value.maximum= NaN;
run_start=0;
xunit='';
mess = '';

% Get run number as a character string
if run_log < 1
    mess = 'Run number must be in range 1 - 99999';
    return
elseif run_log < 10
    run_log_char=strcat('0000',sprintf('%.0f',round(run_log)));
elseif run_log < 100
    run_log_char=strcat('000',sprintf('%.0f',round(run_log)));
elseif run_log < 1000
    run_log_char=strcat('00',sprintf('%.0f',round(run_log)));
elseif run_log < 10000
    run_log_char=strcat('0',sprintf('%.0f',round(run_log)));
elseif run_log < 100000
    run_log_char=sprintf('%.0f',round(run_log));
else
    mess = 'Run number must be in range 1 - 99999';
    return
end

% Read log file
if isa(log_parameter,'char') && size(log_parameter,1)==1 && ~isempty(log_parameter)
    % find logfile. Note there is more than one possible format to check !
    %inst_full=inst_name_full(genie_instrument);
    inst_full=get(homer_config,'instrument_name');    
    if isempty(inst_full)
        mess = 'Unrecognised instrument for reading log files';
        return
    end
    genie_instrument=upper(inst_full(1:3));
    
    file=[genie_instrument,run_log_char,'_',log_parameter,'.txt'];    
    %file=[pathname(genie_disk,genie_directory),genie_instrument,run_log_char,'_',log_parameter,'.txt'];
    file_translated=file;
    istatus=exist(file_translated,'file'); % check if file exists
    if (istatus ~= 2)
         mess = ['Cannot find log file for parameter ',log_parameter ,' for run ',num2str(genie_run),'. Check genie search path'];
         return
    end
    
    % open log file, read entries
    fid = fopen(file_translated);
    istart=ftell(fid);  % starting point of file
    tline = fgets(fid);
    if isnumeric(tline) % must be an error or empty file
        mess = ['ERROR: Empty file or error reading from ',file_translated];
        return
    end
    
    % do some tests on tline to check format is OK
    time = tline(1:19);
    if time(3:3)=='/'       % assume datetime format dd/mm/yyyy HH:MM:SS
        format = 'dd/mm/yyyy HH:MM:SS';
    elseif time(5:5)=='-' && time(11:11)==' '   % assume datetime format yyyy-mm-dd HH:MM:SS
        format = 'yyyy-mm-dd HH:MM:SS';
    elseif time(5:5)=='-' && time(11:11)=='T'   % assume datetime format yyyy-mm-ddTHH:MM:SS
        format = 'yyyy-mm-ddTHH:MM:SS';
    else
        mess = ['ERROR: Unrecognised date-time format in ',file_translated];
        return
    end
    
    % Read in whole of log file into two cell arrays, one of time, one of log value
    fseek(fid,istart,'bof'); % step back one line
    a = textscan(fid, '%19s%s');
    fclose(fid);

    % Get origin of time
    if strcmpi(time_origin,'run')
        % Get from run start:
        if isa(run_log,'numeric') && ~isempty(run_log)
            run_store = genie_run;  % store currently assigned run number
            run_char_store = genie_run_char;
            mess = ass(run_log);
            if ~isempty(mess)
                if ~isempty(run_store)
                    ass(run_store)  % reset original run assignment, if assigned
                end
                return
            else
                run_start_char =[gget('start_date'),' ',gget('start_time')];
                run_finish_char=[gget('end_date'),' ',gget('end_time')];
                run_start=datenum(run_start_char);     % time is to nearest second only
                run_finish=datenum(run_finish_char);    % time is to nearest second only
                if ~isempty(run_char_store)
                    ass(run_store)  % reset original run assignment, if assigned
                end
            end
        else
            mess = 'ERROR: First argument must be run number';
            return
        end
    elseif strcmpi(time_origin,'log')||strcmpi(time_origin,'combine')
        % Get from start of log information
        run_start = datenum(a{1}(1),format);
        run_start_char = datestr(run_start);
        run_finish = datenum(a{1}(end),format);
        run_finish_char = datestr(run_finish);
    end
    
    % log files for PC-ICP store times to nearest second only;
    time = round(86400*(datenum(a{1},format)-run_start));  % elapsed time from start of run in seconds        
    log_val = str2num(char(a{2}));
    
    % create output workspace
    run_duration = round(86400*(run_finish - run_start));
    iunit = string_find(time_units,{'seconds','minutes','hours','days'});
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
    if strcmpi(time_origin,'run')
        title= {avoidtex(file_translated),['Run date: ',run_start_char,' to ',run_finish_char,'   Duration: ',duration,' ',short_xunit]}; 
        xlab = 'Elapsed time from start of run';
    elseif strcmpi(time_origin,'log')||strcmpi(time_origin,'combine')
        title= {avoidtex(file_translated),['Log file date: ',run_start_char,' to ',run_finish_char,'   Duration: ',duration,' ',short_xunit]}; 
        xlab = 'Elapsed time from start of log file';
    end
    ylab = avoidtex(log_parameter);
    distribution = 0;
    w=spectrum(time,log_val,zeros(length(log_val),1),title,xlab,ylab,xunit,distribution);
    
    % Calculate average temperature, st. deviation etc.
    if strcmpi(time_origin,'run')
        % if run origin, then look for log values within the run
        ind=find(time>0&time<run_duration);
        if length(ind)<1
            ind = find(time<0);
            if length(ind)<1
                mess='ERROR: No values logged before or during run';
                return
            else
                display(['Warning: No values logged during run; using last value before run started - run ',num2str(run_log)]);
                value.average = log_val(ind(end));
                value.median  = value.average;
                value.std_dev = 0;
                value.minimum = value.average;
                value.maximum = value.average;
            end
        else
            value.average= mean(log_val(ind));
            value.median = median(log_val(ind));
            value.std_dev= std(log_val(ind),1);
            value.minimum= min(log_val(ind));
            value.maximum= max(log_val(ind));
        end
    else
        if length(time)>1
            value.average= mean(log_val);
            value.median = median(log_val);
            value.std_dev= std(log_val,1);
            value.minimum= min(log_val);
            value.maximum= max(log_val);
        end
    end
    
end
