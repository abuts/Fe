function [fit_obj,fit_par,figa,figb]=fit_single_set_logBg(the_2Dcuts,en_range,init_fg_param,do_fit)

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
batch = true;

n_samples = numel(the_2Dcuts);
sub_cuts = cell(1,n_samples);

valid = true(1,n_samples);
nplots = 0;


clObj = set_temporary_config_options('hor_config','log_level',-1);

init_bg_param = cell(1,n_samples);
debug_bg = true;
for j=1:n_samples
    sub_cuts{j} = cut(the_2Dcuts{j},0.02,en_range);
    valid(j) = sub_cuts{j}.num_pixels>0;
    if valid(j)
        nplots = nplots+1;
        cut_range = sub_cuts{j}.data.axes.get_cut_range;
        cut_range = cut_range{1};
        w1 = cut(sub_cuts{j},[cut_range(1),cut_range(3)],[],'-nopix');
        ds1 = IX_dataset_1d(w1);
        ds1 = log(ds1);ds1.signal = real(ds1.signal);
        fc = multifit(ds1);
        fc = fc.set_fun(@linear_bg1D);
        fc = fc.set_pin([ds1.signal(1),0]);
        fc = fc.set_free([1,1]);
        [fd,fp] = fc.fit();
        if debug_bg
            plot(ds1);
            acolor r;
            pl(fd);
        end
        init_bg_param{j} = [exp(fp.p(1)),fp.p(2),0];
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


kk = tobyfit(sub_cuts{:});

%kk = kk.set_fun(@sqw_iron_with_phonons);
kk = kk.set_fun(@sqw_iron);
kk = kk.set_pin({init_fg_param,hkl_proj});
kk = kk.set_free(free_sw_param);


kk = kk.set_bfun (@single_exp2D); % set_bfun sets the background functions
bg_param = init_bg_param(valid);
kk = kk.set_bpin (bg_param);  % initial background constant and gradient
bfree = zeros(1,numel(bg_param{1}));
bfree(1)=1;
kk = kk.set_bfree (bfree);

if batch
    kk = kk.set_options('list',0);
else
    kk = kk.set_options('list',2);
end

if do_fit
    [fit_obj,fit_par] = kk.fit();
else
    [fit_obj,fit_par] = kk.simulate();
end
fit_par.en = 0.5*(en_range(1)+en_range(3));
fit_par.en_range = en_range;
if ~iscell(fit_obj)
    fit_obj = {fit_obj};
end

[figa,figb]=plot_fit_res(sub_cuts,fit_obj,fit_par,en_range,eval_sw,true);

end
