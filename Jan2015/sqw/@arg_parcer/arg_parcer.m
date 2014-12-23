classdef arg_parcer
    %The class to help parcing input arguments of a constructor, 
    %provided in the different form
    
    properties
        % the cell array of the fields, which need parcing.
        data_fields={};
    end
    
    methods
        function parcer =arg_parcer(data)
        % the constructor builds the parcer class, which contains the cell
        % array of fields, which need to be assined.
            if isstruct(data)
                parcer.data_fields = fieldnames(data);
            elseif iscell(data)
                 field_map = cellfun(@(x) ischar(x)&&isletter(x(1)),data);
                 parcer.data_fields = data(field_map);                
            else
                error('ARG_PARCER:invalid_argument',' the input argument for the constructor should be either structure, or cell array of fields');
            end
        end
        
        function cell_array = to_cell_array(this,varargin)
            cell_array = conv_to_cellarray(this,varargin);
        end
        function [this_keyval,rest]=divide_this_and_other(this,varargin)
            [this_keyval,rest]= divide_into_this(this,varargin);
        end
        
        function this=subsasgn(this,index,varargin)
        % the function introduced for compartibility with matlab 2008
        % which protects the properties of the class from direct assignment
        % in the later Matlab
            error('ARG_PARCER:invalid_argument',' it is not allowed to assign values to this class fields'); 
        end
    end
    
end

