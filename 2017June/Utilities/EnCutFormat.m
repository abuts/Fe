classdef EnCutFormat
    % Class to support various Energy Cuts storage Formas
    
    
    properties
        
    end
    
    methods(Static)
        function en_list = get_en_list(input_struct)
            en_list = input_struct.es_valid;
        end
        function fit_param= get_fit_par(input_struct)
            %
            if isfield('input_struct','fit_param')
                fit_param = input_struct.fit_param;
            else
                fit_param = input_struct.fp_arr1;
            end
            
        end
        function cut_list = get_cut_list(stor)            
            if isfield('stor','cuts_list')
                cut_list = stor.cuts_list;
            else
                cut_list = stor.cut_list;
            end
        end
    end
    
end
