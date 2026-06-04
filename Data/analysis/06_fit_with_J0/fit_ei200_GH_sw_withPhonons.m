function [fit_obj,fit_par]=fit_ei200_GH_sw_withPhonons(fobj,do_fit)
if nargin<2
    do_fit = true;
end

persistent cuts2fit200;
if nargin<1
    root_path = fileparts(mfilename("fullpath"));
    data_path = fullfile(root_path,'sym4D_cutsAndFits');

    if isempty(cuts2fit200)
        ld = load(fullfile(data_path,'multicuts_fit_dataGH_ei200meV.mat'));
        cuts2fit200 = ld.cuts2fit200;
    end
    cuts_list = cuts2fit200.cuts_list(1);
else
    cuts_list = {fobj};
end

mi = maps_instrument(200,600,'S');
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
for i=1:numel(cuts_list)
    cuts_list{i} = cuts_list{i}.set_instrument(mi);
    cuts_list{i} = cuts_list{i}.set_sample(sample);
end

%with phonons here:
%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, gf, af, SWA, J4];
correct_ff = 1;
T   = 8;
gap = 0;    %
gamma = 87.23;
Seff =2.6;      %1.4489;
J0 = 36.24;       %51.6079;


init_fg_params = [correct_ff,T,gamma,Seff, gap, J0, 5.5, 24, 40.0, 0];
free_sw_param  = [0          0, 1   ,1   , 0,    1, 0,   0,  0,  0];

cuts_list{1} = cut(cuts_list{1},[],[1,2,120]);
plot(cuts_list{1}); liny; lz 0 1; keep_figure;

hkl_proj = cuts_list{1}.data.proj;
%w0 = cut(cuts_list{1},[-0.5,1],[0,5]);
%bg_param = [w0.data.s,10];
bg_param = [6.4,0.33];


kk = tobyfit(cuts_list{:});
kk = kk.set_fun(@sqw_iron_with_phonons);
kk = kk.set_pin({init_fg_params,hkl_proj});
kk = kk.set_free(free_sw_param);
kk = kk.set_bfun (@exp_bg2D); % set_bfun sets the background functions
%kk = kk.set_bfun (@linear_bg2D); % set_bfun sets the background functions
kk = kk.set_bpin (bg_param);  % initial background constant and gradient
kk = kk.set_bfree ([0, 0]);
%kk = kk.set_bfree ([1, 0, 1]);
kk = kk.set_options('list',2);

if do_fit
    [fit_obj,fit_par] = kk.fit();
else
    [fit_obj,fit_par] = kk.simulate();
end
plot(fit_obj); lz 0 1; keep_figure;

end
