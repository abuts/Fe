function [fit_obj,fit_par,figa,figb]=fit_single_set(the_2Dcuts,en,half_dE,dE_step,init_fg_param,init_bg_param,do_fit)

%with phonons here:
%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, gf, af, J3, J4];
free_sw_param  =  [0          0, 1   ,1   , 0,    1, 0,   0, 0,  0];

%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, J1, J2, J3, J4];
%free_sw_param  =  [0          0, 1   ,1   , 0,    1, 0,   0,  0,  0];
if nargout == 4
    eval_sw = true;
else
    eval_sw = false;
end
use_2D_cuts = true;

n_samples = numel(the_2Dcuts);
sub_cuts = cell(1,n_samples);

valid = true(1,n_samples);
nplots = 0;
bg_const = 0;
use_fitted_bg_function =  iscell(init_bg_param) && numel(init_bg_param{1})>3;

clObj = set_temporary_config_options('hor_config','log_level',-1);
for j=1:n_samples
    if use_2D_cuts
        sub_cuts{j} = cut(the_2Dcuts{j},0.02,[en-half_dE ,dE_step,en+half_dE]);
    else
        sub_cuts{j} = cut(the_2Dcuts{j},0.02,[en-half_dE ,en+half_dE]);
    end
    valid(j) = sub_cuts{j}.num_pixels>0;
    if valid(j)
        nplots = nplots+1;
        cut_range = sub_cuts{j}.data.axes.get_cut_range;
        cut_range = cut_range{1};
        if ~use_fitted_bg_function
            if use_2D_cuts
                w0 = cut(sub_cuts{j},[cut_range(1),cut_range(3)],[en-half_dE ,en+half_dE],'-nopix');
            else
                w0 = cut(sub_cuts{j},[cut_range(1),cut_range(3)],'-nopix');
            end
            bg_const = bg_const+w0.s;
        end
    end
end
clear clObj;
sub_cuts = sub_cuts(valid);
if (numel(sub_cuts) == 0)
    fit_obj = [];
    fit_par = [];
    figa = [];
    return
end
n_samples = numel(sub_cuts);
hkl_proj =cellfun(@(sobj)sobj.data.proj,sub_cuts);
%hkl_proj = sub_cuts{2}.data.proj; %get the projection, used for converting from hkl to Crystal Cartesian
%hkl_proj.offset = [0,0,0];

bg_const = bg_const/nplots;

if isempty(init_bg_param)
    if sub_cuts{1}.dimensions == 2
        bg_param = {[bg_const, 0, 0]};
    else
        bg_param = {[bg_const, 0]};
    end
else
    bg_param  = init_bg_param;
end

kk = tobyfit(sub_cuts{:});

%kk = kk.set_fun(@sqw_iron_with_phonons);
kk = kk.set_fun(@sqw_iron);
kk = kk.set_pin({init_fg_param,hkl_proj});
kk = kk.set_free(free_sw_param);
if use_fitted_bg_function
    if use_2D_cuts
        kk = kk.set_bfun (@double_exp2D); % set_bfun sets the background functions
        bg_param = bg_param(valid);
        kk = kk.set_bpin (bg_param);  % initial background constant and gradient
        bfree = zeros(1,numel(bg_param{1}));
        bfree(1)=1;
        kk = kk.set_bfree (bfree);
    else
        bg_param = bg_param(valid);
        for ii=1:n_samples
            bg_par  = bg_param{ii};
            if numel(bg_par) == 5
                continue
            end
            bg_par(end+1) = en;
            bg_param{ii} = bg_par;
        end
        kk = kk.set_bfun (@double_exp1D); % set_bfun sets the background functions
        kk = kk.set_bpin (bg_param);  % initial background constant and gradient
        kk = kk.set_bfree ([0,0,0,0,0]);
    end
else
    if use_2D_cuts
        kk = kk.set_bfun (@linear_bg2D); % set_bfun sets the background functions
        kk = kk.set_bpin (bg_param);  % initial background constant and gradient
        kk = kk.set_bfree ([1, 0, 1]);
    else
        kk = kk.set_bfun (@linear_bg1D); % set_bfun sets the background functions
        kk = kk.set_bpin (bg_param);  % initial background constant and gradient
        kk = kk.set_bfree ([1, 0]);
    end
end

kk = kk.set_options('list',2);

if do_fit
    [fit_obj,fit_par] = kk.fit();
else
    [fit_obj,fit_par] = kk.simulate();
end
fit_par.en = en;
fit_par.en_range = [en-half_dE ,dE_step,en+half_dE];
if ~iscell(fit_obj)
    fit_obj = {fit_obj};
end

[figa,figb]=plot_fit_res(sub_cuts,fit_obj,fit_par,fit_par.en_rangeen_range,eval_sw,false);

