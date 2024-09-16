function [w, value, mess] = read_log (varargin)
% Read log file and return plot as function of time, and average value
%
% Syntax:
%   >> w = read_log (irun, parameter_name)
%   >> [w, val] = read_log (irun, parameter_name)
%
% Input:
% ------
%   irun    Run number, or array of run numbers
%   name    Name of logged parameter to be read e.g. 't_head
%
% Optional arguments (can appear in any order): 
%   unit    Time unit for measurement 's', 'm', 'h', 'd' for seconds,
%          minutes, hours, days [default depends on duration of logged period]
%
%   origin 'run' for time origin to be start of run [default]
%          'log' for origin to be log file start
%          'combine' for single workspace output
%
% Output:
% -------
%   w       Spectrum containing logged parameter as a function of time.
%          If array of run numbers, then output is an array of spectra
%   value   Structure with fields val.average, val.median, val.std_dev,
%          val.minimum, val.maximum
%
% Optional output argument:
%   mess    If read_log encounters an error e.g. unable to find log file or
%          no values logged, then w, val are returned as empty, and mess
%          is filled with the error message.
%           if mess is not given, then error is fatal

if nargout==3; fail_on_error=false; else fail_on_error=true; end

% Check input arguments
if nargin < 2
    w = [];
    value = [];
    mess = 'ERROR: Missing parameters to read_log';
    if fail_on_error; error(mess); else return; end
end
run_log = varargin{1};
log_parameter = varargin{2};

unit_list = {'seconds','minutes','hours','days'};
origin_list = {'run', 'log', 'combine'};

if nargin>=3
    origin=strmatch(lower(varargin{3}),origin_list);
    unit=strmatch(lower(varargin{3}),unit_list);
    if nargin==4
        origin=[origin,strmatch(lower(varargin{4}),origin_list)];
        unit=[unit,strmatch(lower(varargin{4}),unit_list)];
    end

    if (length(origin)+length(unit)~=nargin-2) ||...    % must equal number of arguments
            length(origin)>1 || length(unit)>1
        w = [];
        value = [];
        mess = 'Check input options';
        if fail_on_error; error(mess); else return; end
    end

    if length(origin)==1
        time_origin = origin_list(origin);
    else
        time_origin = 'run';
    end

    if length(unit)==1
        time_unit = unit_list(unit);
    else
        time_unit = '';
    end
else
    time_origin = 'run';
    time_unit = '';
end

% Now read log files
nrun=numel(run_log);
ok=true(1,nrun);
for i=1:length(run_log)
    [w(i), value(i), run_start(i), xunit{i}, mess] = read_log_single_file (run_log(i), log_parameter, time_origin, time_unit);
    if ~isempty(mess)
        disp(mess)
        ok(i)=false;
    end
end
    
% Treat case of combine as a special case
if strcmpi(time_origin,'combine')
    if any(ok)
        [w,value]=read_log_combine(w(ok),run_start(ok),xunit(ok),time_unit);
    else
        w = [];
        value = [];
        mess = 'ERROR: No log files read';
        if fail_on_error; error(mess); else return; end
    end
end



