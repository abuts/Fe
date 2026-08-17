function [fit_obj,fit_par,figa,figb]=refit_singleset_peaks(the_2Dcuts,en_range,fit_par_in,peak_scale,do_fit,batch)

init_fg_param = fit_par_in.p;
init_bg_param = fit_par_in.bp;
if ~iscell(init_bg_param)
    init_bg_param  = {init_bg_param};
end
if ~exist('batch','var')
    batch = false;
end
%with phonons here:
%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, gf, af, J3, J4];
free_sw_param  =  [0          0, 1   ,1   , 0,    1, 0,   0, 0,  0];

%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, J1, J2, J3, J4];
%free_sw_param  =  [0          0, 1   ,1   , 0,    1, 0,   0,  0,  0];
if nargout >= 4
    eval_sw = true;
else
    eval_sw = false;
end

n_samples = numel(the_2Dcuts);
sub_cuts = cell(1,n_samples);

valid = true(1,n_samples);
nplots = 0;

clObj = set_temporary_config_options('hor_config','log_level',-1);
if do_fit
    init_fg_param(1)=0;
end
for j=1:n_samples
    sub_cuts{j} = cut(the_2Dcuts{j},0.02,en_range);

    valid(j) = sub_cuts{j}.num_pixels>0;
    if valid(j)
        nplots = nplots+1;
    end
end
if ~batch
    clear clObj;
end
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
debug_code = false;
if debug_code && isfile('refit_singleset_debug.mat')
    ld = load('refit_singleset_debug.mat');
    fit_obj = ld.fit_obj_mem;
else
    kk = tobyfit(sub_cuts{:});
    kk = kk.set_fun(@sqw_iron);
    kk = kk.set_pin({init_fg_param,hkl_proj});
    kk = kk.set_free(free_sw_param);
    [fit_obj,fit_par] = kk.simulate();
    if debug_code
        fit_obj_mem = fit_obj;
        save('refit_singleset_debug.mat','fit_obj_mem');
    end

end
if n_samples == 1
    fit_obj = {fit_obj};
end

chunks_nums = zeros(1,n_samples);
for i=1:n_samples
    obj_i = fit_obj{i};
    range = min_max(obj_i.data.p{1});
    chunks_nums(i) = round(range(2)-range(1));
end
n_chunks_tot = sum(chunks_nums);
chunks = cell(1,n_chunks_tot);

n_ch = 1;
ignored_chunks_provided = isfield(fit_par_in,'valid_chunks');
if ignored_chunks_provided
    ch_valid  = fit_par_in.valid_chunks;
else
    ch_valid = true(1,n_chunks_tot);
