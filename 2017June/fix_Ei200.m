function res = fix_Ei200(varargin)


simulate = false;
data_file = fullfile(pwd,'sqw','Data','Fe_ei200.sqw');



dE = [70,80];

prj1.u=[1,0,0];
prj1.v=[0,1,0];
prj2.u=[1/sqrt(2),1/sqrt(2),0];
prj2.v=[1/sqrt(2),-1/sqrt(2),0];
prj3.u=[1,-1,0];
prj3.v=[1,1,0];

w000 =cut_sqw(data_file,prj1,[-2,0.01,2.5],[-2,0.01,2],[-0.08,0.08],dE);
plot(w000)
keep_figure

w00m1 =cut_sqw(data_file,prj1,[-2,0.01,2.5],[-2,0.01,2],[-1.05,-0.95],dE);
plot(w00m1 )
keep_figure
w001 =cut_sqw(data_file,prj1,[-2,0.01,2.5],[-2,0.01,2],[0.95,1.05],dE);
plot(w001 )
keep_figure


%%nice set:
w_source = repmat(sqw,1,13);
prj1.uoffset = [1,1,0];
w_source(1) = cut_sqw(data_file,prj1,[-0.8,0.015,.8],[-0.05,0.05],[-0.05,0.05],dE);
w_source(2) = cut_sqw(data_file,prj1,[-0.05,0.05],[-0.8,0.025,.8],[-0.05,0.05],dE);
w_source(3) = cut_sqw(data_file,prj1,[-0.05,0.05],[-0.05,0.05],[-0.8,0.025,.8],dE);

prj1.uoffset = [2,0,0];
w_source(4) = cut_sqw(data_file,prj1,[-0.8,0.015,.8],[-0.05,0.05],[-0.08,0.08],dE);
w_source(5) = cut_sqw(data_file,prj1,[-0.05,0.05],[-0.8,0.025,.8],[-0.05,0.05],dE);
w_source(6) = cut_sqw(data_file,prj1,[-0.05,0.05],[-0.05,0.05],[-1.5,0.025,1.5],dE);


prj1.uoffset = [1,0,-1];
w_source(7) = cut_sqw(data_file,prj1,[-0.05,0.05],[-0.8,0.015,.8],[-0.05,0.05],dE);
prj1.uoffset = [0,-1,-1];
w_source(8) = cut_sqw(data_file,prj1,[-0.8,0.025,.8],[-0.05,0.05],[-0.05,0.05],dE);
w_source(9) = cut_sqw(data_file,prj1,[-0.05,0.05],[-0.05,0.05],[-1.2,0.025,.8],dE);


prj1.uoffset = [1,0,1];
w_source(10) = cut_sqw(data_file,prj1,[-0.05,0.05],[-0.8,0.015,.8],[-0.05,0.05],dE);
prj1.uoffset = [0,-1,1];
w_source(11) = cut_sqw(data_file,prj1,[-0.8,0.025,.8],[-0.05,0.05],[-0.05,0.05],dE);

prj3.uoffset = [1,1,0];
w_source(12) = cut_sqw(data_file,prj3,[-0.8,0.015,.8],[-0.05,0.05],[-0.05,0.05],dE);
prj2.uoffset = [1,-1,0];
w_source(13) = cut_sqw(data_file,prj2,[-0.8,0.025,.8],[-0.05,0.05],[-0.05,0.05],dE);


