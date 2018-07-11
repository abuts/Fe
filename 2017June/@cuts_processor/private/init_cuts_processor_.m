function obj = init_cuts_processor_(obj,varargin)
% Cuts processor's non-emtpy constructor

if ischar(varargin{1}) % initialized from previous fit and en-cuts files
    fit_summary_file = varargin{1};
    if ~(exist(fit_summary_file,'file')==2 || exist([fit_summary_file,'.mat'],'file')==2)
        error('CUTS_PROCESSOR:invalid_arguments',...
            'file %s with initial fitting parameters does not exist',fit_summary_file);
    end
    
    obj = init_from_en_cuts(obj,fit_summary_file);
    obj.init_fg_params_ = obj.fitpar.p;
    obj.init_bg_params_ = obj.fitpar.bp;
    obj.param_binds_    = obj.build_cuts_binding();
    
else % initialize from bragg name and data file id
    bragg_list = varargin{1};
    file_list = varargin{2};
    if numel(varargin) > 2
        e_min  = varargin{3};
        e_max  =  varargin{4};
        
    else
        e_min  = -inf;
        e_max  = inf;
    end
    
    
    [obj,filenames,file_directions,missing_files] = obj.find_initial_cuts(bragg_list,file_list);
    if ~isempty(missing_files)
        disp('**** Missing files: ');
        disp(missing_files);
        warning('CUTS_PROCESSOR:invalid_arguments','some initial direction-cut files are missing')
    end
    % init fitting and define the cuts which should be considered
    % equivalent e.g. have the same fitting parameters.
    [obj,obj.init_fg_params_,obj.init_bg_params_,obj.param_binds_,emin_real,emax_real] = ...
        obj.init_fitting(filenames,file_directions,e_min,e_max);
    obj.e_range = [emin_real,emax_real];
    
end

