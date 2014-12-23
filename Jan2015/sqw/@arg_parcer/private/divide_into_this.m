function   [this_keyval,rest]= divide_into_this(this,varargin)
% function divides the input cell array in the form 
%{'key',value,'key',value,'key','','something',something}
% into 2 cellarrays {} this_keyval == {'key',value,'key',value,'key',''}
% and rest == {'something',something}


argi = varargin{:};
nargi = numel(argi);

key_ind = 1:2:numel(nargi);
val_ind = 2:2:numel(nargi);

all_keys = argi(prov_key_ind);

this_keys_tag = ismember(all_keys,this.data_fields);

this_key_ind = key_ind(this_keys_tag);
this_val_ind = val_ind(this_key_tag);


n_keys = numel(this_key_ind);
this_keyval = cell(1,n_keys*2);

sel_keys_ind = 1:2:2*n_keys;
sel_val_ind = 2:2:2*n_keys;
this_keyval(sel_keys_ind)= argi(this_key_ind);
this_keyval(sel_val_ind )= argi(this_val_ind);

rest = argi(~this_key_tag);
