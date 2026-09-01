function hkl = hkl_path_from_proj(data)
%hkl_path_from_proj -- Generate hkl path along 
%
% 
proj = data.proj;
u = proj.u(:);
x = 0.5*(data.p{1}(1:end-1)+data.p{1}(2:end));
hkl = u*(x-min(x));
end