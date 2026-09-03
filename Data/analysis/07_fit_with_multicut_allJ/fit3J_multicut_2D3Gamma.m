cuts_file = 'e:\SHARE\Fe\Data\analysis\07_fit_with_multicut_allJ\sel_cuts\J0_3fitOff110Cuts.mat';
if(~exist("multij_110","var"))
    ld = load(cuts_file);
    multij_110 = ld.fit_src_struc;
end


fn = fieldnames(cut_par);
n_cuts = numel(fn);


cuts_list = cell(1,n_cuts);
is_400 = false(1,n_cuts);

for i=1:n_cuts
    src_cut = multij_110.(fn{i});
    is_400(i)= contains(fn{i},'Ei400');    
    bg_field_name = [fn{i},'_2exp_bg'];
    bg_Qrange = min_max(src_cut.data.p{1});
    bg_Erange = min_max(src_cut.data.p{2});
    bg_Erange(1) = max(20,bg_Erange(1));
    multij_110 = fit_1DsBg_helper(multij_110,src_cut,bg_Qrange, ...
        [bg_Erange(1),2,bg_Erange(2)],[0,-3,0],bg_field_name,true);

    cuts_list{i} = src_cut;
    plot(cuts_list{i});liny;lz 0 1;
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
end

res_file = 'fit3J_multicut1D3Gamma.mat';
bfree = zeros(1,2);
bfree(1)=1;    

if isfile(res_file)
    ld = load(res_file);
    init_fg_param = ld.fit_par.p;
    bg_par = ld.fit_par.bp;
    init_fg_param = [init_fg_param(1:2),repmat(init_fg_param(3),1,3),...
        repmat(init_fg_param(4),1,3),init_fg_param(6:8)];
else
    correct_ff = 1;
    T   = 8;
    gap = 0;    %
    gamma =  79*ones(1,3);
    Seff0 =1.9*ones(1,3);      %1.4489;
    J0 = 37;
    J1 = 1;
    J2 = 1;
    init_fg_param = [correct_ff,T,gamma,Seff0, J0, J1,  J2,  0,  0];
    bg_par = zeros(1,2);
end

%init_fg_params = [coffect_ff,T,gamma,     Seff,          J0, J1, J2];
free_sw_param  =  [0          0, ones(1,3) ,ones(1,3)   , 1, 1,   1];


kk = tobyfit(cuts_list{:});

%kk = kk.set_fun(@sqw_iron_with_phonons);
kk = kk.set_fun(@sqw_iron_multiG);
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

