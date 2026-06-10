function [fit_obj,fit_par,figa]=fit_single_set(the_2Dcuts,en,half_dE,dE_step,init_fg_params,init_bg_param,do_fit)

%with phonons here:
%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, gf, af, J3, J4];
free_sw_param  =  [0          0, 1   ,1   , 0,    1, 0,   0, 0,  0];

%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, J1, J2, J3, J4];
%free_sw_param  =  [0          0, 1   ,1   , 0,    1, 0,   0,  0,  0];

n_samples = numel(the_2Dcuts);
sub_cuts = cell(1,n_samples);

valid = true(1,n_samples);
nplots = 0;
bg_const = 0;
use_fitted_bg_function =  iscell(init_bg_param);

clObj = set_temporary_config_options('hor_config','log_level',-1);
for j=1:n_samples
    %sub_cuts{j} = cut(the_2Dcuts{j},0.02,[en-half_dE ,dE_step,en+half_dE]);
    sub_cuts{j} = cut(the_2Dcuts{j},0.02,[en-half_dE ,en+half_dE]);
    valid(j) = sub_cuts{j}.num_pixels>0;
    if valid(j)
        nplots = nplots+1;
        cut_range = sub_cuts{j}.data.axes.get_cut_range;
        cut_range = cut_range{1};
        if ~use_fitted_bg_function
            %w0 = cut(sub_cuts{j},[cut_range(1),cut_range(3)],[en-half_dE ,en+half_dE],'-nopix');
            w0 = cut(sub_cuts{j},[cut_range(1),cut_range(3)],'-nopix');
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
kk = kk.set_pin({init_fg_params,hkl_proj});
kk = kk.set_free(free_sw_param);
if use_fitted_bg_function
    for ii=1:n_samples 
        bg_par  = bg_param{ii};
        bg_par(end+1) = en;
        bg_param{ii} = bg_par;
    end
    
    kk = kk.set_bfun (@double_exp1D); % set_bfun sets the background functions    
    kk = kk.set_bpin (bg_param);  % initial background constant and gradient    
    kk = kk.set_bfree ([0,0,0,0,0]);    
else    
    kk = kk.set_bfun (@linear_bg1D); % set_bfun sets the background functions
%kk = kk.set_bfun (@linear_bg2D); % set_bfun sets the background functions
    kk = kk.set_bpin (bg_param);  % initial background constant and gradient
    kk = kk.set_bfree ([1, 0]);
end
%kk = kk.set_bfree ([1, 0, 1]);
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


colour={'k','k','r','r','g','g'};
gp = genieplot.instance();
for j=1:nplots
    gp.line_widths = 0.5;
    if sub_cuts{j}.dimensions() == 2
        w1 = cut(sub_cuts{j},[],[en-half_dE ,en+half_dE],'-nopix');
    else
        w1  = sub_cuts{j}.data;
    end
    acolor(colour{2*j-1});
    if j == 1
        plot(w1);liny;
    else
        pd(w1);
    end
    acolor(colour{2*j});
    gp.line_widths = 2;
    if sub_cuts{j}.dimensions() == 2    
        w1fit = cut(fit_obj{j},[],[en-half_dE ,en+half_dE]);
    else
        w1fit = fit_obj{j}.data;
    end
    pl(w1fit);
    drawnow;
end
figa = gcf;

end
