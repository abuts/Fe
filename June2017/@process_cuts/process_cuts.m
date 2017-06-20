classdef process_cuts
    %
    properties
        % the initial (guess) exchange parameters to start fitting
        J0 = 25.29;
        J1 = 13.93;
        J2 = -3.01 ;
        J3 =0;
        J4 =0;
        J0_err = 0
        J1_err = 0
        J2_err = 0
        J3_err = 0
        J4_err = 0
        % array of cuts to fit.
        cuts_list=[];
        % The map with keys defined by cut energy and cut direction and values
        % equal to cuts numbers (from  the cut list above) which are equivalent
        % for the key energy and the key direction.
        equal_cuts_map;
        fitpar =[];
        fits_list=[];
        %
        bragg_list;
        file_list;
        fitted_par_id ='J0-2';
        e_range =[-inf,inf];
    end
    
    properties(Dependent)
        % Map of various directions, corresponding to various bragg peaks
        cuts_dir_list
    end
    properties(Access=private)
        cuts_dir_list_
        rood_data_folder_ = fileparts(which('init_fe2017.m'));
        source_cuts_fname_ = @rez_name;
    end
    methods(Static)
        name= ind_name(ind);
    end
    
    methods
        function obj=process_cuts(varargin)
            obj = build_cuts_map_(obj);
            obj.equal_cuts_map = containers.Map();
            if nargin>1
                bragg_list = varargin{1};
                file_list = varargin{2};
                obj = obj.find_initial_cuts(bragg_list,file_list);
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
        %
        obj = setup_j(obj,fp_arr1);
        %
        obj= refit_sw_findJ(obj,bragg_list,file_list,e_min,e_max)
        %
        [res100,res110,re111]=extract_and_plot_sw_par(obj,emin_real,emax_real)
        %
        % View sequence of cuts correspondent to energy transfer and direction provided
        % as input and return the structure, usually stored with cut sequence        
        cut_struct = view_Cuts(obj,energy,direction,varargin)
        %
        function map = get.cuts_dir_list(obj)
            map = obj.cuts_dir_list_;
        end
        
        
    end
end
