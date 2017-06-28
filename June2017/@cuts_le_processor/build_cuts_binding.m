function   param_binds = build_cuts_binding(obj)


keys = obj.equal_cuts_map.keys;
param_binds = {};
for i=1:numel(keys)
    theKey = keys{i};
    binding = obj.equal_cuts_map(theKey);
    if numel(binding) > 1
        [ok,mess] = check_correct_binding_(obj.cuts_list,obj.equal_cuts_map,theKey);
        if ~ok
            error('REFIT_SW:runtime_error',mess);
        end
        loc_binds = cell(6*(numel(binding)-1),1);
        n_func = binding{1};
        for j=1:numel(binding)-1
            loc_binds{6*j-5} = {[3,binding{j+1}],[3,n_func],1};
            loc_binds{6*j-4} = {[4,binding{j+1}],[4,n_func],1};
            
            loc_binds{6*j-3} = {[6,binding{j+1}],[6,n_func],1};
            loc_binds{6*j-2}   = {[7,binding{j+1}],[7,n_func],1};
            loc_binds{6*j-1} = {[8,binding{j+1}],[8,n_func],1};
            loc_binds{6*j-0}   = {[9,binding{j+1}],[9,n_func],1};
            
        end
        param_binds = {param_binds{:},loc_binds{:}};
        
    end
end


