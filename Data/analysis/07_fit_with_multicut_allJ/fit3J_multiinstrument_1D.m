cuts_file = 'e:\SHARE\Fe\Data\analysis\07_fit_with_multicut_allJ\sel_cuts\J0_3fitOff110Cuts.mat';
if(~exist("multij_110","var"))
    ld = load(cuts_file);
    multij_110 = ld.fit_src_struc;
end

cut_par = struct();
cut_par.Ei200_off110GH = {{[],[40,50]},{[],[70,80]}};
cut_par.Ei400_off110GH = {{[],[100,110]},{[],[160,170]}};
cut_par.Ei200_off110GP = {{[],[50,60]},{[],[100,110]}};
cut_par.Ei400_off110GP = {{[],[90,100]},{[],[140,150]}};
cut_par.Ei200_off110NG = {{[],[50,60]},{[],[100,110]}};
cut_par.Ei400_off110NG = {{[],[110,120]},{[],[150,160]}};
cut_par.Ei400_off210HN = {{[],[210,220]},{[],[220,230]}};

fn = fieldnames(cut_par);
n_cuts = numel(fn);
n_1Dcuts = 2*n_cuts;

cuts_list = cell(1,2*n_cuts);
is_400 = false(1,2*n_cuts);

for i=1:n_cuts
    src_cut = multij_110.(fn{i});
    lcut_par = cut_par.(fn{i});
    nlkp = numel(lcut_par);
    for j=1:nlkp
        ij= nlkp*(i-1)+j;
        is_400(ij)= contains(cut_names{i},'Ei400');
        llpar = lcut_par{j};
        cuts_list{ij} = cut(src_cut,llpar{:});
    end
end

mi200 = maps_instrument(200,600,'S');
mi400 = maps_instrument(401,600,'S');
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
hkl_proj = repmat(line_proj(),1,n_1Dcuts);
for i=1:n_1Dcuts
    if is_400(i)
        cuts_list{i} = cuts_list{i}.set_instrument(mi400);
    else
        cuts_list{i} = cuts_list{i}.set_instrument(mi200);
    end
    cuts_list{i} = cuts_list{i}.set_sample(sample);
    hkl_proj(i) = cuts_list{i}.data.proj;
    plot(cuts_list{i});
end

res_file = 'SetOf1DCutsEi200Ei400off110cuts_fit_par.mat';
bfree = zeros(1,2);
bfree(1)=1;    

if isfile(res_file)
    ld = load(res_file);
    init_fg_param = ld.fit_par.p;
    bg_par = ld.fit_par.bp;
else
    correct_ff = 1;
    T   = 8;
    gap = 0;    %
    gamma =  79;
    Seff0 =1.9;      %1.4489;
    J0 = 37;
    J1 = 0;
    J2 = 0;
    init_fg_param = [correct_ff,T,gamma,Seff0, gap, J0, J1,  J2,  0,  0];
    bg_par = zeros(1,2);
end

%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, J1, J2, J3, J4];
free_sw_param  =  [0          0, 1   ,1   , 0,    1, 1,   1, 0,  0];


kk = tobyfit(cuts_list{:});

%kk = kk.set_fun(@sqw_iron_with_phonons);
kk = kk.set_fun(@sqw_iron);
kk = kk.set_pin({init_fg_param,hkl_proj});
kk = kk.set_free(free_sw_param);

kk = kk.set_bfun (@linear_bg1D); % set_bfun sets the background functions

kk = kk.set_bpin (bg_par);  % initial background constant and gradient
kk = kk.set_bfree (bfree);

kk = kk.set_options('list',2);
[fit_obj,fit_par] = kk.fit();
for i=1:n_1Dcuts
    pd(cuts_list{j});
    pl(fit_obj{j});
    keep_figure;
end

