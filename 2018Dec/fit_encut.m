function [A,err,bg_val,bg_err,fgs,bp,bsig]=fit_encut(en_cuts,fgs,kun_sym,kun_sym_dir,Kun_width )
% function to fit range of energy cuts with Kun's simulations.
%
%inputs:
%en_cuts -- list of energy cuts for given symmetry direction.
% fgs    -- class fig_spread used to spread images illiustrating the
%           progress of the simulations
% kun_sym   the number of the symmetry direction to sumulate. The numbers
%           correspond to symmetry directions defined in FCC_Igrid, class,
%           managing Kun's simulations
% kun_sym_dir -- the number of sub-symmetry for each cut (the ort within
%          the FCC cube [0,0,0->1,1,1] where Kun's simulations are expanded
%          to.
% Kun_width -- the width of the cut, in hkl directions. The points, located
%          within this distance from the choosen symmetry direction are
%          projected to the symmetry direction and used as the source of
%          the data to interpolate Kun's results and located further than
%          this distance are rejected and set up to 0.
%bg_val  =0;
%bg_err = 0;
acolor('k');
fh= plot(en_cuts{1});
for i=2:numel(en_cuts)
    pd(en_cuts{i});
end
kk = tobyfit(en_cuts{:});
fg_arr = cell(1,numel(kun_sym_dir));
fg_par = cell(1,numel(kun_sym_dir));
fg_free = cell(1,numel(kun_sym_dir));
bg_arr  = cell(1,numel(kun_sym_dir));
bg_par  = cell(1,numel(kun_sym_dir));
for i=1:numel(kun_sym_dir)
    fg_arr{i} = @disp_kun_calc;
    fg_par{i} = [1,1,kun_sym,kun_sym_dir(i),Kun_width];
    fg_free{i} = [1,0,0,0,0];
    bg_arr{i} = @(x,par)(par(1));
    bg_par{i} = 0;
end

kk = kk.set_fun(fg_arr,fg_par,fg_free);
kk = kk.set_bind ({1, [1,1]});

% set up its own initial background value for each background function
kk = kk.set_bfun(bg_arr,bg_par);

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-2;20;1.e-4]);
%profile on;
%[w1d_arr_tf,fitpar]=kk.simulate;
[w1d_arr_tf,fitpar]=kk.fit;
acolor('r');
if ~iscell(w1d_arr_tf)
    w1d_arr_tf = {w1d_arr_tf};
    multiple_cuts = false;
else
    multiple_cuts = true;
end
for i=1:numel(en_cuts)
    pl(w1d_arr_tf{i});
end
if multiple_cuts
    par = fitpar.p{1};
    sig = fitpar.sig{1};
    bp = [fitpar.bp{:}];
    bsig = [fitpar.bsig{:}];
else
    par = fitpar.p;
    sig = fitpar.sig;
    bp = fitpar.bp;
    bsig = fitpar.bsig;
    
end
A   = abs(par(1));
err = sig(1);
bg_val = bp(1);
bg_err = bsig(1);
if exist('fgs','var')
    fgs = fgs.place_fig(fh);
end

