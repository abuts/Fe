function [J_ds,S_q,G_q,A_dft]=MapDFT_ExperDSHOModel(fitpar_guess_source)

root_f = fileparts(mfilename('fullpath'));

if ~exist('fitpar_guess_source','var')
    fitpar_guess_source = 'Res_conv_DFT_fit_Ei800.mat';
end
fitpar_guess  = load(fullfile(root_f,fitpar_guess_source));
exp_files = fullfile(root_f,'Jvar_All8Braggs_SelectedCuts');
dir = 100;

Ne = size(fitpar_guess.S,2);

e     =  fitpar_guess.S(1,:);


Sexp_vsE    = zeros(3,Ne)*NaN;
Jexp_vsE    = zeros(3,Ne)*NaN;
Gexp_vsE   = zeros(3,Ne)*NaN;
A_dft_vsE  = zeros(3,Ne)*NaN;

%bg     = zeros(Ne,2)*NaN;


const = 0;
grad = 0;
%par0= [0,J0,Gamma,S,const,grad];

fs = fig_spread('-tigth');

for i=1:Ne
    En = e(i);
    Sexp_vsE(1,i) = En;
    Jexp_vsE(1,i) = En;
    Gexp_vsE(1,i) = En;
    A_dft_vsE(1,i) = En;
    
    fn = sprintf('EnCuts_Fe_ei401_dE%d_dir_!%d!.mat',En,dir);
    exp_file = fullfile(exp_files,fn);
    if ~(exist(exp_file ,'file') == 2)
        disp(['Missing file: ',fn]);
        continue;
    end
    exp_file = load(exp_file);
    %
    tfs = tobyfit2(exp_file.cut_list);
    tfs = tfs.set_fun(@disp_dft_parameterized,[1,1],[1,0]);
    tfs = tfs.set_bfun(@lin_bg,[const,grad]);
    
    tfs  = tfs.set_mc_points(10);
    tfs  = tfs.set_options('listing',1,'fit_control_parameters',[1.e-2;60;1.e-6]);
    %calculate resolution convoluted dft model
    [dft_rc,fpd] = tfs.fit;
    
    try
        par= [fitpar_guess.J0(2,i),fitpar_guess.Gamma(2,i),fitpar_guess.S(2,i)];
        tft = tobyfit2(exp_file.cut_list);
        tft = tft.set_fun(@DSHO_hub,par,[0,1,1]);
        tft = tft.set_bfun(@lin_bg,[const,grad]);
        
        tft = tft.set_mc_points(10);
        
        tft = tft.set_options('listing',1,'fit_control_parameters',[1.e-2;60;1.e-6]);
        
        [w1_tf,fp]=tft.fit;
        
    catch Err
        disp(['Error: ',Err.message]);
        continue
    end
    fs = fs.close_all();
    for j=1:numel(exp_file.cut_list)
        acolor('k')
        plot(exp_file.cut_list(j));
        acolor('r')
        pl(w1_tf(j));
        acolor('b')
        fh = pl(dft_rc(j));
        fs = fs.place_fig(fh);
    end
    if  ~fp.converged
        continue
    end
    Sexp_vsE(2,i) = fp.p(3);
    Jexp_vsE(2,i) = fp.p(1);
    Gexp_vsE(2,i) = abs(fp.p(2));
    A_dft_vsE(2,i) = fpd.p(1);
    
    Sexp_vsE(3,i) = fp.sig(3);
    Jexp_vsE(3,i) = fp.sig(1);
    Gexp_vsE(3,i) = fp.sig(2);
    A_dft_vsE(3,i)= fpd.sig(1);
    
    
    %bg(i,:) = fp.bp(:);
    
end
S_q = IX_dataset_1d(Sexp_vsE);
S_th = IX_dataset_1d(fitpar_guess.S);
S_q.title = 'DSHO fit exper: S + linear background';
S_q.x_axis = 'En (mEv)';
S_q.s_axis = 'Ampliture (AU)';
acolor('r')
pd(S_q);
acolor('g')
pd(S_th);

% bg_d = IX_dataset_1d(e,bg(:,1));
% bg_d.title = 'backgound';
% acolor('k');
% pl(bg_d);
keep_figure;

A_dft = IX_dataset_1d(A_dft_vsE);
S_q.title = 'DFT amplitude to fit experiment';
S_q.x_axis = 'En (mEv)';
S_q.s_axis = 'Ampliture (AU)';
acolor('r')
pd(S_q);
keep_figure;

G_q = IX_dataset_1d(Gexp_vsE);
G0_q = IX_dataset_1d(fitpar_guess.Gamma);
G_q.title = 'DSHO fit: Gamma';
G_q.x_axis = 'En (mEv)';
G_q.s_axis = 'mEv';
acolor('r')
plot(G_q);
acolor('g')
pd(G0_q);
keep_figure

acolor('r')
J_ds = IX_dataset_1d(Jexp_vsE);
J_ds0 = IX_dataset_1d(fitpar_guess.J0);
J_ds.x_axis = 'En (mEv)';
J_ds.s_axis = 'J0 (mEv)';
pd(J_ds);
acolor('g');
pd(J_ds0);
keep_figure;


function y = DSHO_hub(hh,hk,hl,en, p, varargin)

% use: ff,T,Gamma,S,gap,J0
par = [1,8,p(2),p(3),0,abs(p(1)),0,0,0,0];

y = sqw_iron(hh,hk,hl,en,par);


function bg = lin_bg(x,par)
%
bg  = par(1)+x*par(2);