end
fit_chunks = cell(1,sum(chunks_nums));
for i=1:n_samples
    obj_i = fit_obj{i};
    x_min = obj_i.data.p{1}(1);
    n_valid_ch = 0;
    for j=1:chunks_nums(i)
        x_max = x_min+1;
        dnd_obj = cut(obj_i,[x_min,0.02,x_max],[en_range(1),en_range(3)],'-nopix');

        if ignored_chunks_provided && ~ch_valid(n_ch)
            n_ch = n_ch + 1;
            x_min = x_max; %
            continue;
        else
            if (sum(dnd_obj.npix(:))==0)
                ch_valid(n_ch) = false;
                n_ch = n_ch + 1;
                x_min = x_max; %
                continue;
            end
        end
        one_peak_ch = IX_dataset_1d(dnd_obj);
        x_ax = 0.5*(one_peak_ch.x(1:end-1)+one_peak_ch.x(2:end));
        [~,I] = max(one_peak_ch.signal);
        MIM = min_max(one_peak_ch.signal');
        peak_lim = (MIM(2)-MIM(1))*peak_scale;
        keep = one_peak_ch.signal>=(peak_lim+MIM(1));
        pii = find(keep);
        mii = min_max(pii');
        if mii(1)==I || mii(2) == I % max out of range
            ch_valid(n_ch) = false;
            n_ch = n_ch + 1;
            x_min = x_max; %
            continue;
        end
        x_contr = x_ax(keep);
        cut_range = min_max(x_contr);
        chunks{n_ch} = cut(sub_cuts{i},[cut_range(1),0.02,cut_range(2)],[]);
        if ~do_fit
            fit_chunks{n_ch} = cut(obj_i,[cut_range(1),0.02,cut_range(2)],[en_range(1),en_range(3)],'-nopix');
        end

        n_ch = n_ch + 1; % Increment the chunk index
        x_min = x_max; % Update x_min for the next chunk
        n_valid_ch = n_valid_ch +1;
    end
    chunks_nums(i) = n_valid_ch;
end
n_chunks_tot = sum(chunks_nums);
if ~any(ch_valid)
    fit_obj = [];
    fit_par = [];
    figa = [];
    figb = [];
    return
end

chunks = chunks(ch_valid);
if ~do_fit
    fit_obj = fit_chunks(ch_valid);
    [figa,figb]=plot_result(sub_cuts,fit_obj,chunks_nums,fit_par,false,[en_range(1),en_range(3)]);
    return
end


bg_param  = cell(1,n_chunks_tot);
init_bg_param = init_bg_param(valid);
n_ch = 1;
for i=1:n_samples
    for j=1:chunks_nums(i)
        bg_param{n_ch} = init_bg_param{i};
        n_ch = n_ch+1;
    end
end


kk = tobyfit(chunks{:});

init_fg_param(1) = 1;
kk = kk.set_fun(@sqw_iron);
kk = kk.set_pin({init_fg_param,hkl_proj});
kk = kk.set_free(free_sw_param);

%kk = kk.set_global_background();
kk = kk.set_bfun (@double_exp2D); % set_bfun sets the background functions
kk = kk.set_bpin (bg_param);  % initial background constant and gradient
bfree = zeros(1,numel(bg_param{1}));
kk = kk.set_bbind({[1,2],[1,1],1},{[1,4],[1,3],1},{[1,5],[1,4],1});


bfree(1)=1; % allow modifying bg intensity and slope?
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
fit_par.valid_chunks = ch_valid;
fit_par.en = 0.5*(en_range(1)+en_range(3));
fit_par.en_range = en_range;
if ~iscell(fit_obj)
    fit_obj = {fit_obj};
end

if nargout<3
    return;
end

[figa,figb]=plot_result(sub_cuts,fit_obj,chunks_nums,fit_par,eval_sw,[en_range(1),en_range(3)]);

end

function [figa,figb] =plot_result(sub_cuts,fit_obj,chunks_nums,fit_par,eval_sw,en_range)
if isempty(fit_par)
    eval_sw = false;
end
sel = logical([0,0, 1,1,0,1,0,0, 0,0]);
colour={'k','k','r','r','g','g'};
gp = genieplot.instance();
n_ch = 1;
nplots = numel(sub_cuts);
for j=1:nplots
    gp.line_widths = 0.5;
    if sub_cuts{j}.dimensions() == 2
        w1 = cut(sub_cuts{j},[],en_range,'-nopix');
    else
        w1  = sub_cuts{j};
    end
    acolor(colour{2*j-1});
    if j == 1
        if ~isempty(fit_par)
            cont = fit_par.p(sel);
            sig =  fit_par.sig(sel);
            title = sprintf("S=%4.2g±%4.2g; J0=%4.2g±%4.2g; gamma=%g±%g", ...
                cont(2),sig(2),cont(3),sig(3),cont(1),sig(1));
        else
            title = '';
        end
        w1.axes.title = title;
        plot(w1);liny;
    else
        pd(w1);
    end
    acolor(colour{2*j});
    gp.line_widths = 2;
    for ii=1:chunks_nums(j)
        if fit_obj{n_ch}.dimensions() == 2
            w1fit = cut(fit_obj{n_ch},[],en_range,'-nopix');
        else
            w1fit = fit_obj{n_ch};
        end
        pl(w1fit);
        drawnow;
        n_ch = n_ch+1;
    end
end
figa = gcf;

if eval_sw
    keep_figure;
    for j=1:nplots
        gp.line_widths = 0.5;
        if sub_cuts{j}.dimensions() == 2
            w1 = cut(sub_cuts{j},[],en_range);
        else
            w1  = sub_cuts{j};
        end
        acolor(colour{2*j-1});
        if j == 1
            plot(w1);liny;
        else
            pd(w1);
        end
        acolor(colour{2*j});
        gp.line_widths = 2;
        w1fit = sqw_eval(w1,@sqw_iron,{fit_par.p,w1.data.proj});
        w1fit.data.axes.title = '2D fit evaluated on 1D dataset';
        pl(w1fit);
        drawnow;
    end
    figb = gcf;
    keep_figure;
else
    figb = [];
end


end