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


n_cuts = numel(obj.cuts_list);
obj.fits_list = repmat(obj.cuts_list(1),n_cuts,1);
obj.fitpar = struct('p',[],'sig',[],'bp',[],'bsig',[]);
obj.fitpar.p = cell(n_cuts,1);
obj.fitpar.sig = cell(n_cuts,1);
obj.fitpar.bp = cell(n_cuts,1);
obj.fitpar.bsig = cell(n_cuts,1);

file_directions = {[1,0,0],[1,1,0],[1,1,1]};
equal_cuts_map = obj.equal_cuts_map;
cuts_list = obj.cuts_list;
fixed_par = obj.fit_par_range;
all_fg_params = obj.init_fg_params_;
all_bg_params = obj.init_bg_params_;
cut_en_f = @(x)(0.5*(x.data.iint(1,3)+x.data.iint(2,3)));
cut_en = arrayfun(cut_en_f ,cuts_list);
cut_en = unique(cut_en);
n_en = numel(cut_en);
fit_rez = cell(n_en,1);
for i=1:n_en
    equal_cuts = {};
    for ii = 1:numel(file_directions)
        direction = file_directions{ii};
        cut_dir_id = direction_id(direction);
        theKey  = [num2str(cut_en(i)),cut_dir_id];
        
        dir_cuts = equal_cuts_map(theKey);
        equal_cuts = { equal_cuts{:},dir_cuts{:}};
    end
    eq_indexes = [equal_cuts{:}];
    eq_cuts = cuts_list(eq_indexes);
    loc_binds={};
    n_cut = 1;
    for ii = 1:numel(file_directions)
        direction = file_directions{ii};
        cut_dir_id = direction_id(direction);
        theKey  = [num2str(cut_en(i)),cut_dir_id];
        
        dir_cuts = equal_cuts_map(theKey);
        dir_binds = cell(2*(numel(dir_cuts)-1),1);
        binding = n_cut:n_cut+numel(dir_cuts)-1;
        n_func = binding(1);
        for j=1:numel(binding)-1
            dir_binds {2*j-1} = {[3,binding(j+1)],[3,n_func],1};
            dir_binds {2*j} = {[4,binding(j+1)],[4,n_func],1};
        end
        n_cut = n_cut+ numel(dir_cuts);
        loc_binds = {loc_binds{:},dir_binds{:}};
    end
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
    init_fg_params = all_fg_params(eq_indexes);
    init_bg_params = all_bg_params(eq_indexes);
    kk = tobyfit2(eq_cuts );
    
    kk = kk.set_local_foreground(true);
    kk = kk.set_fun(@sqw_iron,init_fg_params,fixed_par);
    %kk = kk.set_fun(@(h,k,l,e,par)sw_disp(proj,ff_calc,h,k,l,e,par),[parR(1),parR(2),parR(3),ampl_avrg,fwhh_avrg],[1,1,1,1,1]);
    %global_binds = {{6,[6,2],1},{7,[7,2],1},{8,[8,2],1},{9,[9,2],1},{10,[10,2],1}};
    global_binds = {{6,[6,2],1},{7,[7,2],1}};
    all_binds = {global_binds{:},loc_binds{:}};
    kk = kk.set_bind(all_binds);
    
    % set up its own initial background value for each background function
    kk = kk.set_bfun(@(x,par)(par(1)+x*par(2)),init_bg_params);
    
    kk = kk.set_mc_points(10);
    %profile on;
    kk = kk.set_options('listing',0,'fit_control_parameters',[1.e-2;20;1.e-3]);
    %kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
    %profile on;
    [w1D_arr1_tf,fp_arr1]=kk.fit;
    %[w1D_arr1_tf,fp_arr1]=kk.simulate;
    %profile off
    %profile viewer
    fit_rez{i} = {w1D_arr1_tf,fp_arr1,eq_indexes};
    %
end

for  i= 1:numel(nen)
    [w1D_arr1_tf,fp_arr1,eq_cuts_indexes] = fit_rez{i}{:};
    
    for jj = 1:numel(eq_cuts_indexes)
        ind = eq_cuts_indexes(jj);
        obj.fitpar.p{ind} = fp_arr1.p{jj};
        obj.fitpar.sig{ind} = fp_arr1.sig{jj};
        obj.fitpar.bp{ind} = fp_arr1.bp{jj};
        obj.fitpar.bsig{ind} = fp_arr1.bsig{jj};
        
        obj.fits_list(ind) = w1D_arr1_tf(jj);
    end
end

obj.fitpar = fitpar;
obj.fits_list = fits_list;
obj = obj.setup_j();
%be ready to refit
obj.init_fg_params_ = obj.fitpar.p;
obj.init_bg_params_ = obj.fitpar.bp;

obj = obj.save_en_cuts();
