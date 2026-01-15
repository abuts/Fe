if ~exist('all_cuts200mEv','var')
    ld = load('all_cutsFe_ei200_all_bg_4D_reducedBZ_no_ff.mat');
    all_cuts200mEv = ld.all_cuts;
end
all_cuts = all_cuts200mEv;
mi = maps_instrument(200,600,'S');
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);

for key = string(all_cuts.keys)
    all_cuts(key) = all_cuts(key).set_instrument(mi);
    all_cuts(key) = all_cuts(key).set_sample(sample);
end
dir_name  = "GN";

dE_step = 2; %original energy transfer step data were binned to. No point in going finer
half_dE = 4; % half width of data binning
cut_en = 30:2*half_dE:158;
use_mask = true;
% Mask algorithm masks appropriate part of sqw cut to allow binning within
% whole cut range and avoid phonons
% mask parameters:
% masking done with sinus:
mask_par = {40, ... Amplitde,
    pi,...  %phase range in selected direction
    10};    % baseline calculate sinus from
% if cut is performed using cut ranges, this is parabolic approximation of
% the range
cut_range_curvature = 9000 ; %GH= 2600 GP = 9000
the_2Dcut = all_cuts(dir_name);
fit_res = fit_cuts_along_direction(...
    the_2Dcut,cut_en,dE_step,half_dE,use_mask,mask_par,cut_range_curvature);
