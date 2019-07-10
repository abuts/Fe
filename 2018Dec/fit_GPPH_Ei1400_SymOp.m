function [disp,w2_tha,fp_arr1] = fit_GPPH_Ei1400_SymOp()
dat = fullfile(pwd,'sqw','data','Fe_ei1371_base.sqw');
Emax = 450;
dE   = 5;
Efit_min = 50;
Kun_width = 0.1;
Kun_sym = 3;

Dqk = [-0.1,0.1];
Dql = [-0.1,0.1];


proj = {projection([1,1,1],[1,-1,0],'uoffset',[0,1,0]),projection([-1,1,1],[1,1,0],'uoffset',[0,-1,0]),...  !-1 !1
    projection([1,1,-1],[1,-1,0],'uoffset',[0,1,0]),projection([-1,1,-1],[1,1,0],'uoffset',[0,-1,0]),...
    projection([1,1,1],[1,-1,0],'uoffset',[1,0,0]),projection([1,1,-1],[1,-1,0],'uoffset',[1,0,0]),...
    projection([1,-1,1],[1,-1,0],'uoffset',[1,0,0]),projection([1,-1,-1],[1,-1,0],'uoffset',[1,0,0]),...
    };    %!-5
kun_sym_dir = [3,3,3,3, 4,4,4,4]; %



%sym_op = {[symop([0,0,1],90,[0,1,0]),symop([1,0,0],[0,1,0],[0,0,0]),symop([1,1,0],[0,0,1],[0,0,0])]};
sym_op = {symop([1,0,0],[0,1,0],[0,0,0]), symop([1,0,0],[0,1,0],[0,0,0]),...
    [symop([1,0,0],[0,1,0],[0,0,0]),symop([1,0,0],[0,0,1],[0,0,0])],...;
    symop([1,1,0],[0,0,1],[0,0,0]),...
    [symop([1,0,0],[0,1,0],[0,0,0]),symop([1,1,0],[0,0,1],[0,0,0])]...     % 3 v
    [symop([0,0,1],90,[0,1,0]),symop([1,1,0],[0,0,1],[0,0,0])],...
    [symop([0,0,1],90,[0,1,0]),symop([1,0,0],[0,1,0],[0,0,0]),symop([1,1,0],[0,0,1],[0,0,0])]...
    };



sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);


[com_cut,part_cuts] = cut_sqw_sym(dat,proj{1},[-3,0.01,3],Dqk ,Dql ,[0,dE,600],sym_op);
for i=1:numel(part_cuts)
    plot(part_cuts(i));
    ly 0 500
    lz  0 0.05
end
plot(com_cut);
lz  0 0.5
keep_figure
% sym_cut = symmetrise_sqw(com_cut,[1,1,0],[0,0,1],[3,0,0]);
% plot(sym_cut);
% lz  0 0.05
% lx 0 3
%keep_figure
sym_cut = com_cut;
bg = func_eval(sym_cut,@(q,en,par)(par(1)*exp(-par(2)*(en-50))),[0.1537,0.0310]);
disp = sym_cut-bg;
plot(disp );
lz  0 0.05
lx 0 3
keep_figure
ff = MagneticIons('Fe0');
disp_nice = ff.correct_mag_ff(disp);
disp_nice = smooth(d2d(disp_nice));
plot(disp_nice);
lz  0 0.5
lx 0 1
ly 0 500
keep_figure

com_cut= set_sample_and_inst(sym_cut,sample,@maps_instrument_for_tests,'-efix',600,'S');
w2_tha = sqw_eval(com_cut,@disp_kun_calc,[1,0,Kun_sym,kun_sym_dir(1),Kun_width]);
plot(w2_tha);
lz  0 1
lx 0 3
fp_arr1 = [];

% kk = tobyfit(com_cut);
% kk = kk.set_fun(@disp_kun_calc,[0.2546,1,Kun_sym,kun_sym_dir(1),Kun_width],[1,0,0,0,0]);
% kk = kk.set_bfun(@(q,en,par)(par(1)*exp(-par(2)*(en-50))),[0.1537,0.0310]);
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
