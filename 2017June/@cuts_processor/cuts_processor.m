classdef cuts_processor
    % The class helper to take range of cuts and fit these cuts using
    % Tobyfit and 
    properties
        % the initial (guess) exchange parameters to start fitting
        
        J0_err = 0
        J1_err = 0
        J2_err = 0
        J3_err = 0
        J4_err = 0
        % array of cuts to fit.
        % The map with keys defined by cut energy and cut direction and values
        % equal to cuts numbers (from  the cut list above) which are equivalent
        % for the key energy and the key direction.
        equal_cuts_map;
        fitpar =[];
        fits_list=[];
        %
        bragg_list;
        file_list;
        % 10x1 array defines what fit parameters to fix where fit
        % parameters have a form:
        % [ff, T, gamma, Seff, gap, J0, J1, J2, J3, J4];
        fit_par_range = [0,0,1,1,0,1,1,1,0,0]
        
        e_range =[-inf,inf];
    end
    
    properties(Dependent)
        J0 %= 25.29;
        J1 %= 13.93;
        J2 %= -3.01 ;
        J3 %= 0;
        J4 %= 0;
        % file used as source of cut data
        source_file
        % list of various cuts to fit;
        cuts_list
        % Map of various directions, corresponding to various bragg peaks
        cuts_dir_list
        % string, used in resulting file name to specify how many free
        % parameters were used
        fitted_par_id;
        %  if all data ready for running the fit
        fit_initated;
        % folder + one level down Br subfolder where to look for input data
        % and store results
        working_dir;
    end
    properties(Access=protected)
        cuts_dir_list_
        rood_data_folder_ = pwd;
        source_cuts_fname_ = @rez_name;
        source_file_ = [];
        cuts_list_ = [];
        init_fg_params_ = [];
        init_bg_params_ = [];
        param_binds_ = [];
        J0_ = 25.29;
        J1_ = 13.93;
        J2_ = -3.01 ;
        J3_ =0;
        J4_ =0;
    end
    methods(Static)
        name= ind_name(ind);
    end
    
    methods
        function obj=cuts_processor(varargin)
            obj = build_cuts_map_(obj);
            obj.rood_data_folder_ = pwd;
            
            obj.equal_cuts_map = containers.Map();
            if nargin>0
                obj = init_cuts_processor_(obj,varargin{:});
            end
        end
        % build list of initial cut files for multifitting and check if the files with these names are present
        % The initial
        [obj,filenames,file_directions,missing_files] = obj.find_initial_cuts(bragg_list,file_list)
        %
        % load initial cut files and extract initial parameters for multifit
        [obj,init_fg_params,init_bg_params,param_binds,emin_real,emax_real] = ...
            init_fitting(obj,filenames,file_directions,e_min,e_max)
        % initiate process cuts object from fits summary file;
        obj= init_from_en_cuts(obj,fit_summary_file)
        % build cuts binding using cut bind map;
        bind_map = build_cuts_binding(obj);
        % extract J from fitpars and set them up as J in class
        % extract other fitting parameters for convenient processing
        [obj,fitpar,fiterr,capt] = setup_j(obj,fp_arr1);
        %
        obj= refit_sw_findJ(obj,bragg_list,file_list,e_min,e_max)
        %
        [res100,res110,re111]=plot_sw_par(obj,emin_real,emax_real)
        %
        % View sequence of cuts correspondent to energy transfer and direction provided
        % as input and return the structure, usually stored with cut sequence
        cut_struct = plot_Cuts(obj,energy,direction,varargin)
        %
        function map = get.cuts_dir_list(obj)
            map = obj.cuts_dir_list_;
        end
        %
        function id = get.fitted_par_id(obj)
            n_fits = sum(obj.fit_par_range);
            id = sprintf('J0-%d',n_fits-3);
        end
        %
        function fn = get.source_file(obj)
            fn = obj.source_file_;
        end
        %
        function cl = get.cuts_list(obj)
            cl  = obj.cuts_list_;
        end
        function is = get.fit_initated(obj)
            if isempty(obj.cuts_list_) && isempty(obj.init_fg_params_)
                is = false;
            else
                is = true;
            end
        end
        function j = get.J0(obj)
            j = obj.J0_;
        end
        function j = get.J1(obj)
            j = obj.J1_;
        end
        function j = get.J2(obj)
            j = obj.J2_;
        end
        function j = get.J3(obj)
            j = obj.J3_;
        end
        function j = get.J4(obj)
            j = obj.J4_;
        end
        function obj = set.J0(obj,val)
            obj = set_input_j_(obj,val,6);
        end
        function obj = set.J1(obj,val)
            obj = set_input_j_(obj,val,7);
        end
        function obj = set.J2(obj,val)
            obj = set_input_j_(obj,val,8);
        end
        function obj = set.J3(obj,val)
            obj = set_input_j_(obj,val,9);
        end
        function obj = set.J4(obj,val)
            obj = set_input_j_(obj,val,10);
        end      
        function dir = get.working_dir(obj)
            dir = obj.rood_data_folder_;
        end
    end
end
