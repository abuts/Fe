function res = fix_Ei400(varargin)
if nargin>1
    dat = EnCutBlock.load(varagin{1});
    
else
    simulate = false;
    w_source = repmat(sqw,1,19);
    
    data_file = fullfile(pwd,'sqw','Data','Fe_ei401.sqw');
    
    prj1.u=[1,0,0];
    prj1.v=[0,1,0];
    prj1.uoffset=[0,0,0];
    
    prj2.u=[1,1,0];
    prj2.v=[1,-1,0];
    prj2.uoffset=[0,0,0];
    
    prj3.u=[1,-1,0];
    prj3.v=[1,1,0];
    prj3.uoffset=[0,0,0];
    
    prj1.uoffset = [0,-1,-1];
    w_source(1) = cut_sqw(data_file,prj1,[-0.8,0.025,0.8],[-0.1,0.1],[-0.1,0.1],[80,90]);
    w_source(2) = cut_sqw(data_file,prj1,[-0.1,0.1],[-0.1,0.1],[-0.8,0.025,0.8],[80,90]);
    
    prj1.uoffset = [1,0,-1];
    w_source(3)= cut_sqw(data_file,prj1,[-0.1,0.1],[-0.8,0.025,0.8],[-0.1,0.1],[80,90]);
    w_source(4)= cut_sqw(data_file,prj1,[-0.1,0.1],[-0.1,0.1],[-0.8,0.025,0.8],[80,90]);
    
    
    prj1.uoffset = [-1,-1,0];
    w_source(5)= cut_sqw(data_file,prj1,[-0.8,0.025,0.8],[-0.1,0.1],[-0.1,0.1],[80,90]);
    w_source(6)  = cut_sqw(data_file,prj1,[-0.1,0.1],[-0.1,0.1],[-0.8,0.025,0.8],[80,90]);
    
    prj1.uoffset = [1,-1,0];
    prj2.uoffset = [1,-1,0];
    prj3.uoffset = [1,-1,0];
    w_source(7)= cut_sqw(data_file,prj2,[-0.55,0.025,0.55],[-0.1,0.1],[-0.1,0.1],[80,90]);
    w_source(8)= cut_sqw(data_file,prj3,[-0.8,0.025,0.8],[-0.1,0.1],[-0.1,0.1],[80,90]);
    w_source(9)  = cut_sqw(data_file,prj1,[-0.1,0.1],[-0.1,0.1],[-0.8,0.025,0.8],[80,90]);
    
    prj1.uoffset = [1,1,0];
    prj2.uoffset = [1,1,0];
    prj3.uoffset = [1,1,0];
    w_source(8)= cut_sqw(data_file,prj2,[-0.8,0.025,0.5],[-0.1,0.1],[-0.1,0.1],[80,90]);
    w_source(9)= cut_sqw(data_file,prj3,[-0.55,0.025,0.55],[-0.1,0.1],[-0.1,0.1],[80,90]);
    w_source(10) = cut_sqw(data_file,prj1,[-0.1,0.1],[-0.1,0.1],[-0.8,0.025,0.8],[80,90]);
    
    
    prj1.uoffset = [2,0,0];
    w_source(11)= cut_sqw(data_file,prj1,[-0.8,0.025,0.8],[-0.1,0.1],[-0.1,0.1],[80,90]);
    w_source(12) = cut_sqw(data_file,prj1,[-0.1,0.1],[-0.1,0.1],[-0.8,0.025,0.8],[80,90]);
    
    
    prj1.uoffset = [0,-1,1];
    w_source(13)= cut_sqw(data_file,prj1,[-0.8,0.025,0.8],[-0.1,0.1],[-0.1,0.1],[80,90]);
    w_source(14) = cut_sqw(data_file,prj1,[-0.1,0.1],[-0.1,0.1],[-0.8,0.025,0.8],[80,90]);
    
    
    prj1.uoffset = [0,1,1];
    w_source(15)= cut_sqw(data_file,prj1,[-0.1,0.1],[-0.8,0.025,0.8],[-0.1,0.1],[80,90]);
    
    prj1.uoffset = [1,-1,0];
    w_source(16)= cut_sqw(data_file,prj1,[-0.1,0.1],[-0.8,0.025,0.8],[-0.1,0.1],[80,90]);
    prj1.uoffset = [1, 1,0];
    w_source(17)= cut_sqw(data_file,prj1,[-0.1,0.1],[-0.8,0.025,0.8],[-0.1,0.1],[80,90]);
    

    prj1.uoffset = [0,-1,1];
    w_source(18)= cut_sqw(data_file,prj1,[-0.8,0.025,0.8],[-0.1,0.1],[-0.1,0.1],[80,90]);
    prj1.uoffset = [0, -1,1];
    w_source(19)= cut_sqw(data_file,prj1,[-0.1,0.1],[-0.1,0.1],[-0.8,0.025,0.8],[80,90]);
    
    
