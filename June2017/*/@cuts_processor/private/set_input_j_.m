function  obj = set_input_j_(obj,val,ind)
% set initial exchange energy for displaying and 
% subsequent fitting
%
obj.(['J',num2str(ind-6),'_']) = val;
if ~isempty(obj.init_fg_params_)
    for i=1:numel(obj.init_fg_params_)
        obj.init_fg_params_{i}(ind) = val;
    end
end

