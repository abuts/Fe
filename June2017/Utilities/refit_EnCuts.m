function  stor=refit_EnCuts(cut_fname,varargin)
% Refit group of equivalent cuts made at given energy and direction

%options = {'-keep_fig'};
%[ok,mess,keep_fig] = parse_char_options(varargin,options);
%if~ok
%    error('view_EnCuts:invalid_argument',mess);
%end


if isstruct(cut_fname)
    stor = cut_fname;
else
    stor = load(cut_fname);
end
init_fg_param = stor.fp_arr1.p;
init_bg_param  = stor.fp_arr1.bp;

init_fg_param = init_fg_param{1};
kk = tobyfit2(stor.cut_list);
%kk = kk.set_local_foreground(true);
kk = kk.set_fun(@sqw_iron,init_fg_param,[0,0,1,1,0,0,0,0,0,0]);
%kk = kk.set_fun(@(h,k,l,e,par)sw_disp(proj,ff_calc,h,k,l,e,par),[parR(1),parR(2),parR(3),ampl_avrg,fwhh_avrg],[1,1,1,1,1]);

%global_binds = {{6,[6,2],1},{7,[7,2],1},{8,[8,2],1},{9,[9,2],1},{10,[10,2],1}};
%all_binds = {global_binds{:},param_binds{:}};
%kk = kk.set_bind(all_binds{:});

% set up its own initial background value for each background function
kk = kk.set_bfun(@(x,par)(par(1)+x*par(2)),init_bg_param);

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',2,'fit_control_parameters',[1.e-2;60;1.e-6]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
%profile on;
[w1D_arr1_tf,fp_arr1]=kk.fit;
%[w1D_arr1_tf,fp_arr1]=kk.simulate;
%profile off
%profile viewer
stor.fp_arr1 = fp_arr1;
stor.w1D_arr1_tf = w1D_arr1_tf;





%view_
