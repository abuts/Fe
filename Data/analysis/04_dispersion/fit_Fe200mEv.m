if ~exist('all_cuts200mEv','var')
    ld = load('all_cutsFe_ei200_all_bg_4D_reducedBZ_no_ff.mat');
    all_cuts200mEv = ld.all_cuts;
end
all_cuts = all_cuts200mEv;
mi = maps_instrument(200,600,'S');
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
keys = all_cuts.keys;
for i=1:numel(keys)
    all_cuts(keys{i}) = all_cuts(keys{i}).set_instrument(mi);
    all_cuts(keys{i}) = all_cuts(keys{i}).set_sample(sample);    
end
w1 = cut(all_cuts('GN'),[],[100-2,100+2]);

correct_ff = 1;
T   = 8;
gap = 0;    %
gamma = 33.36;
%Seff = 2;   % 
Seff =0.87;      %1.4489;
%J1 = 40;    % 6
J0 = 30.91;       %51.6079;
J1 = 1.4097;         %1.4083;
J2 = -8.4474;       %-8.4407;
J3 = -0.7469;       %-0.7448;
J4 = 0.6056;        %0.6047;

%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, J1, J2, J3, J4];
init_fg_params = [correct_ff,T,gamma,Seff, gap, J0, 0,   0, 0,   0];
free_sw_param  = [0          0, 1   ,1   , 0,    1, 0,   0,  0,  0];

kk = tobyfit(w1);
kk = kk.set_fun(@sqw_iron);
kk = kk.set_pin({init_fg_params,w1});
kk = kk.set_free(free_sw_param);
kk = kk.set_bfun (@linear_bg); % set_bfun sets the background functions
kk = kk.set_bpin ([0.05, 0]);   % initial background constant and gradient
kk = kk.set_bfree ([1, 0]);   
kk = kk.set_options('list',2);
%[fit,par] = kk.simulate();
[fit_obj,fit_par] = kk.fit();
acolor k;
plot(w1);
acolor r;
pl(fit_obj);