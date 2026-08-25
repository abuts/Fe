fpath = 'e:\SHARE\Fe\Data\analysis\06_fit_with_J0\sym4D_cutsAndFits';

ld110aEi200 = load(fullfile(fpath,'EnFit_Ei200ref001off110_1D_constFFCut_dirGH_dE10_fitSlopeDE.mat'));
ld200aEi200 = load(fullfile(fpath,'EnFit_Ei200Br110dir010_1D_dirGH_dE20_fitSlopeDE.mat'));

ld110aEi400 = load(fullfile(fpath,'EnFit_Ei400ref001off110_1D_constFFCut_dirGH_dE20_fitSlopeDE.mat'));
ld200aEi400 = load(fullfile(fpath,'EnFit_Ei400ref001off200_1D_constFFCut_dirGH_dE20_fitSlopeDE.mat'));


[S110a200,J110a200,GS110a200] = extract_fit_par(ld110aEi200.fit_resEi200.all_fit_par);
%[S110b200,J110b200,GS110b200] = extract_fit_par(ld110bEi200.fit_resEi200.all_fit_par);

[S200a200,J200a200,GS200a200] = extract_fit_par(ld200aEi200.fit_resEi200.all_fit_par);
%[S200b200,J200b200,GS200b200] = extract_fit_par(ld200bEi200.fit_resEi200.all_fit_par);

[S110a400,J110a400,GS110a400] = extract_fit_par(ld110aEi400.fit_resEi400.all_fit_par);
[S200a400,J200a400,GS200a400] = extract_fit_par(ld200aEi400.fit_resEi400.all_fit_par);
%[S200c400,J200c400,GS200c400] = extract_fit_par(ld200cEi400.fit_resEi400.all_fit_par);

SS = [S110a200,S110a400,S200a200,S200a400];
JS = [J110a200,J110a400,J200a200,J200a400];
GS = [GS110a200,GS110a400,GS200a200,GS200a400];

plot_block(SS);
plot_block(JS);
plot_block(GS);

function plot_block(BN)
gi = genieplot.instance();
gi.line_widths = 2;
gi.colors = {'r'};
gi.marker_types= {'o'};
pd(BN(1));
gi.colors = {'g'};
gi.line_widths = 2;
gi.marker_types= {'o'};
pd(BN(2));

%
gi.colors = {'r'};
gi.line_widths = 2;
gi.marker_types= {'x'};
pd(BN(3));

gi.line_widths = 2;
gi.colors = {'g'};
gi.marker_types= {'x'};
pd(BN(4));


keep_figure;
end