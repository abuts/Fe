root_path = fileparts(mfilename("fullpath"));
data_path = fullfile(root_path,'sym4D_cutsAndFits');

if ~exist('cuts2fit800','var')
    ld = load(fullfile(data_path,'multicuts_fit_dataGH_ei800meV.mat'));
    cuts2fit800 = ld.cuts2fit800;
end
%cuts_list = cuts2fit800.cutsS_list;
cuts_list = {cuts2fit800.cut2fit010_dir100};

mi = maps_instrument(787,600,'S');
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
% cuts_list = {wm800_o00,wm800_om1m1,wm_800o11};

for i=1:numel(cuts_list)
    cuts_list{i} = cuts_list{i}.set_instrument(mi);
    cuts_list{i} = cuts_list{i}.set_sample(sample);
end


dir_name  = "GH";

dE_step = 4; %original energy transfer step data were binned to. No point in going finer
half_dE = 10; % half width of data binning
%cut_en = 80:10:390;
%cut_en = 330:-10:60;
cut_en = 80:10:290;
%cut_en = 145;
if isfield(cuts2fit800,'bg_par_010off100')
    if numel(cuts_list) == 3    
        bg_par = {cuts2fit800.bg_par_010off000.p,cuts2fit800.bg_par_010off100.p,cuts2fit800.bg_par_010off200.p};
    else
        bg_par  = {cuts2fit800.bg_par_010off100.p};
    end
    cuts_list{end+1} = bg_par;
end
%cl= {cuts_list{3}};
%cl = {w2_test_cut};
fit_res_800fix_bg = fit_multicuts_along_direction(...
    cuts_list,'FitEn_cut800ref110_2D_dirGH_fix_bg_slope',dir_name,cut_en,dE_step,half_dE);
    %cl,'En_cuts800',dir_name,cut_en,dE_step,half_dE);

