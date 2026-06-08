root_path = fileparts(mfilename("fullpath"));
data_path = fullfile(root_path,'sym4D_cutsAndFits');


if ~exist('cuts2fit200','var')
    ld = load(fullfile(data_path,'multicuts_fit_dataGH_ei200meV.mat'));
    cuts2fit200 = ld.cuts2fit200;
end
cuts_list = cuts2fit200.cutsS_list();

mi = maps_instrument(200,600,'S');
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
for i=1:numel(cuts_list)
    cuts_list{i} = cuts_list{i}.set_instrument(mi);
    cuts_list{i} = cuts_list{i}.set_sample(sample);
end


dir_name  = "GH";

dE_step = 2; %original energy transfer step data were binned to. No point in going finer
half_dE = 10; % half width of data binning
cut_en = 30:10:150;
%cut_en = 145;

%cl= {cuts_list{3}};
%cl = {w2_test_cut};
if isfield(cuts2fit200,'bg_par_010off000')
    bg_par = {cuts2fit200.bg_par_010off000.p,cuts2fit200.bg_par_010off100.p,cuts2fit200.bg_par_010off200.p};
    cuts_list{end+1} = bg_par;
end
fit_res_200fixBg = fit_multicuts_along_direction(...
    cuts_list,'FitEn_cut200_1D_fit_bg',dir_name,cut_en,dE_step,half_dE);
    %cl,'En_cuts800',dir_name,cut_en,dE_step,half_dE);
beep
beep
beep
