function [disp,w2_tha,fp_arr1] = fit_GPPH_Ei800_SymOp()
Emax = 450;
dE   = 5;
Efit_min = 50;
Kun_width = 0.1;
Kun_sym = 3;

Dqk = [-0.1,0.1];
Dql = [-0.1,0.1];

proj = {projection([1,1,1],[1,-1,0],'uoffset',[0,0,0]),projection([-1,1,1],[1,1,0],'uoffset',[0,0,0]),...  !-1 !1
    projection([1,-1,1],[1,1,0],'uoffset',[0,0,0]),projection([1,1,-1],[1,-1,0],'uoffset',[0,0,0]),... !-1 !3
    projection([1,1,1],[1,-1,0],'uoffset', [1,-1,0]),projection([1,1,1],[1,-1,0],'uoffset',[-1,1,0]),... !-2 !5
    projection([1,1,-1],[1,-1,0],'uoffset',[1,-1,0]),projection([1,1,-1],[1,-1,0],'uoffset',[-1,1,0]),...!-2
    projection([-1,1,1],[1,1,0],'uoffset',[1,1,0]),projection([-1,1,-1],[1,1,0],'uoffset',[1,1,0]),...    !-3
    projection([-1,-1,1],[-1,1,0],'uoffset',[2,0,0]),projection([-1,-1,-1],[-1,1,0],'uoffset',[2,0,0]), ... !-4
    projection([-1,-1,1],[-1,1,0],'uoffset',[0,2,0]),projection([-1,-1,-1],[-1,1,0],'uoffset',[0,2,0]),...  !-4
    projection([-1,1,1],[1,1,0],'uoffset',[2,0,0]),projection([-1,1,-1],[1,1,0],'uoffset',[2,0,0]),...   !-5
    projection([1,-1,1],[1,1,0],'uoffset',[0,2,0]),projection([1,-1,-1],[1,1,0],'uoffset',[0,2,0])};    %!-5
kun_sym_dir = [1,1,1,1,  2,2,2,2, 2,2, 1,1,1,1,1,1,1,1];
% trying to extract mainly PH part
proj = {projection([-1, 1,1],[1,1,0],'uoffset',[0,1,0]),projection([-1,1,-1],[-1,1,0],'uoffset',[0,1,0]),...
    projection([1,1,1],[1,-1,0],'uoffset',[0,1,0]),projection([1,1,-1],[1,-1,0],'uoffset',[0,1,0]),...
    projection([1,-1,1],[1,-1,0],'uoffset',[1,0,0]),projection([1,1,1],[1,-1,0],'uoffset',[1,0,0]),...
    projection([1,-1,-1],[1,-1,0],'uoffset',[1,0,0]),projection([1,1,-1],[1,-1,0],'uoffset',[1,0,0])};
kun_sym_dir = [3,3,3,3,4,4,4,4];
dat = fullfile(pwd,'sqw','data','Fe_ei787.sqw');


% selected projections:
proj = {projection([-1, 1,1],[1,1,0],'uoffset',[0,1,0]),projection([1,1,1],[1,-1,0],'uoffset',[0,1,0])};
sym_op = {symop([0,0,1],90,[0,1,0]),symop([1,1,0],[0,0,1],[0,0,0]),...
    [symop([0,0,1],90,[0,1,0]),symop([1,1,0],[0,0,1],[0,0,0])]};
kun_sym_dir = [3,3];


proj = {projection([-1,1,1],[1,1,0],'uoffset',[3,0,0]),projection([-1,-1,1],[1,-1,0],'uoffset',[3,0,0]),...
    projection([-1,1,-1],[1,1,0],'uoffset',[3,0,0]),projection([-1,-1,-1],[1,-1,0],'uoffset',[3,0,0]),...
    projection([-1, -1,1],[1,-1,0],'uoffset',[0,3,0]),projection([1, -1,1],[1,-1,0],'uoffset',[0,3,0]),...
    projection([-1, -1,-1],[1,-1,0],'uoffset',[0,3,0]),projection([1, -1,-1],[1,-1,0],'uoffset',[0,3,0])};
