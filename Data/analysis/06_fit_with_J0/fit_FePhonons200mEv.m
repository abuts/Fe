if ~exist('all_cuts200mEv','var')
    ld = load('all_cutsFe_ei200_all_bg_4D_reducedBZ_no_ff.mat');
    all_cuts200mEv = ld.all_cuts;
end
all_cuts = all_cuts200mEv;

if ~exist('phonons_cuts','var')
    mi = maps_instrument(200,600,'S');
    sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
    keys = all_cuts.keys;
    for i=1:numel(keys)
        all_cuts(keys{i}) = all_cuts(keys{i}).set_instrument(mi);
        all_cuts(keys{i}) = all_cuts(keys{i}).set_sample(sample);
    end
    phonons_cuts = all_cuts;
    phonons_cuts('GH') = cut(all_cuts('GH'),[],[10,2,70]);
    phonons_cuts('GN') = cut(all_cuts('GN'),[],[10,2,70]);
    phonons_cuts('GP') = cut(all_cuts('GP'),[],[10,2,70]);
    phonons_cuts('NH') = cut(all_cuts('NH'),[],[8,2,70]);
    phonons_cuts('PN') = cut(all_cuts('PN'),[],[8,2,70]);
end


%A1 = 112;  B1 = 60;
%A2 = 10;   B2 =  5;
%A3 =  5;   B3 =  3;
%A4 =  2;   B4 =  1;
%A5 =  1;   B5 = 0.5;
%AmG = [349.9          4.936          12.08];
A1 = 16.88;    B1 = 15;
A2 = 14.63;    B2 = 0.55;
A3 =  0.92;    B3 = -0.57;
A4 = -0.12;    B4 = 0.03;
A5 = -0.29;    B5 = 0.32;
    
AmG = [286.7756 5.5016 9.4858];
%A = [3.7036e+03 141.3027 302.8061 -3.5211e+03   -120.0];
%A = 0.25*[3.7036e+03 141.3027 302.8061 -3.5211e+03   -120.0];
%B = 2.50e+2*[4.6777   -0.1244   -0.1522   -8.5274    0.129];

A = 4*[A1 A2 A3 A4 A5];
B = 4*[B1 B2 B3 B4 B5];%364.3272    6.4892   12.0689
% 112.2268  -12.3937   29.2775  331.6717   73.9542
% 60.8932  -11.5321%  -10.8261   -6.5851   60.4841
%A = [A1 A2 A3 A4 A5];
%B = [B1 B2 B3 B4 B5];

%Am = 360;
%G1 = 6;
%G2 = 12;


%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, J1, J2, J3, J4];
init_fg_params = [AmG,A,B];
free_ph_param  = ones(1,numel(init_fg_params ));

ph_cuts = phonons_cuts.values;

kk = tobyfit(ph_cuts{:});
kk = kk.set_fun(@iron_phonons);
kk = kk.set_pin(init_fg_params);
kk = kk.set_free(free_ph_param);
%kk = kk.set_bfun (@linear_bg); % set_bfun sets the background functions
%kk = kk.set_bpin ([0.05, 0]);   % initial background constant and gradient
%kk = kk.set_bfree ([1, 0]);
kk = kk.set_options('list',2);
%[fit_obj,par] = kk.simulate();
%[fit_obj,fit_par] = kk.fit();
fit_obj = sqw_eval(ph_cuts{1},@iron_phonons,init_fg_params,)
for i=1:numel(fit_obj)
    plot(fit_obj{i}); lz 0 2; keep_figure;
end
%w2mod= cut(fit_obj,[0.04],[-0.1,0.1],[-0.05,0.05],[0,2,60]);
%plot(w2mod); keep_figure;
%acolor k;
%plot(w1);
%acolor r;
%pl(fit_obj);