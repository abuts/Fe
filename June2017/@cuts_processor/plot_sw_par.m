function  [ixs,ixg]= plot_sw_par(obj,emin,emax)
% Method to plot the life time and intensity of fitted sw
%
% returns 2 of 3-element arrays of IX_dataset_1d objects containing
% lifetimes and intensities.
%
if ~exist('emin_real','var')
    emin = obj.e_range(1);
    emax = obj.e_range(2);
end

[en100,S100,S100_err,G100,G100_err] = obj.extract_fitpar([1,0,0],emin:5:emax);
[en110,S110,S110_err,G110,G110_err] = obj.extract_fitpar([1,1,0],emin:5:emax);
[en111,S111,S111_err,G111,G111_err] = obj.extract_fitpar([1,1,1],emin:5:emax);
%-------------------------------------------------------------
s_max = max([S100;S110;S111]);
g_max = max([G100;G110;G111]);

brn = cellfun(@(br)(['[',num2str(br(1)),num2str(br(2)),num2str(br(3)),'];']),...
    obj.bragg_list,'UniformOutput',false);
name = [brn{:}];
[~,~,~,capt] = obj.setup_j;
file_n = [obj.file_list{:}];
name = sprintf('%s\n %s; %s',name,file_n(4:end),capt);
ixs = repmat(IX_dataset_1d,3,1);
ixg = repmat(IX_dataset_1d,3,1);
[ixs(1),ixg(1)] = build_ds(en100,S100,S100_err,G100,G100_err,name);
[ixs(2),ixg(2)] = build_ds(en110,S110,S110_err,G110,G110_err,name);
[ixs(3),ixg(3)] = build_ds(en111,S111,S111_err,G111,G111_err,name);


colors = {'r','g','b','k'};
acolor(colors{1});
aline('-')
[~,~,li1] = dd(ixs(1));
plots = repmat(li1(1),3,1);
for i=2:3
    acolor(colors{i});
    [~,~,li1]=pd(ixs(i));
    plots(i) = li1(1);
end
ymax = max(2.5,s_max);
ly(0,ymax)
legend(plots,'<100>','<110>','<111>');
keep_figure

%
%-------------------------------------------------------------
acolor(colors{1});
[~,~,li1]  = dd(ixg(1));
plots(1) = li1(1);
for i=2:3
    acolor(colors{i});
    [~,~,li1]=pd(ixg(i));
    plots(i) = li1(1);
end
ymax = max(80,g_max);
ly(0,ymax)

legend(plots,'<100>','<110>','<111>');
keep_figure

%
% res100 = [en100',S100,S100_err,G100,G100_err];
% res110 = [en110',S110,S110_err,G110,G110_err];
% res111 = [en111',S111,S111_err,G111,G111_err];

function [ixd_s,ixd_g]=build_ds(en,s,s_err,g,g_err,name)
valid = ~isnan(en);
ixd_s = IX_dataset_1d(en(valid),s(valid),s_err(valid),...
    ['Intensity scale for peak(s) ',name],IX_axis('Energy transfer','mEv'),...
    IX_axis('intensity',''),false);

ixd_g = IX_dataset_1d(en(valid),g(valid),g_err(valid),...
    ['Inverse lifetime for peaks: ',name],IX_axis('Energy transfer','mEv'),...
    IX_axis('Decay','mEv'),false);



