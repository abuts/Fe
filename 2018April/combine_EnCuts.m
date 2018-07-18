% read EnCuts for a specific direction combine them into single
% symmetrized cut, fit this cut and extract fit parameters for plotting and analysis
%
en = 100;
G = NaN*zeros(numel(en),1);
J = NaN*zeros(numel(en),1);
S = NaN*zeros(numel(en),1);
Gs = NaN*zeros(numel(en),1);
Js = NaN*zeros(numel(en),1);
Ss = NaN*zeros(numel(en),1);
source_dir = 'D:\Data\Fe\2017June\J0var_All_8Braggs';
Ei = 200;
dir = '100';

for i=1:numel(en)
    fname = sprintf('EnCuts_Fe_ei%d_dE%d_dir_!%s!.mat',Ei,en(i),dir);
    
    file = fullfile(source_dir,fname);
            fprintf(' Energy: %d\n',en(i));

    try
        cb = refit_EnCuts(file,[],'-comb');
        cb.save(fname); % save in current directory
        G(i) = cb.fit_param.p(3);
        S(i) = cb.fit_param.p(4);
        J(i) = cb.fit_param.p(6);
        Gs(i) = cb.fit_param.sig(3);
        Ss(i) = cb.fit_param.sig(4);
        Js(i) = cb.fit_param.sig(6);
        cb.plot();
    catch ME
        warning('Can not refit or combune cuts for energy %d, Reason %s',en(i),ME.message)
    end
end
valid = ~isnan(J);
en = en(valid);
J = J(valid);
Js =Js(valid);
G = G(valid);
Gs =Gs(valid);
S = S(valid);
Ss =Ss(valid);

Jd = IX_dataset_1d(en,J,Js);
Jd.title = sprintf(' J0 vs Energy, direction <%s>',dir);
Jd.x_axis = 'En (mEv)';
Jd.s_axis = sprintf('J0_{<%s>} (mEv)',dir);

Sd = IX_dataset_1d(en,S,Ss);
Sd.title = sprintf(' S vs Energy, direction <%s>',dir);
Sd.x_axis = 'En (mEv)';
Sd.s_axis ='S_{<100>}';

Gd = IX_dataset_1d(en,G,Gs);
Gd.title = [' \gamma',sprintf(' vs Energy, direction <%s>',dir)];
Gd.x_axis = 'En (mEv)';
Gd.s_axis = [' \gamma_',sprintf('{<%s>} (mEv)',dir)];

fout_name = sprintf('Fitpar_Fe_Ei%d_dir%s',Ei,dir);
save(fout_name,'Jd','Sd','Gd');
