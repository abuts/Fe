function  stor=view_EnCuts(cut_fname)
% View group of cuts, 
%   Detailed explanation goes here
if isstruct(cut_fname)
    stor = fut_fname;
else
    stor = load(cut_fname);
end

n_cuts = numel(stor.cut_list);
disp('energies:')
disp(stor.es_valid');
cuts_fitpar = stor.fp_arr1;
for j=1:n_cuts
    acolor('k');
    plot(stor.cut_list(j));
    acolor('r');
    pd(stor.w1D_arr1_tf(j));
    fprintf(' cut N: %d/%d\n',j,n_cuts);
    fprintf(' par: %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f\n',cuts_fitpar.p{j}(3:10));
    fprintf(' err: %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f\n',cuts_fitpar.sig{j}(3:10));
    pause(1)
end


