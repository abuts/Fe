root_path = fileparts(mfilename("fullpath"));
data_path = fullfile(root_path,'sym4D_cutsAndFits');


if ~exist('cuts2fit400','var')
    ld = load('multicuts_fit_dataGH_ei400meV.mat');
    cuts2fit800 = ld.cuts2fit400;
end
cuts_list = cuts2fit400.cuts_list;

mi = maps_instrument(400,600,'S');
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);


for i=1:numel(cuts_list)
    cuts_list{i} = cuts_list{i}.set_instrument(mi);
    cuts_list{i} = cuts_list{i}.set_sample(sample);
end


dir_name  = "GH";

dE_step = 4; %original energy transfer step data were binned to. No point in going finer
half_dE = 10; % half width of data binning
cut_en = 30:10:300;
%cut_en = 145;

%cl= {cuts_list{3}};
%cl = {w2_test_cut};
fit_res_400 = fit_multicuts_along_direction(...
    cuts_list,'En_cut400',dir_name,cut_en,dE_step,half_dE);
    %cl,'En_cuts800',dir_name,cut_en,dE_step,half_dE);