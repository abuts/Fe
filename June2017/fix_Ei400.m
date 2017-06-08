data_file = fullfile(pwd,'sqw','Data','Fe_ei401.sqw');

proj.u=[1,0,0];
proj.v=[0,1,0];




%%nice set:
w110=cut_sqw(data_file,proj,[0.2,0.01,1.8],[0.9,1.1],[-0.1,0.1],[80,90]);
w1m10=cut_sqw(data_file,proj,[0.2,0.01,1.8],[-1.1,-0.9],[-0.05,0.05],[80,90]);
w200=cut_sqw(data_file,proj,[1.2,0.01,2.8],[-0.1,0.1],[-0.1,0.1],[80,90]);

w10m1=cut_sqw(data_file,proj,[0.9,1.1],[-0.8,0.01,0.8],[-1.1,-0.9],[80,90]);
w0m1m1=cut_sqw(data_file,proj,[-0.2,0.01,0.8],[-1.1,-0.9],[-1.1,-0.9],[80,90]);
w101=cut_sqw(data_file,proj,[-0.1,0.1],[-1.8,0.01,-0.2],[0.9,1.1],[80,90]);
w0m11=cut_sqw(data_file,proj,[0.2,0.01,1.8],[-0.1,0.1],[0.9,1.1],[80,90]);
% % Toby's set
w110a=cut_sqw(data_file,struct('u',[1,-1,0],'v',[1,1,0]),[-0.5,0.01,0.5],[0.9,1.1],[-0.1,0.1],[80,90]);
w110b=cut_sqw(data_file,struct('u',[1,1,0],'v',[1,-1,0]),[-0.5,0.01,0.5],[0.9,1.1],[-0.1,0.1],[80,90]);
w110c=cut_sqw(data_file,struct('u',[0,0,1],'v',[1,1,0]),[-0.5,0.01,0.5],[0.9,1.1],[-0.1,0.1],[80,90]);
% w200=cut_sqw(data_file,proj,[1.2,0.01,2.8],[-0.1,0.1],[-0.1,0.1],[80,90]);
w1m10a=cut_sqw(data_file,struct('u',[1,-1,0],'v',[1,1,0]),[-0.8,0.01,0.5],[-1.1,-0.9],[-0.1,0.1],[80,90]);
w1m10b=cut_sqw(data_file,struct('u',[1,1,0],'v',[1,-1,0]),[-0.5,0.01,0.5],[0.9,1.1],[-0.1,0.1],[80,90]);







w=[w110,w1m10,w200,w10m1,w0m1m1,w101,w0m11,w110a,w110b,w110c,w1m10a,w1m10b];
%w=[w110a,w110b,w110c,;w200,w1m10a,w1m10b];
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
bpin = cell(1,numel(w));
for i = 1:numel(w)
    w(i) = set_sample_and_inst(w(i),sample,@maps_instrument_for_tests,'-efix',600,'S');
    %w(i).data.alatt = [2.844,2.844,2.844];
    bpin{i} = w(i).data.s(1);
end
mag = MagneticIons('Fe0');
mc = 10;
amp = 1;
qfwhh = 0.2;
efwhh = 196.5037;
alatt = [2.84,2.84,2.84];
%alatt = [2.9,2.9,2.9];
angdeg = [90,90,90];
ff_fix = mag.getFF_calculator(w(1));
% Fit a global function
% ---------------------
kk = tobyfit2 (w);
kk = kk.set_refine_crystal ('fix_angdeg','fix_alatt_ratio');
kk = kk.set_mc_points (mc);
kk = kk.set_fun (@(h,k,l,en,varargin)...
    (make_bragg_blobs_and_mag_ff(ff_fix,h,k,l,en,varargin{:})),...
    {[amp,qfwhh,efwhh],[alatt,angdeg]},[1,1,0]);
kk = kk.set_options('list',1,'fit_control_parameters',[1.e-4;60;1.e-6]);
kk = kk.set_bfun(@(x,par)(par(1)),bpin);

%[w_tf_a,fitpar_tf_a] = kk.simulate;
[w_tf_a,fitpar_tf_a,ok,mess,rlu_corr_tf_a] = kk.fit;
disp(rlu_corr_tf_a);
disp(fitpar_tf_a.p);
if ~ok
    disp(mess)
end
%change_crystal_sqw(data_file,rlu_corr_tf_a);
w_tf_a = reshape(w_tf_a,1,numel(w_tf_a));
w = reshape(w,1,numel(w));
for i=1:numel(w)
    acolor('k')
    plot(w(i));
    acolor('r')
    pd(w_tf_a(i));
    pause(1);
end
%
%
% % Fit local foreground functions (independent widths)
% % ---------------------------------------------------
% kk = tobyfit2 (w);
% kk = kk.set_refine_crystal ('fix_angdeg','fix_alatt_ratio');
% kk = kk.set_mc_points (mc);
% kk = kk.set_local_foreground(true);
% kk = kk.set_fun (@make_bragg_blobs,{{[amp,qfwhh,efwhh],[alatt,angdeg]}},[1,1,0]);
% kk = kk.set_options('list',2);
% [w_tf_b,fitpar_tf_b,ok,mess,rlu_corr_tf_b] = kk.fit;
% %
% if ~ok
%     disp(mess)
% end
% if any(abs(rlu_corr_tf_b(:)-rlu_corr(:))>0.004)
%     error('  2 of 2: Bragg peak crystal refinement and Tobyfit crystal refinement are not the same')
% end
%
% if test_output
%     if any(abs(rlu_corr_tf_b(:)-tmp.rlu_corr_tf_b(:))>0.004)
%         error('  2 of 2: Tobyfit crystal refinement and stored results are not the same')
%     end
% end
%

