classdef cuts_le_processor < cuts_processor
    % The class helper to take range of cuts and fit these cuts using
    % Tobyfit. 
    % Unlike the parent, this class assumes that the range of cuts at given energy has the same J and fits only 
    % gamma and SW amplitude, assuming that the same direction and energy transfer cuts have the same J and Gamma&  S
    % while different directions have common J only.
    %
    % Only refit_sw_findJ method is overloaded by this class as the binding between different parameters values
    % occurs only there. 
    %
    properties
    end
    
    properties(Dependent)
    end
    properties(Access=private)
    end
    methods(Static)
        name= ind_name(ind);
    end
    
    methods
        function obj=cuts_le_processor(varargin)
            obj = obj@cuts_processor(varargin{:});
            obj.fit_par_range = [0,0,1,1,0,1,0,0,0,0];
            obj.J1 = 0;
            obj.J2 = 0;
        end
        % Interface
        %
        obj= refit_sw_findJ(obj,bragg_list,file_list,e_min,e_max)        
    end
end
