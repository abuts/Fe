cuts_file = 'e:\SHARE\Fe\Data\analysis\07_fit_with_multicut_allJ\sel_cuts\J0_3fitOff110Cuts.mat';
if(~exist("multij_110","var"))
    ld = load(cuts_file);
    multij_110 = ld.fit_src_struc;
end
cut_names = fieldnames(multij_110);
n_cuts = numel(cut_names);
cuts_list = cell(1,n_cuts);
is_400 = false(1,n_cuts);
is_sqw = true(1,n_cuts);
for i=1:n_cuts
    cuts_list{i} = multij_110.(cut_names{i});
    if ~isa(cuts_list{i},'sqw')
        is_sqw(i) = false;
        continue;
    end    
    is_400(i)= contains(cut_names{i},'Ei400');
end
cuts_list = cuts_list(is_sqw);
n_cuts = numel(cuts_list);

mi200 = maps_instrument(200,600,'S');
mi400 = maps_instrument(401,600,'S');
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
hkl_proj = repmat(line_proj(),1,n_cuts);
for i=1:n_cuts
    if is_400(i)        
        cuts_list{i} = cuts_list{i}.set_instrument(mi400);
    else
        cuts_list{i} = cuts_list{i}.set_instrument(mi200);        
    end
    cuts_list{i} = cuts_list{i}.set_sample(sample);
    hkl_proj(i) = cuts_list{i}.data.proj;
    plot(cuts_list{i}); lz 0 1; keep_figure;
end

correct_ff = 1;
T   = 8;
gap = 0;    %
gamma = 20;
Seff0 =1;      %1.4489;
J0 = 30;

init_fg_param = [correct_ff,T,gamma,Seff0, gap, J0, 0,  0,  0,  0];
%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, J1, J2, J3, J4];
free_sw_param  =  [0          0, 1   ,1   , 0,    1, 1,   1, 0,  0];


kk = tobyfit(cuts_list{:});

%kk = kk.set_fun(@sqw_iron_with_phonons);
kk = kk.set_fun(@sqw_iron);
kk = kk.set_pin({init_fg_param,hkl_proj});
kk = kk.set_free(free_sw_param);

%kk = kk.set_bfun (@double_exp2D); % set_bfun sets the background functions

%kk = kk.set_bpin (bg_par);  % initial background constant and gradient
%bfree = zeros(1,4);
%bfree(1)=1;
%kk = kk.set_bfree (bfree);

kk = kk.set_options('list',2);
[fit_obj,fit_par] = kk.fit();

