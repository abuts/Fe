%if ~exist('w2_fit_cut','var')
%    w2_fit_cut = cut('e:\SHARE\Fe\Data\sqw\sqw2011\Fe_ei787.sqw', ...
%        struct('u',[0,1,0],'v',[-1,0,0],'offset',[1,0,0]),[-2,0.04,4],[-0.1,0.1],[-0.1,0.1],[0,4,600]);
%    plot(w2_fit_cut); lz 0 1;    
%end
w2_test_cut = wm_800o11;
plot(w2_test_cut ); lz 0 1;    

sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
inst = maps_instrument(787,800,'S');
%ii = maps_instrument_for_tests(787,600,'S');
%source = IX_source('ISIS','',50);
%inst = IX_inst_DGfermi(ii.moderator,ii.aperture,ii.fermi_chopper,787,'-name','MAPS','-source',source);
w2_test_cut= w2_test_cut.set_sample(sample);
w2_test_cut = w2_test_cut.set_instrument(inst);
w1 = cut(w2_test_cut,[],[135,155]);
acolor k
plot(w1)

fit_par_range = [0,0,1,1,0,1,1,1,0,0];
init_fg_par = [1,8,70,1,0,34,0,0,0,0];
proj = w1.data.proj;
proj.offset = 0;
kk = tobyfit(w1);
%kk = kk.set_bfun(@(x,par)(par(1)+x*par(2)),[0.1,0]);
kk = kk.set_bfun(@linear_bg1D);
kk = kk.set_bpin ([0.1, 0]);  % initial background constant and gradient

kk = kk.set_fun(@sqw_iron,{init_fg_par,proj},fit_par_range);

[fit_obj,par] = kk.simulate();
acolor r
pl(fit_obj); keep_figure;