% w110=cut_sqw(data_file,proj,[0.2,0.01,1.8],[0.9,1.1],[-0.08,0.08],[50,60]); %1
% w1m10=cut_sqw(w000,proj,[0.2,0.01,1.8],[-1.1,-0.9],[-0.08,0.08],[50,60]); %2
% w200=cut_sqw(w000,proj,[1.2,0.01,2.8],[-0.1,0.1],[-0.08,0.08],[50,60]); %3
%
%
%
% w10m1=cut_sqw(w00m1,proj,[0.9,1.1],[-0.8,0.01,0.8],[-1.05,-0.95],[50,60]); %4
% w0m1m1=cut_sqw(w00m1,proj,[-0.8,0.01,0.8],[-1.1,-0.9],[-1.05,-0.95],[50,60]); %5
% w0m11=cut_sqw(w001,proj,[-0.8,0.01,0.8],[-1.1,-0.9],[0.95,1.05],[50,60]); %6
% w0m11a=cut_sqw(w001,proj,[-0.1,0.1],[-1.8,0.01,-0.2],[0.95,1.05],[50,60]); %7
% w101a  =cut_sqw(w001,proj,[0.2,0.01,1.8],[-0.1,0.1],[0.95,1.05],[50,60]); %8
% bpin{8} = w101a.data.s(numel(w101a.data.s));
% w101b  =cut_sqw(w001,proj,[0.9,1.1],[-0.8,0.01,0.8],[0.95,1.05],[50,60]); %9
% w101c  =cut_sqw(data_file,proj,[0.9,1.1],[-0.1,0.1],[0.2,0.01,1.8],[50,60]); %10
%
% % % Toby's set
% w110a=cut_sqw(w000,struct('u',[1,-1,0],'v',[1,1,0]),[-0.5,0.01,0.5],[0.9,1.1],[-0.08,0.08],[50,60]);
% w110b=cut_sqw(w000,struct('u',[1,1,0],'v',[1,-1,0]),[-0.5,0.01,0.5],[0.9,1.1],[-0.08,0.08],[50,60]);
% w110c=cut_sqw(data_file,struct('u',[0,0,1],'v',[1,1,0]),[-0.5,0.01,0.5],[0.9,1.1],[-0.08,0.08],[50,60]);
% % w200=cut_sqw(data_file,proj,[1.2,0.01,2.8],[-0.1,0.1],[-0.1,0.1],[80,90]);
% w1m10a=cut_sqw(w000,struct('u',[1,-1,0],'v',[1,1,0]),[-0.8,0.01,0.5],[-1.1,-0.9],[-0.08,0.08],[50,60]);
% bpin{14} = w1m10a.data.s(numel(w1m10a.data.s));
%
% w1m10b=cut_sqw(w000,struct('u',[1,1,0],'v',[1,-1,0]),[-0.5,0.01,0.5],[0.9,1.1],[-0.08,0.08],[50,60]);
%
%
%
% w=[w110,w1m10,w200,w10m1,w0m1m1,w0m11,w0m11a,w101a,w101b,w101c,w110a,w110b,w110c,w1m10a,w1m10b];
%w=[w110a,w110b,w110c,;w200,w1m10a,w1m10b];
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
bpin = cell(1,numel(w_source));
for i = 1:numel(w_source)
    w_source(i) = set_sample_and_inst(w_source(i),sample,@maps_instrument_for_tests,'-efix',600,'S');
    %w(i).data.alatt = [2.844,2.844,2.844];
    if isempty(bpin{i})
        bpin{i} = w_source(i).data.s(1);
    end
    %plot(w(i))
    %pause(0.1)
end
mag = MagneticIons('Fe0');
mc = 10;
amp = 2.4743;
qfwhh = 0.1595;
efwhh = 183.6351;
alatt = [2.83,2.83,2.83];
%alatt = [2.9,2.9,2.9];
angdeg = [90,90,90];
ff_fix = mag.getFF_calculator(w_source(1));
% Fit a global function
% ---------------------
kk = tobyfit2 (w_source);
kk = kk.set_refine_crystal ('fix_angdeg','fix_alatt_ratio');
kk = kk.set_mc_points (mc);
kk = kk.set_fun (@(h,k,l,en,varargin)...
    (bragg_sphere_and_mag_ff(ff_fix,h,k,l,en,varargin{:})),...
    {[amp,qfwhh,efwhh],[alatt,angdeg]},[1,1,1]);
kk = kk.set_options('list',2,'fit_control_parameters',[1.e-4;60;1.e-6]);
kk = kk.set_bfun(@(x,par)(par(1)),bpin);

if simulate
    ok = true;
    [w_tf_a,fitpar_tf_a] = kk.simulate;
else
    [w_tf_a,fitpar_tf_a,ok,mess,rlu_corr_tf_a] = kk.fit;
    disp(rlu_corr_tf_a);
    disp(fitpar_tf_a.p);
    disp(fitpar_tf_a.sig);
end
if ~ok
    disp(mess)
end
%change_crystal_sqw(data_file,rlu_corr_tf_a);
w_tf_a = reshape(w_tf_a,1,numel(w_tf_a));

res = EnCutBlock(w_source,w_tf_a,fitpar_tf_a);
res = plot_EnCuts(res,'-keep','-tight');
if ~simulate
    res.save(['FixEi200_enCuts',num2str(numel(w_tf_a))]);
end