end
% %%nice set:
% w110=cut_sqw(data_file,proj,[0.2,0.01,1.8],[0.9,1.1],[-0.1,0.1],[80,90]);
% w1m10=cut_sqw(data_file,proj,[0.2,0.01,1.8],[-1.1,-0.9],[-0.05,0.05],[80,90]);
% w200=cut_sqw(data_file,proj,[1.2,0.01,2.8],[-0.1,0.1],[-0.1,0.1],[80,90]);
%
% w10m1=cut_sqw(data_file,proj,[0.9,1.1],[-0.8,0.01,0.8],[-1.1,-0.9],[80,90]);
% w0m1m1=cut_sqw(data_file,proj,[-0.2,0.01,0.8],[-1.1,-0.9],[-1.1,-0.9],[80,90]);
% w101=cut_sqw(data_file,proj,[-0.1,0.1],[-1.8,0.01,-0.2],[0.9,1.1],[80,90]);   %6
% 
%
% w0m11=cut_sqw(data_file,proj,[0.2,0.01,1.8],[-0.1,0.1],[0.9,1.1],[80,90]);
% % % Toby's set
% w110a=cut_sqw(data_file,struct('u',[1,-1,0],'v',[1,1,0]),[-0.5,0.01,0.5],[0.9,1.1],[-0.1,0.1],[80,90]);
% w110b=cut_sqw(data_file,struct('u',[1,1,0],'v',[1,-1,0]),[-0.5,0.01,0.5],[0.9,1.1],[-0.1,0.1],[80,90]); %9
% w110c=cut_sqw(data_file,struct('u',[0,0,1],'v',[1,1,0]),[-0.5,0.01,0.5],[0.9,1.1],[-0.1,0.1],[80,90]);
% % w200=cut_sqw(data_file,proj,[1.2,0.01,2.8],[-0.1,0.1],[-0.1,0.1],[80,90]);
% w1m10a=cut_sqw(data_file,struct('u',[1,-1,0],'v',[1,1,0]),[-0.8,0.01,0.5],[-1.1,-0.9],[-0.1,0.1],[80,90]);
% w1m10b=cut_sqw(data_file,struct('u',[1,1,0],'v',[1,-1,0]),[-0.5,0.01,0.5],[0.9,1.1],[-0.1,0.1],[80,90]);


%w=[w110,w1m10,w200,w10m1,w0m1m1,w101,w0m11,w110a,w110b,w110c,w1m10a,w1m10b];

sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
bpin = cell(1,numel(w_source));
for i = 1:numel(w_source)
    w_source(i) = set_sample_and_inst(w_source(i),sample,@maps_instrument_for_tests,'-efix',600,'S');
    %w(i).data.alatt = [2.844,2.844,2.844];
    bpin{i} = w_source(i).data.s(1);
end
mag = MagneticIons('Fe0');

mc = 10;
amp = 1.2148;
qfwhh = 0.2447;
efwhh = 199.1740;
alatt = [2.8531,2.8531,2.8531];
%alatt = [2.9,2.9,2.9];
angdeg = [90,90,90];
ff_fix = mag.getFF_calculator(w_source(1));
% Fit a global function
% ---------------------
kk = tobyfit2(w_source);
kk = kk.set_refine_crystal ('fix_angdeg','fix_alatt_ratio');
kk = kk.set_mc_points (mc);
kk = kk.set_fun (@(h,k,l,en,varargin)...
    (bragg_sphere_and_mag_ff(ff_fix,h,k,l,en,varargin{:})),...
    {[amp,qfwhh,efwhh],[alatt,angdeg]},[1,1,1]);
kk = kk.set_options('list',1,'fit_control_parameters',[1.e-2;60;1.e-6]);
kk = kk.set_bfun(@(x,par)(par(1)),bpin);

if simulate
    [w_tf_a,fitpar_tf_a] = kk.simulate;
else
    [w_tf_a,fitpar_tf_a,ok,mess,rlu_corr_tf_a] = kk.fit;
    disp(rlu_corr_tf_a);
    disp(fitpar_tf_a.p);
    if ~ok
        disp(mess)
    end
end
%change_crystal_sqw(data_file,rlu_corr_tf_a);
w_tf_a = reshape(w_tf_a,1,numel(w_tf_a));
w_source = reshape(w_source,1,numel(w_source));

res = EnCutBlock(w_source,w_tf_a,fitpar_tf_a);
res = plot_EnCuts(res,'-keep');
res.save('FixEi400_enCuts19');



