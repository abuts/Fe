function [ok,mess] = check_correct_binding_(cut_list,bind_map,func_id)
% check if cuts are bound to appropriate energy 

equal_cuts_nums = bind_map(func_id);
n_binds =numel(equal_cuts_nums);

f_en =@(x)(0.5*(x.data.iint(2,3)+x.data.iint(1,3)));
ind=1:n_binds;
cut_en = arrayfun(@(ind)(f_en(cut_list(equal_cuts_nums{ind}))),ind);

if any(cut_en ~=cut_en(1))
    ok = false;
    mess = ['different cut energies:',num2str(cut_en),' for cuts: ',func_id];
else
    ok = true;
    mess = [];
end






