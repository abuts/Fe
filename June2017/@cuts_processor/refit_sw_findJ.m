function obj= refit_sw_findJ(obj,bragg_list,file_list,e_min,e_max)
% Load sequence of cuts, corresponding to different Brillouin zones and
% different reciprocal lattice directions and fit these peaks with the
% scattering function defined by the spin-wave Hamiltonian specified.
%
%
if ~exist('e_min','var')
    e_min  = -inf;
    e_max  = inf;
end

if exist('bragg_list','var')
    % build the list of input filenames and verify if the files are present.
    [obj,filenames,file_directions,missing_files] = obj.find_initial_cuts(bragg_list,file_list);
    if ~isempty(missing_files)
        disp(missing_files);
        warning('PROCESS_CUTS:invalid_arguments','some initial direction-cut files are missing')
    end
    
    [obj,init_fg_params,init_bg_params,param_binds,emin_real,emax_real] = ...
        obj.init_fitting(filenames,file_directions,e_min,e_max);
    obj.e_range = [emin_real,emax_real];
    obj.init_fg_params_ = init_fg_params;
    obj.init_bg_params_ = init_bg_params;
    obj.param_binds_ = param_binds;
end
if ~obj.fit_initated
    error('CUTS_PROCESSOR:runtime_error',...
        ' cuts_processor has not been properly initiated');
end
%
% % S(Q,w) model
%   ff = 1; % 1
%   T = 8;  % 2
%   %gamma = 10; % 3
%   gamma = fitpar_av(3);
%   gap = 0;    % 5
%   %Seff = 2;   % 4
%   Seff = fitpar_av(4);
%   %J1 = 40;    % 6
%   J0 = fitpar_av(6);
%   par = [ff, T, gamma, Seff, gap, J0, J1, J2, 0, 0];
%
%
kk = tobyfit2(obj.cuts_list);
%ff_calc = mff.getFF_calculator(cut_list(1));
kk = kk.set_local_foreground(true);
kk = kk.set_fun(@sqw_iron,obj.init_fg_params_,obj.fit_par_range);
%kk = kk.set_fun(@(h,k,l,e,par)sw_disp(proj,ff_calc,h,k,l,e,par),[parR(1),parR(2),parR(3),ampl_avrg,fwhh_avrg],[1,1,1,1,1]);
%kk = kk.set_bind({1,[1,2],1},{2,[2,2],1},{3,[3,2],1});
global_binds = {{6,[6,2],1},{7,[7,2],1},{8,[8,2],1},{9,[9,2],1},{10,[10,2],1}};
all_binds = {global_binds{:},obj.param_binds_{:}};
kk = kk.set_bind(all_binds{:});

% set up its own initial background value for each background function
kk = kk.set_bfun(@(x,par)(par(1)+x*par(2)),obj.init_bg_params_);

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-2;60;1.e-6]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
%profile on;
[w1D_arr1_tf,fp_arr1]=kk.fit;
%[w1D_arr1_tf,fp_arr1]=kk.simulate;
%profile off
%profile viewer
obj.fitpar = fp_arr1;
obj.fits_list = w1D_arr1_tf;
obj = obj.setup_j();
% be ready to refit
obj.init_fg_params_ = obj.fitpar.p;
obj.init_bg_params_ = obj.fitpar.bp;

obj = obj.save_en_cuts();
