%FIT_CUTS_ALONG_DIRECTION fits high symmetry 2D cut privided as input

src_name = 'cutE800_dEq110at110.mat';
if ~exist('cut800mEv_110at110','var')
    ld = load(src_name);
    cut800mEv_110at110 = ld.cut800mEv_110at110;
end
%mi = maps_instrument(800,600,'S');
%sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
%cut800mEv_110at110  = cut800mEv_110at110.set_instrument(mi);
%cut800mEv_110at110  = cut800mEv_110at110.set_sample(sample);

correct_ff = 1;
T   = 8;
gap = 0;    %
gamma = 50;
Seff0 =0.87;      %1.4489;


%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, J1, J2, J3, J4];
init_fg_params = [correct_ff,T,gamma,Seff0, gap, 0, 0,   15,  0,  0];
free_sw_param  = [0          0, 1   ,1   , 0,    0, 0,   1,  0,  0];

kk = tobyfit(cut800mEv_110at110);
kk = kk.set_fun(@sqw_iron);
kk = kk.set_pin({init_fg_params,cut800mEv_110at110});
kk = kk.set_free(free_sw_param);
kk = kk.set_bfun (@exp_bg2D); % set_bfun sets the background functions
kk = kk.set_bpin ([1.01, 0.025,0.02,0.005]);  % initial background constant and gradient
kk = kk.set_bfree ([1, 1, 1,1]);
kk = kk.set_options('list',2);
%[fit,par] = kk.simulate();
[fit_obj,fit_par] = kk.fit();

%w2rbg = func_eval(w2r,@exp_bg2D,[1.4084 0.0261 0.0029 4.5656e-04]);
w2rbg = func_eval(cut800mEv_110at110,@exp_bg2D,fit_par.bp);
plot(w2rbg);
w2r = w2r-w2rbg;
plot(w2r);
lz 0 0.3;
mi = MagneticIons();
w2rc = mi.correct_mag_ff(w2r);
% add together symmetric regions with the same magnetic form-factor
w2dc = symmetrise_sqw(w2rc,SymopReflection('normvec',[-1,1,0]));
plot(w2dc);
lz 0 1;
% add region with higher range and signal suppressed by mff, to lower q,
% lower range
w2ss = cut(w2dc,[0,0.02,1],[],SymopReflection('normvec',[-1,1,0],'offset',[0,2,0]));
plot(w2ss) 
% add together 2 SW branches
w2ss = cut(w2ss,[0,0.02,0.5],[],SymopReflection('normvec',[-1,1,0],'offset',[0.5,1.5,0]));




