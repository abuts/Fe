function [cuts_list,fits_list,fit_par] = view_dirCut(dir_cut)
%   Detailed explanation goes here


stor = load(dir_cut);

en = stor.es_valid;
eMin = min(en);
eMax = max(en);
e_axis = eMin:5:eMax;
n_en = numel(eMax );
S = ones(n_en,1)*nan;
S_err = ones(n_en,1)*nan;
gamma = ones(n_en,1)*nan;
gamma_err = ones(n_en,1)*nan;

cuts_list = stor.cut_list;
en_real = arrayfun(@(x)(0.5*(x.data.iint(1,3)+x.data.iint(2,3))),cuts_list);
fit_par = stor.fp_arr1;
S_real = cellfun(@(x)(x(4)),fit_par.p);
S_err_real = cellfun(@(x)(x(4)),fit_par.sig);
gamma_real = cellfun(@(x)(x(3)),fit_par.p);
g_err_real = cellfun(@(x)(x(3)),fit_par.sig);


valid = ismember(e_axis,en_real);
S(valid) = S_real;
S_err(valid) = S_err_real;
gamma(valid) = gamma_real;
gamma_err(valid) = g_err_real;
%

br_name = ['[',num2str(stor.bragg),'];'];
dir_name = ['[',num2str(stor.cut_direction),'];'];

figure('Name',['Intensity scale for peak: ',br_name,' direction: ',dir_name]);
li1=errorbar(e_axis,S,S_err,'b');
ly 0 2.5
%
glob_par = fit_par.p{1};
glob_err = fit_par.sig{1};
J0 = glob_par(6);
J1 = glob_par(7);
J2 = glob_par(8);
J3 = glob_par(9);
J4 = glob_par(10);
dJ0 = glob_err(6);
dJ1 = glob_err(7);
dJ2 = glob_err(8);
dJ3 = glob_err(9);
dJ4 = glob_err(10);

leg = sprintf(['dE=%3f; dK=%3.2f;\n J0: %6.3f +/-%6.3f; J1: %6.3f +/-%6.3f;',...
    ' J2: %6.3f+/-%6.3f\n J3: %6.3f +/-%6.3f  J4: %6.3f +/-%6.3f\n'],...
    stor.dK,stor.dK,J0,dJ0,J1,dJ1,J2,dJ2,J3,dJ3,J4,dJ4);

legend(li1,leg);
figure('Name',['Inverse lifetime (meV) for peaks: ',br_name,' direction: ',dir_name]);
li2=errorbar(e_axis,gamma,gamma_err,'b');
legend(li2,leg);
fits_list = stor.w1D_arr1_tf;
n_cuts = numel(cuts_list);
for j=1:n_cuts
    acolor('k');
    plot(cuts_list(j));
    acolor('r');
    pl(fits_list(j));
    fprintf(' cut N: %d/%d\n',j,n_cuts);
    fprintf(' par: %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f\n',fit_par.p{j}(3:10));
    fprintf(' err: %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f\n',fit_par.sig{j}(3:10));
    pause(1)
end
