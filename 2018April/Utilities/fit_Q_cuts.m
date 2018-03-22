function [cuts,fitpar,enq_gs]= fit_Q_cuts(sqw_file,fitpar)
% Load sequence of cuts, corresponding to different Brillouin zones and
% different reciprocal lattice directions and fit these peaks with the
% scattering function defined by the spin-wave Hamiltonian specified.
%
%
data_source = 'd:\Users\abuts\Data\Fe\June2017\sqw\Data';
sqf = fullfile(data_source,sqw_file);
[cuts,enq,fg_par,bg_par,proj] = get_Q_cuts(sqf ,fitpar);

%cuts = reshape(cuts,numel(cuts),1);

n_en = size(enq,1);

disp('*************************************************************')
disp('*** Fitting loop started ')
disp('*************************************************************')
%
loc_binds = cell(n_en*2,1);
init_fg_par = cell(n_en*2,1);
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
%w2 = set_sample_and_inst(w2,sample,@maps_instrument_for_tests,'-efix',600,'S');

for i=1:n_en
    loc_binds{2*i-1} = {[3,i],[3,i+n_en],1};
    loc_binds{2*i}   = {[4,i],[4,i+n_en],1};
    init_fg_par{i} = fg_par(i,:);
    init_fg_par{n_en+i} = fg_par(i,:);
    cuts(1,i)  = set_sample_and_inst(cuts(1,i),sample,@maps_instrument_for_tests,'-efix',600,'S');
    cuts(2,i)  = set_sample_and_inst(cuts(2,i),sample,@maps_instrument_for_tests,'-efix',600,'S');
end
% % S(Q,w) model
%   ff = 1; % 1
%   T = 8;  % 2
%   %gamma = 10; % 3
%   gamma = fitpar_av(3);
%   gap = 0;    % 5
%   %Seff = 2;   % 4
%   Seff = fitpar_av(4);
%   %J1 = 40;    % 6
%   J0 = fitpar_av(6);
%   par = [ff, T, gamma, Seff, gap, J0, J1, J2, 0, 0];
%
%   par =  [ff, T, gamma, Seff, gap, J0, J1, J2, 0, 0];
fixed_par = [0, 0, 1,     1,    0,   0,  0,  0,  0, 0];
fitpar = cell(n_en,1);
for i=1:n_en
    % %parfor i=1:n_en
    kk = tobyfit2(cuts(:,i));
    if n_en > 1
        %kk = kk.set_local_foreground(true);
        kk = kk.set_fun(@sqw_iron,init_fg_par{i},fixed_par);
        %kk = kk.set_fun(@(h,k,l,e,par)sw_disp(proj,ff_calc,h,k,l,e,par),[parR(1),parR(2),parR(3),ampl_avrg,fwhh_avrg],[1,1,1,1,1]);
        %global_binds = {{6,[6,2],1},{7,[7,2],1},{8,[8,2],1},{9,[9,2],1},{10,[10,2],1}};
        %     global_binds = {{6,[6,2],1},{7,[7,2],1}};
        %     all_binds = {global_binds{:},loc_binds{:}};
        %kk = kk.set_bind(loc_binds{:});
    else
        kk = kk.set_fun(@sqw_iron,fg_par,fixed_par);
    end
    
    % set up its own initial background value for each background function
    %kk = kk.set_bfun(@(x,par)(par(1)+x*par(2)),init_bg_params);
    
    kk = kk.set_mc_points(10);
    %profile on;
    kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-2;20;1.e-4]);
    %kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
    %profile on;
    [w1D_arr1_tf,fp_arr1]=kk.fit;
    %[w1D_arr1_tf,fp_arr1]=kk.simulate;
    fp_arr1.en   = enq(i,1);
    fp_arr1.q    = enq(i,2);
    fp_arr1.proj = proj;
    fp_arr1.fits = w1D_arr1_tf;
    fitpar{i}    = fp_arr1;
    disp(fp_arr1.p);
    disp(fp_arr1.sig);    
end
%profile off
%profile viewer
% fit_rez{i} = {w1D_arr1_tf,fp_arr1,eq_indexes};
% %
%
enq_gs = zeros(4,n_en);
for i=1:n_en
    enq_gs(1,i) = enq(i,1);
    enq_gs(2,i) = enq(i,2);
    enq_gs(3,i) = fitpar{i}.p(3);    % Gamma
    enq_gs(4,i) = fitpar{i}.p(4);    % S_eff
end
plot(enq_gs(1,:),enq_gs(3,:))

% obj = obj.save_en_cuts([],'J_CenFit_');

function [cuts,enq,fg_par,bg_par,proj]=get_Q_cuts(sqw_file,fitpar)

n_cuts = size(fitpar,1);
cuts = repmat(sqw,2,n_cuts);
bg_par = zeros(n_cuts,3);
fg_par  = zeros(n_cuts,10);
enq   = zeros(n_cuts,2);
[h0,k0,l0,dir_id] = cut_id.id_to_bragg(fitpar(1,2));
for i=1:n_cuts
    en = fitpar(i,1);
    [q,fval,exit] = fzero(@(q)disp_bcc(q,en,fitpar(i,6:12)),0.5);
    
    enq(i,1) = en;
    enq(i,2) = abs(q);
    bg_par(i,1) = en;
    bg_par(i,2) = fitpar(i,13);
    bg_par(i,3) = fitpar(i,14);
    
    fg_par(i,:) = fitpar(i,3:12);
end

%dir
dir = [0,0,0];
dir(dir_id) = 1;
[proj.u,proj.v,proj.w] = make_ortho_set(dir);
proj.uoffset = [h0,k0,l0,0];
E_max = max(enq(:,1));

for i=1:n_cuts
    q = enq(i,2);
    E_min = min(enq(i,1),50);
    cuts(1,i) = cut_sqw(sqw_file,proj,[q-0.05,q+0.05],[-0.05,0.05],[-0.05,0.05],[E_min,5,E_max]);
    bgc = sqw_eval(cuts(1,i),@(qh,qk,ql,en,par)bgf(qh,qk,ql,en,bg_par),[]);
    cuts(1,i) = cuts(1,i) - bgc;
    cuts(2,i) = cut_sqw(sqw_file,proj,[-q-0.05,-q+0.05],[-0.05,0.05],[-0.05,0.05],[E_min,5,E_max]);
    bgc = sqw_eval(cuts(2,i),@(qh,qk,ql,en,par)bgf(qh,qk,ql,en,bg_par),[]);
    cuts(2,i) = cuts(2,i) - bgc;
    %plot(cuts(1,i));
    %pl(cuts(2,i));
end


function bg = bgf(qh,qk,ql,en,par,varargin)

p1 = interp1q(par(:,1),par(:,2),en);
p2 = interp1q(par(:,1),par(:,3),en);
f = @(x)(p1+p2.*x);

q = sqrt(qh.*qh+qk.*qk+ql.*ql);

bg = f(q);


function w = disp_bcc(q,e,fitpar)

q0 = zeros(size(q));
wdisp = disp_bcc_hfm (q,q0,q0,fitpar);
w = wdisp{1}-e;

