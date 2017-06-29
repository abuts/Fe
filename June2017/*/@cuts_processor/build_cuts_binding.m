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
        loc_binds = cell(2*(numel(binding)-1),1);
        n_func = binding{1};
        for j=1:numel(binding)-1
            loc_binds{2*j-1} = {[3,binding{j+1}],[3,n_func],1};
            loc_binds{2*j} = {[4,binding{j+1}],[4,n_func],1};
        end
        param_binds = {param_binds{:},loc_binds{:}};
        
    end
end


