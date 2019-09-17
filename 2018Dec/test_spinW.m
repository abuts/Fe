%%

J1 = 2*2.0058
J2 = 2*0.0579
D = -0.0062

J1 = 4.012   
J2 = 0.1158      
D = -0.006188 

%J1 = 2*2.05129
%J2 = 2*0.15716
%D = 0.00414

rbnicl3 = spinw

rbnicl3.genlattice('lat_const',[6.955 6.955 5.906*2],'spgr','P 63/m m c','angled',[90 90 120])
rbnicl3.addatom('r',[0 0 0],'S',1,'label','MNi2','color','b')
rbnicl3.addmatrix('label','J1','value',J1,'color','red')
rbnicl3.addmatrix('label','J2','value',J2,'color','green')
rbnicl3.addmatrix('value',diag([0 0 D]),'label','D','color','r')
rbnicl3.gencoupling

rbnicl3.addcoupling('mat','J1','bond',1)
rbnicl3.addcoupling('mat','J2','bond',2)
rbnicl3.addaniso('D')
rbnicl3.genmagstr('mode','helical','k',[1/3 1/3 1],'n',[0 1 0],'S',[0; 0; 1])

%rbnicl3.addmatrix('label','DM1','value',0);
%rbnicl3.addcoupling('mat','DM1','bond',1)
%rbnicl3.getmatrix('mat','DM1');

%plot(rbnicl3)%,'range',[2 2 1])
%cpars = {'coordtrans', diag([1 1 1 1])}

cpars = {'mat', {'J1', 'J2', 'D'},'hermit', true, 'optmem', 0, 'useFast', true, 'formfact', true, 'resfun', 'gauss'};
cpars = {'mat', {'J1', 'J2', 'D'},'hermit', false, 'optmem', 0, 'useFast', false, 'formfact', true, 'resfun', 'gauss'};

hs = [-0.5 -0.33 0 0.33 0.5 1];
proj = projaxes([0 0 1], [1 1 0]);
sqw_file = fullfile(pwd,'sqw','data','Fe_ei787.sqw');
for h = 1:numel(hs)
    %sqw_file = sprintf('rbnicl3_unpol.sqw', 15);
    ws_cut(h) = cut_sqw(sqw_file, proj, [-2.5,0.035,2.5], [-0.05+hs(h),0.05+hs(h)], [-inf,inf], [1.25,0.05,10]);
end

ls = [-2 -1.5 -1 -0.5 0 0.5 1 1.5 2];
proj = projaxes([0 0 1], [1 1 0]);
for l = numel(hs)+1:numel(hs)+numel(ls);
    %sqw_file = sprintf('rbnicl3_unpol.sqw', 15);
    ws_cut(l) = cut_sqw(sqw_file, proj, [-0.05+ls(l-numel(hs)),0.05+ls(l-numel(hs))], [-2.5,0.035,2.5], [-inf,inf], [1.25,0.05,10])
end

num_tot = numel(hs)+numel(ls)

fwhm = 0.9;  % Typical resolution ~ 3% of Ei                

%kk1 = multifit_sqw (d2d(ws_cut))
%kk1 = kk1.set_bfun (@linear_bg)
%kk1 = kk1.set_bpin({[0.00001, 0.0]}); 	
%kk1 = kk1.set_bfree ([1,0]); 
%[bsim, fp] = kk1.fit;

kk = multifit_sqw (d2d(ws_cut))
kk = kk.set_fun (@rbnicl3.horace_sqw, {[J1 J2 D fwhm] cpars{:}}); 
kk = kk.set_free ([1, 1, 1, 1]); 
kk = kk.set_bfun (@linear_bg)
kk = kk.set_bpin({[0.00001, 0.0]}); 	
kk = kk.set_bfree ([1,0]);   
kk = kk.set_options ('list',2); 

swpref.setpref('usemex',false);  
% Time a single iteration 
%tic 
%wsim = kk.simulate; 
%t_spinw_single = toc;

[wsim, fp] = kk.fit;

for h = 1:num_tot;
 save_xye(wsim(h),strcat('wsim', num2str(h), '.dat'))
 save_xye(ws_cut(h),strcat('wcut', num2str(h), '.dat'))
end


J1 = fp(1)
J2 = fp(2)
D = fp(3)
fwhm = fp(4)

