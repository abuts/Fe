function [cell_array]=conv_to_cellarray(this,varargin)
% The method convers the input arguments in various forms accepted by
% the class into the cell array in the form
% {'fieldName',value,'fieldName,'value','fieldName','','otherdata1','otherdata2','otherdata3'}
% where fieldName are symbolic fiedls, which are defined during this object
% construction and 


if nargin==0
    cell_array={};
    return;
end
% the structure provided. 
if isstruct(varargin{1})
    if(nargin>1)
        error('ARG_PARCER:invalid_arguments',' A structure should be the only argument provided');
    end
    cell_array = struct2cell(varargin{1});            
    
    return;
end
if ~iscell(varargin{:})
     error('ARG_PARCER:invalid_arguments',' The arguments of this function should be a structure or a cell array');    
end
argi = varargin{:};

% let's check if the input data already have the form
% 'key',value,'key',value
if rem(numel(varargin{:}),2)==0 %may be
    prov_key_ind = 1:2:numel(argi);
    prov_keys = argi(prov_key_ind);
    if all(cellfun(@(x) ischar(x)&&isletter(x(1)),prov_keys)) % all may be keys        
        membersof_this=ismember(this.data_fields,prov_keys);        
        if all(membersof_this) % yes, all done
            cell_array = argi;
            return
        else % add the keys which are not yet members of input string
            empty_keys=this.data_fields(~membersof_this);
            n_empty = numel(empty_keys);
            add_cells = cell(2*n_empty,1);
            add_cells(1:2:2*n_empty)=empty_keys(:);
            cell_array= [argi,add_cells];
            return
        end            
    end
end   %no, only values provided. 


% the data are in the positional form. Lets convert them into
% {'key',value,'key',value,rest} or % {'key',value,'key',value,'key','','key',''}
n_fields   = numel(this.data_fields);
n_values   = numel(argi);

key_indexes = 1:2:2*n_fields;
if n_fields>=n_values
    value_indexes=2:2:(2*n_values+1);    
    cell_array = cell(1,2*n_fields);
    cell_array(key_indexes)=this.data_fields(1:n_fields);
    cell_array(value_indexes)=argi(:);
else
    value_indexes=2:2:(2*n_fields+1);        
    n_data=2*n_fields;
    d_length = n_data+n_values-n_fields;
    cell_array = cell(1,d_length);   
    cell_array(key_indexes)=this.data_fields(1:n_fields);    
    cell_array(value_indexes)=argi(1:n_fields);
    cell_array(n_data+1:d_length)=argi(n_fields+1:n_values);
end


