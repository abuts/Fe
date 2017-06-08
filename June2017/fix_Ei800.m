data_file = fullfile(pwd,'sqw','Data','Fe_ei787.sqw');

proj.u=[1,0,0];
proj.v=[0,1,0];

w000 =cut_sqw(data_file,proj,[-2,0.01,2.5],[-2,0.01,2],[-0.1,0.1],[80,120]);
plot(w000)
keep_figure
w00m1 =cut_sqw(data_file,proj,[-2,0.01,2.5],[-2,0.01,2],[-1.1,-0.9],[80,120]);
plot(w00m1 )
keep_figure
w001 =cut_sqw(data_file,proj,[-2,0.01,2.5],[-2,0.01,2],[0.9,1.1],[80,120]);
plot(w001 )
keep_figure
pause(1)
bpin = cell(1,numel(w));

%%nice set:
wm110a=cut_sqw(w000,proj,[-1.8,0.01,-.2],[0.9,1.1],[-0.1,0.1],[80,120]); %1
wm110b=cut_sqw(w000,proj,[-1.1,-0.9],[0.2,0.01,1.8],[-0.1,0.1],[80,120]); %2
bpin{2} = wm110b.data.s(numel(wm110b.data.s));

wm110c=cut_sqw(data_file,proj,[-1.1,-0.9],[0.9,1.1],[-0.8,0.01,0.8],[80,120]); %3

w200=cut_sqw(w000,proj,[1.2,0.01,2.8],[-0.1,0.1],[-0.1,0.1],[80,120]); %4



w10m1a=cut_sqw(w00m1,proj,[0.9,1.1],[-0.8,0.01,0.8],[-1.1,-0.9],[80,120]); %5 
bpin{5} = w10m1a.data.s(numel(w10m1a.data.s));
w10m1b=cut_sqw(w00m1,proj,[0.2,0.01,1.8],[-0.1,0.1],[-1.1,-0.9],[80,120]); %6
w10m1c=cut_sqw(data_file,proj,[0.9,1.1],[-0.1,0.1],[-1.8,0.01,-0.2],[80,120]); %7

w01m1a=cut_sqw(w00m1,proj,[-0.8,0.01,0.8],[0.9,1.1],[-1.1,-0.9],[80,120]); %8
bpin{8} = w01m1a.data.s(numel(w01m1a.data.s));

w01m1b=cut_sqw(w00m1,proj,[-0.1,0.1],[0.2,0.01,1.8],[-1.1,-0.9],[80,120]); %9

w011=cut_sqw(w001,proj,[-0.8,0.01,0.8],[.9,1.1],[0.9,1.1],[80,120]); %10
%w0m11a=cut_sqw(w001,proj,[-0.1,0.1],[-1.8,0.01,-0.2],[0.9,1.1],[80,100]); 
w101a  =cut_sqw(w001,proj,[0.2,0.01,1.8],[-0.1,0.1],[0.9,1.1],[80,120]); %11
w101b  =cut_sqw(w001,proj,[0.9,1.1],[-0.8,0.01,0.8],[0.9,1.1],[80,120]); %12
w101c  =cut_sqw(data_file,proj,[0.9,1.1],[-0.1,0.1],[0.2,0.01,1.8],[80,120]); %13

w110a=cut_sqw(w000,struct('u',[1,-1,0],'v',[1,1,0]),[-1.8,0.01,-0.2],[0.9,1.1],[-0.1,0.1],[80,120]);
%bpin{14} = 0.25;
w110b=cut_sqw(w000,struct('u',[1,-1,0],'v',[1,1,0]),[-1.1,-0.9],[0.2,0.01,1.8],[-0.1,0.1],[80,120]);
%bpin{15} = 0.2;

w1m10b=cut_sqw(w000,struct('u',[1,1,0],'v',[1,-1,0]),[0.2,0.01,1.8],[-1.1,-0.9],[-0.1,0.1],[80,120]);
%bpin{16} = 0.25;


w=[wm110a,wm110b,wm110c,w200,w10m1a,w10m1b,w10m1c,w01m1b,w01m1a,w011,w101a,w101b,w101c,w110a,w110b,w1m10b];
%w=[wm110a,wm110b,wm110c,w200,w10m1a,w10m1b,w10m1c,w01m1b,w01m1a,w011,w101a,w101b,w101c];

sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
for i = 1:numel(w)
    w(i) = set_sample_and_inst(w(i),sample,@maps_instrument_for_tests,'-efix',600,'S');
    %w(i).data.alatt = [2.844,2.844,2.844];
    if isempty(bpin{i})
        bpin{i} = sum(w(i).data.s)/numel(w(i).data.s);
    end
    %plot(w(i))
    %pause(1)
end
mag = MagneticIons('Fe0');
mc = 10;
amp = 0.8;
qfwhh = 0.3;
efwhh = 192.;
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
    {[amp,qfwhh,efwhh],[alatt,angdeg]},[1,1,1]);
kk = kk.set_options('list',2,'fit_control_parameters',[1.e-3;60;1.e-6]);
kk = kk.set_bfun(@(x,par)(par(1)),bpin);

%[w_tf_a,fitpar_tf_a] = kk.simulate;
[w_tf_a,fitpar_tf_a,ok,mess,rlu_corr_tf_a] = kk.fit;
disp(rlu_corr_tf_a);
disp(fitpar_tf_a.p);
disp(fitpar_tf_a.sig);
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