%wss = symmetrise_sqw(ws_cut(1),[1 1 0],[1 0 0],[0 0 0]);
%spaghetti_plot([compact(d2d(wss)) compact(wsim)]);
%lz 0 2
%surf(peaks);
for h = 1:num_tot;
 save_xye(wsim(h),strcat('wsim', num2str(h), '.dat'))
 save_xye(ws_cut(h),strcat('wcut', num2str(h), '.dat'))
end

rbnicl3 = spinw

rbnicl3.genlattice('lat_const',[6.955 6.955 5.906*2],'spgr','P 63/m m c','angled',[90 90 120])
rbnicl3.addatom('r',[0 0 0],'S',1,'label','MNi2','color','b')
rbnicl3.addmatrix('label','J1','value',J1,'color','red')
rbnicl3.addmatrix('label','J2','value',J2,'color','green')
rbnicl3.addmatrix('value',diag([0 0 D]),'label','D','color','r')
rbnicl3.gencoupling

rbnicl3.addcoupling('mat','J1','bond',1)
rbnicl3.addcoupling('mat','J2','bond',2)
rbnicl3.addaniso('D')
rbnicl3.genmagstr('mode','helical','k',[1/3 1/3 1],'n',[0 1 0],'S',[0; 0; 1])

odcut(1) = cut_sqw(sqw_file, proj, [-0.05+1,0.05+1], [-0.05+1,0.05+1], [-inf,inf], [1.25,0.05,10])
odcut(2) = cut_sqw(sqw_file, proj, [-0.05+1.5,0.05+1.5], [-0.05+1,0.05+1], [-inf,inf], [1.25,0.05,10])
odcut(3) = cut_sqw(sqw_file, proj, [-0.05+1,0.05+1], [-0.05+0.5,0.05+0.5], [-inf,inf], [1.25,0.05,10])
odcut(4) = cut_sqw(sqw_file, proj, [-0.05+0.5,0.05+0.5], [-0.05+0.5,0.05+0.5], [-inf,inf], [1.25,0.05,10])
odcut(5) = cut_sqw(sqw_file, proj, [-0.05+1,0.05+1], [-0.05+0.41,0.05+0.41], [-inf,inf], [1.25,0.05,10])
odcut(6) = cut_sqw(sqw_file, proj, [-0.05+1,0.05+1], [-0.05+0.31,0.05+0.31], [-inf,inf], [1.25,0.05,10])

for h = 1:6;
    save_xye(odcut(h),strcat('1dcut', num2str(h), '.dat'))
end

cpars = {'mat', {'J1', 'J2', 'D'},'hermit', false, 'optmem', 0, 'useFast', false, 'formfact', true, 'resfun', 'gauss'};
kk = multifit_sqw (d1d(odcut))
kk = kk.set_fun (@rbnicl3.horace_sqw, {[J1 J2 D fwhm] cpars{:}}); 
kk = kk.set_free ([1, 1, 1, 1]);
kk = kk.set_options ('list',2); 

tic 
wsim = kk.simulate; 
t_spinw_single = toc; 

for h = 1:6;
    save_xye(wsim(h),strcat('1dsim', num2str(h), '.dat'))
end
%close(f)

%rbnicl3Spec = rbnicl3.spinwave({[0 0 -2] [0 0 2] 500})
%rbnicl3Spec = rbnicl3.spinwave({[0 0 0] [1.5 1.5 0] 500})

%rbnicl3Spec = sw_neutron(rbnicl3Spec,'uv',{[0 0 1] [1 1 0]})

%rbnicl3Spec = rbnicl3.spinwave({[0 0 -2] [0 0 2] 500})
%rbnicl3Spec = rbnicl3.spinwave({[-1 -1 -1] [1.6 1.6 -1] 500})

%rbnicl3Spec = sw_egrid(rbnicl3Spec, 'Evect', linspace(0,13,100))
%rbnicl3Spec = sw_instrument(rbnicl3Spec,'dE',0.3)

%sw_plotspec(rbnicl3Spec,'mode','color','dE',0.25,'axLim',[0 15]);
%sw_plotspec(rbnicl3Spec,'mode','pretty','linestyle','-');
%colormap(jet)

%%
%Q-cut 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

