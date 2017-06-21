function in = ind_name(ind)
% return name of an index as string with m in front if the number is less
% than 0
%
if ind<0
    in = ['m',num2str(abs(ind))];
else
    in = num2str(ind);
end
