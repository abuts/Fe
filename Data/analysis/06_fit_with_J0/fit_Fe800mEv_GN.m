if ~exist('cut_4fit800mEv','var')
    fig = openfig('GN_Ei800_cut2fit.fig');
    cut_4fit800mEv = src(fig);
    cut_4fit800mEv  = symmetrise_sqw(cut_4fit800mEv,SymopReflection('norm',[-1,1,0],'offset',[1,1,0]));
end
mi = maps_instrument(800,600,'S');
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);

cut_4fit800mEv = cut_4fit800mEv.set_instrument(mi);
cut_4fit800mEv = cut_4fit800mEv.set_sample(sample);

dir_name  = "GN";

dE_step = 5; %original energy transfer step data were binned to. No point in going finer
half_dE = 5; % half width of data binning
cut_en = 90:5:240;

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
cut_range_curvature = Inf ; %GH= 2600 GP = 9000
fit_res = fit_cuts_along_direction(...
    cut_4fit800mEv,'En_cut800',dir_name,cut_en,dE_step,half_dE,use_mask,mask_par,cut_range_curvature);
