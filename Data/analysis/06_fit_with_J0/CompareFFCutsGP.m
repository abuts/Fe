fpath = 'e:\SHARE\Fe\Data\analysis\06_fit_with_J0\sym4D_cutsAndFits';

ld110Ei200 = load(fullfile(fpath,'EnFit_Ei200off110_2D_dirGP_dE20_fitSlopeDE.mat'));
ld200Ei200 = load(fullfile(fpath,'EnFit_Ei200off200_2D_dirGP_dE20_fitSlopeDE.mat'));

ld110Ei400 = load(fullfile(fpath,'EnFit_Ei400off110_2D_dirGP_dE20_fitSlopeDE.mat'));
ld200Ei400 = load(fullfile(fpath,'EnFit_Ei400off200_2D_dirGP_dE20_fitSlopeDE.mat'));


[S110e200,J110e200,GS110e200] = extract_fit_par(ld110Ei200.fit_resEi200.all_fit_par);
[S200e200,J200e200,GS200e200] = extract_fit_par(ld200Ei200.fit_resEi200.all_fit_par);

[S110e400,J110e400,GS110e400] = extract_fit_par(ld110Ei400.fit_resEi400.all_fit_par);
[S200e400,J200e400,GS200e400] = extract_fit_par(ld200Ei400.fit_resEi400.all_fit_par);

SS = [S110e200,  S200e200, S110e400, S200e400];
JS = [J110e200,  J200e200, J110e400, J200e400];
GS = [GS110e200,GS200e200,GS110e400,GS200e400];

plot_block(SS);
plot_block(JS);
plot_block(GS);

function plot_block(BN)
gi = genieplot.instance();
gi.line_widths = 1;
gi.colors = {'r'};
gi.marker_types= {'x'};
pd(BN(1));
gi.line_widths = 3;
gi.marker_types= {'o'};
pd(BN(2));

%----------------------
gi.line_widths = 1;
gi.colors = {'g'};
gi.marker_types= {'x'};
pd(BN(3));
gi.line_widths = 3;
gi.marker_types= {'o'};
pd(BN(4));

keep_figure;
end