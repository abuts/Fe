classdef cuts_le_processor < cuts_processor
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
