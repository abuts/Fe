root_path = fileparts(mfilename("fullpath"));
data_path = fullfile(root_path,'sym4D_cutsAndFits');


if ~exist('cuts2fit400','var')
    ld = load(fullfile(data_path,'multicuts_fit_dataGH_ei400meVse.mat'));
    cuts2fit400 = ld.cuts2fit400;
end
cuts_list = cuts2fit400.cutsS_list;

mi = maps_instrument(400,600,'S');
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
for i=1:numel(cuts_list)
    cuts_list{i} = cuts_list{i}.set_instrument(mi);
    cuts_list{i} = cuts_list{i}.set_sample(sample);
end


dir_name  = "GH";

dE_step = 4; %original energy transfer step data were binned to. No point in going finer
half_dE = 10; % half width of data binning
cut_en = 50:10:260;
%cut_en = 145;

%cl= {cuts_list{3}};
%cl = {w2_test_cut};
% if isfield(cuts2fit400,'bg_par_010off000')
%     bg_par = {cuts2fit400.bg_par_010off000.p,cuts2fit400.bg_par_010off100.p,cuts2fit400.bg_par_010off200.p};
%     cuts_list{end+1} = bg_par;
% end

fit_res_400fix_bg = fit_multicuts_along_direction(...
    cuts_list,'FitEn_cut400_1D_fit_bg',dir_name,cut_en,dE_step,half_dE);
    %cl,'En_cuts800',dir_name,cut_en,dE_step,half_dE);
beep
beep
beep
