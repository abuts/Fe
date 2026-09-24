%root_path = fileparts(mfilename("fullpath"));
%root_path = pwd;
scuts_path = 'e:\SHARE\Fe\Data\analysis\07_fit_with_multicut_allJ\sel_cuts';
Cutfitfile = fullfile(scuts_path,'GP_FFCutsFits.mat');

if ~exist('GP_FFCutsFits','var')
    ld = load(Cutfitfile);
    GP_FFCutsFits = ld.fit_src_struc;
end
fit_res_field = 'all_fit_par';
%%
[S_op11Ei200,J_op11Ei200,Gam_op11Ei200] = extract_fit_par(GP_FFCutsFits.(['Ei200_off110GPmiff_',fit_res_field]));
[S_op11Ei400,J_op11Ei400,Gam_op11Ei400] = extract_fit_par(GP_FFCutsFits.(['Ei400_off110GPminFF_',fit_res_field]));
[S_op11Ei800,J_op11Ei800,Gam_op11Ei800] = extract_fit_par(GP_FFCutsFits.(['Ei800_off110GPminFF_',fit_res_field]));

plot_fp('offset <110> min FF change', ...
    [S_op11Ei200,S_op11Ei400,S_op11Ei800], ...
    [J_op11Ei200,J_op11Ei400,J_op11Ei800], ...
    [Gam_op11Ei200,Gam_op11Ei400,Gam_op11Ei800])


[S_opEi200,J_opEi200,Gam_opEi200] = extract_fit_par(GP_FFCutsFits.(['Ei200_off200GPmiff_',fit_res_field]));
[S_opEi400,J_opEi400,Gam_opEi400] = extract_fit_par(GP_FFCutsFits.(['Ei400_off200GPminFF_',fit_res_field]));
[S_opEi800,J_opEi800,Gam_opEi800] = extract_fit_par(GP_FFCutsFits.(['Ei800_off200GPminFF_',fit_res_field]));

plot_fp('offset <200> min FF change', ...
    [S_opEi200,S_opEi400,S_opEi800], ...
    [J_opEi200,J_opEi400,J_opEi800], ...
    [Gam_opEi200,Gam_opEi400,Gam_opEi800])

[S_ma11Ei200,J_ma11Ei200,Gam_ma11Ei200] = extract_fit_par(GP_FFCutsFits.(['Ei200_off110GPmaff_',fit_res_field]));
[S_ma11Ei400,J_ma11Ei400,Gam_ma11Ei400] = extract_fit_par(GP_FFCutsFits.(['Ei400_off110GPmaxFF_',fit_res_field]));
[S_ma11Ei800,J_ma11Ei800,Gam_ma11Ei800] = extract_fit_par(GP_FFCutsFits.(['Ei800_off110GPmaxFF_',fit_res_field]));
plot_fp('offset <110> max FF change', ...
    [S_ma11Ei200,S_ma11Ei400,S_ma11Ei800], ...
    [J_ma11Ei200,J_ma11Ei400,J_ma11Ei800], ...
    [Gam_ma11Ei200,Gam_ma11Ei400,Gam_ma11Ei800])


[S_maEi200,J_maEi200,Gam_maEi200] = extract_fit_par(GP_FFCutsFits.(['Ei200_off200GPmaff_',fit_res_field]));
[S_maEi400,J_maEi400,Gam_maEi400] = extract_fit_par(GP_FFCutsFits.(['Ei400_off200GPmaxFF_',fit_res_field]));
[S_maEi800,J_maEi800,Gam_maEi800] = extract_fit_par(GP_FFCutsFits.(['Ei800_off200GPmaxFF_',fit_res_field]));
plot_fp('offset <200> max FF change', ...
    [S_maEi200,S_maEi400,S_maEi800], ...
    [J_maEi200,J_maEi400,J_maEi800], ...
    [Gam_maEi200,Gam_maEi400,Gam_maEi800])

%%

plot_fp_var('g', ...
    [S_op11Ei200,S_opEi200,S_ma11Ei200,S_maEi200], ...
    [J_op11Ei200,J_opEi200,J_ma11Ei200,J_maEi200], ...
    [Gam_op11Ei200,Gam_opEi200,Gam_ma11Ei200,Gam_maEi200])

plot_fp_var('b', ...
    [S_op11Ei400,S_opEi400,S_ma11Ei400,S_maEi400], ...
    [J_op11Ei400,J_opEi400,J_ma11Ei400,J_maEi400], ...
    [Gam_op11Ei400,Gam_opEi400,Gam_ma11Ei400,Gam_maEi400])

plot_fp_var('r', ...
    [S_op11Ei800,S_opEi800,S_ma11Ei800,S_maEi800], ...
    [J_op11Ei800,J_opEi800,J_ma11Ei800,J_maEi800], ...
    [Gam_op11Ei800,Gam_opEi800,Gam_ma11Ei800,Gam_maEi800])


function plot_fp_var(color,varargin)
ranges = {[0.5,2],[10,70],[0,200]};
types = {'o','x','*','d'};
gp = genieplot.instance();
gp.marker_types = types;
acolor(color);
for j=1:numel(varargin)
    ds = varargin{j};
    range = ranges{j};
    pd(ds);    
    %for i=1:numel(ds)
    %
    %
    %end
    ly(range(1),range(2))
    keep_figure;
    legend({'<110> minFF','<200> minFF','<110> max FF','<200> max FF'});
end
end

function plot_fp(title,varargin)
colors = {'g','b','r'};
ranges = {[0.5,2],[10,70],[0,200]};
for j=1:numel(varargin)
    ds = varargin{j};
    range = ranges{j};
    ds(1).title = title;    
    for i=1:3
        acolor(colors{i});
        pd(ds(i));ly(range(1),range(2));
    end
    keep_figure;
    legend({'Ei200','Ei400','Ei800'});
end
end