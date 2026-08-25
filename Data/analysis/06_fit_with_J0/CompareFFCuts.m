fpath = 'e:\SHARE\Fe\Data\analysis\06_fit_with_J0\sym4D_cutsAndFits';

ld110aEi200 = load(fullfile(fpath,'EnFit_Ei200ref001off110_2D_constFFCut_dirGH_dE10_fitSlopeDE.mat'));
ld110bEi200 = load(fullfile(fpath,'EnFit_Ei200ref001off110_2D_constFFCut_dirGH_dE20_fitSlopeDE.mat'));
ld110cEi200 = load(fullfile(fpath,'EnFit_Ei200ref001off110_2D_constFFCut_dirGH_dE10_fitSlopeDE.mat'));
ld200aEi200 = load(fullfile(fpath,'EnFit_Ei200Br110dir010_2D_dirGH_dE20_fitSlopeDE.mat'));
%ld200bEi200 =
%load(fullfile(fpath,'EnFit_Ei200Br200dir010_2peaks_2D_dirGH_dE20_fitSlopeDE.mat')); % Ugly drop in scattering ampliture at 100-130meV
ld200bEi200 = load(fullfile(fpath,'EnFit_Ei200Br200dir010_1peak_2D_dirGH_dE20_fitSlopeDE.mat'));

ld110bEi400 = load(fullfile(fpath,'EnFit_Ei400ref001off110_2D_constFFCut_dirGH_dE20_fitSlopeDE.mat'));
ld200bEi400 = load(fullfile(fpath,'EnFit_Ei400ref001off200_2D_constFFCut_dirGH_dE20_fitSlopeDE.mat'));

ld200cEi400 = load(fullfile(fpath,'EnFit_Ei400ref001off200_2D_constFFCut_dirGH_dE10_fitSlopeDE.mat'));

[S110a200,J110a200,GS110a200] = extract_fit_par(ld110aEi200.fit_resEi200.all_fit_par);
[S110b200,J110b200,GS110b200] = extract_fit_par(ld110bEi200.fit_resEi200.all_fit_par);

[S200a200,J200a200,GS200a200] = extract_fit_par(ld200aEi200.fit_resEi200.all_fit_par);
[S200b200,J200b200,GS200b200] = extract_fit_par(ld200bEi200.fit_resEi200.all_fit_par);

[S110b400,J110b400,GS110b400] = extract_fit_par(ld110bEi400.fit_resEi400.all_fit_par);
[S200b400,J200b400,GS200b400] = extract_fit_par(ld200bEi400.fit_resEi400.all_fit_par);
[S200c400,J200c400,GS200c400] = extract_fit_par(ld200cEi400.fit_resEi400.all_fit_par);

SS = [S110a200,S110b200,S110b400,S200a200,S200b200,S200b400,S200c400];
JS = [J110a200,J110b200,J110b400,J200a200,J200b200,J200b400,J200c400];
GS = [GS110a200,GS110b200,GS110b400,GS200a200,GS200b200,GS200b400,GS200c400];

plot_block(SS);
plot_block(JS);
plot_block(GS);

function plot_block(BN)
gi = genieplot.instance();
gi.line_widths = 1;
gi.colors = {'g'};
gi.marker_types= {'x'};
pd(BN(1));
gi.line_widths = 3;
gi.marker_types= {'o'};
pd(BN(2));

gi.colors = {'r'};
gi.line_widths = 3;
gi.marker_types= {'+'};
pd(BN(3));

%----------------------
gi.line_widths = 1;
gi.colors = {'b'};
gi.marker_types= {'x'};
pd(BN(4));
gi.line_widths = 3;
gi.marker_types= {'o'};
pd(BN(5));

%gi.line_widths = 1;
gi.colors = {'k'};
%gi.marker_types= {'x'};
%pd(BN(3));
gi.line_widths = 3;
gi.marker_types= {'+'};
pd(BN(6));
gi.line_widths = 1;
gi.marker_types= {'+'};
pd(BN(7));


keep_figure;
end