%sym_op = {[symop([1,1,0],[0,0,1],[0,0,0]),symop([0,0,1],-90,[0,3,0])]};
sym_op = {symop([0,0,1],90,[3,0,0]),... % 2v
    symop([1,1,0],[0,0,1],[0,0,0]),...     % 3 v
    [symop([1,1,0],[0,0,1],[0,0,0]),symop([0,0,1],-90,[0,3,0])],... %4  v
    [symop([1,0,0],[0,1,0],[0,0,0]),symop([0,0,1],90,[3,0,0])],... % 5 x ),
    symop([1,0,0],[0,-1,0],[0,0,0]),... % 6 v
    [symop([1,0,0],[0,-1,0],[0,0,0]),symop([1,1,0],[0,0,1],[0,0,0])],... %7 x
    [symop([1,1,0],[0,0,1],[0,0,0]),symop([0,0,1],-90,[0,3,0]),symop([1,0,0],[0,-1,0],[0,0,0])]... %8x
    };

kun_sym_dir = [4,4,4,4,3,3,3,3];

sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);


[com_cut,part_cuts] = cut_sqw_sym(dat,proj{1},[-3,0.01,3],Dqk ,Dql ,[0,dE,600],sym_op);
for i=1:numel(part_cuts)
    plot(part_cuts(i));
    ly 0 500
    lz  0 0.05
end
plot(com_cut);
lz  0 0.05
lb=cut_sqw(com_cut,proj{1},[-3,3],Dqk ,Dql ,[60,dE,300],'-nopix');
en = lb.p{1};
en = 0.5*(en(2:end)+en(1:end-1));
s  = log(lb.s);
par = polyfit(en,s,1);
A = exp(par(2));
Alpha = par(1);
lb=cut_sqw(com_cut,proj{1},[-3,3],Dqk ,Dql ,[0,dE,600],'-nopix');
ff = func_eval(lb,@(x,par)(A*exp(Alpha*x)),[]);
acolor('k');
plot(lb)
acolor('r');
pl(ff);

% keep_figure
% sym_cut = symmetrise_sqw(com_cut,[-1,1,0]/sqrt(2),[-1,-1,2]/sqrt(6),[2,1,1]);
% plot(sym_cut);
% lz  0 0.5
% lx -3 3
% keep_figure
sym_cut = com_cut;
% good background removal values: [0.3866,0.0140]
% [0.3274  0.02432] -- strange problem
%bg = func_eval(sym_cut,@(q,en,par)(par(1)*exp(-par(2)*(en-50))),[0.3866,0.0140]);
bg = func_eval(sym_cut,@(q,en,par)(par(1)*exp(-par(2)*(en))),[A,-Alpha]);
disp = sym_cut-bg;
plot(disp );
lz  0 0.05
lx 0 3
keep_figure
ff = MagneticIons('Fe0');
disp_nice = ff.correct_mag_ff(disp);
disp_nice = smooth(d2d(disp_nice));
plot(disp_nice);
lz  0 0.05
lx 0 1
ly 0 500
keep_figure

com_cut= set_sample_and_inst(sym_cut,sample,@maps_instrument_for_tests,'-efix',800,'S');
w2_tha = sqw_eval(com_cut,@disp_kun_calc,[1,0,Kun_sym,kun_sym_dir(1),Kun_width]);
plot(w2_tha);
lz  0 1
lx 0 3
fp_arr1 = [];
sym_cut = symmetrise_sqw(w2_tha,[-1,1,0]/sqrt(2),[-1,-1,2]/sqrt(6),[2,1,1]);
plot(sym_cut);
lz  0 0.5
lx -3 3
keep_figure

% kk = tobyfit(com_cut);
% kk = kk.set_fun(@disp_kun_calc,[0.3098,0,Kun_sym,kun_sym_dir(1),Kun_width],[1,0,0,0,0]);
% kk = kk.set_bfun(@(q,en,par)(par(1)*exp(-par(2)*(en-50))),[0.3866,0.0140]);
% 
% kk = kk.set_mc_points(10);
% %profile on;
% kk = kk.set_options('listing',2,'fit_control_parameters',[1.e-2;60;1.e-3]);
% %kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
% %profile on;
% %[w2D_arr1_tf,fp_arr1]=kk.simulate;
% [w2D_arr1_tf,fp_arr1]  =kk.fit;
% 
% plot(w2D_arr1_tf)




%ly -2.5 2.5
