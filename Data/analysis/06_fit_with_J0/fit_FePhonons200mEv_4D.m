if ~exist('phonons_bg','var')
    phonons_bg = sqw('sqw200meV_Bz_bg_with_pix.sqw');
end
mi = maps_instrument(200,600,'S');
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);

phonons_bg = phonons_bg.set_instrument(mi);
phonons_bg = phonons_bg.set_sample(sample);    
phonons_bg = cut(phonons_bg,[],[],[],[0,2,60]);

en = 40;
w2 = cut(phonons_bg,[],[],[-0.05,0.05],[en-2,en+2]);


%A1 = 112;  B1 = 60;
%A2 = 10;   B2 =  5;
%A3 =  5;   B3 =  3;
%A4 =  2;   B4 =  1;
%A5 =  1;   B5 = 0.5;  
AmG = [344.3769 5.1587 9.9694];
A = [167.8122 -9.1171 16.0964 510.4658 6.0368];
B = [47.5674 2.0426 -10.2780 -41.9252 41.8040];
%364.3272    6.4892   12.0689  
% 112.2268  -12.3937   29.2775  331.6717   73.9542
% 60.8932  -11.5321%  -10.8261   -6.5851   60.4841
%A = [A1 A2 A3 A4 A5];
%B = [B1 B2 B3 B4 B5];

%Am = 360;
%G1 = 6;
%G2 = 12;


%init_fg_params = [coffect_ff,T,gamma,Seff, gap, J0, J1, J2, J3, J4];
init_fg_params = [AmG1,A,B];
free_ph_param  = ones(1,numel(init_fg_params ));

kk = tobyfit(phonons_bg);
kk = kk.set_fun(@iron_phonons);
kk = kk.set_pin(init_fg_params);
kk = kk.set_free(free_ph_param);
%kk = kk.set_bfun (@linear_bg); % set_bfun sets the background functions
%kk = kk.set_bpin ([0.05, 0]);   % initial background constant and gradient
%kk = kk.set_bfree ([1, 0]);   
kk = kk.set_options('list',2);
%[fit_obj,par] = kk.simulate();
[fit_obj,fit_par] = kk.fit();
w2mod= cut(fit_obj,[0.04],[-0.1,0.1],[-0.05,0.05],[0,2,60]);
plot(w2mod); keep_figure;
%acolor k;
%plot(w1);
%acolor r;
%pl(fit_obj);