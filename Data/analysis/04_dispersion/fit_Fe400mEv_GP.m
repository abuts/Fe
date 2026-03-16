if ~exist('all_cuts400mEv','var')
    ld = load('all_cutsFe_ei400_all_bg_4D_reducedBZ_no_ff_filt_remove.mat');
    all_cuts400mEv = ld.all_cuts;
end
all_cuts = all_cuts400mEv;
mi = maps_instrument(200,600,'S');
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);

for key = string(all_cuts.keys)
    all_cuts(key) = all_cuts(key).set_instrument(mi);
    all_cuts(key) = all_cuts(key).set_sample(sample);
end
dir_name  = "GP";
dE_step = 4; %original energy transfer step data were binned to. No point in going finer
half_dE = 4; % half width of data binning
cut_en = 50:4:250;

use_mask = false;
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
    the_2Dcut,dir_name,cut_en,dE_step,half_dE,use_mask,mask_par,cut_range_curvature);
