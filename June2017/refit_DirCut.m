function [result,all_plots]=refit_DirCut(saved_cuts_file)


load(saved_cuts_file);

caption =@(vector)['[' num2str(vector(1)) ',' num2str(vector(2)) ',' num2str(vector(3)) ']'];
cut_id = [caption(bragg),' Direction: ',caption(cut_direction)];


if iscell(fp_arr1.p)
    fitpar = reshape([fp_arr1.p{:}],10,numel(fp_arr1.p))';
    fiterr = reshape([fp_arr1.sig{:}],10,numel(fp_arr1.sig))';
else
    fitpar = fp_arr1.p;
    fiterr = fp_arr1.sig;
end
e_sel_cut = zeros(numel(w1D_arr1_tf),1);
%for i=1:numel(e_sw)
%    e_sw(i) = w1D_arr1_tf(i).header{1}.efix;
%end

% S(Q,w) model
ff = 1; % 1
T = 8;  % 2
%gamma = 10; % 3
gamma = sum(fitpar(:,3))/size(fitpar,1);
gap = 0;    % 5
%Seff = 2;   % 4
Seff = sum(fitpar(:,4))/size(fitpar,1);
%J1 = 40;    % 6
J1 = fitpar(1,6);
par = [ff, T, gamma, Seff, gap, J1, 0 0 0 0];


%
kk = tobyfit2(cut_list);
%ff_calc = mff.getFF_calculator(cut_list(1));
kk = kk.set_local_foreground(true);
kk = kk.set_fun(@sqw_iron,par,[0,0,1,1,0,1,0,0,0,0]);
%kk = kk.set_fun(@(h,k,l,e,par)sw_disp(proj,ff_calc,h,k,l,e,par),[parR(1),parR(2),parR(3),ampl_avrg,fwhh_avrg],[1,1,1,1,1]);
%kk = kk.set_bind({1,[1,2],1},{2,[2,2],1},{3,[3,2],1});
kk = kk.set_bind({{6,[6,2],1},{7,[7,2],1},{8,[8,2],1},{9,[9,2],1},{10,[10,2],1}});

% set up its own initial background value for each background function
bpin = fp_arr1.bp;
kk = kk.set_bfun(@lin_bg,bpin);

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-2;60;1.e-6]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
%profile on;
%[w1D_arr1_tf,fp_arr1]=kk.fit;
%profile off
%profile viewer
for i=1:numel(w1D_arr1_tf)
    acolor('k');
    plot(cut_list(i));
    acolor('r');
    pd(w1D_arr1_tf(i));
    pause(1)
end

if iscell(fp_arr1.p)
    fitpar = reshape([fp_arr1.p{:}],10,numel(fp_arr1.p))';
    fiterr = reshape([fp_arr1.sig{:}],10,numel(fp_arr1.sig))';
else
    fitpar = fp_arr1.p;
    fiterr = fp_arr1.sig;
end


%fback = kk.simulate(w110arr1_tf,'back');
%pl(fback)
Amp    = fitpar(:,4);
Amp_err= fiterr(:,4);
fhhw   = fitpar(:,3);
fhhw_err=fiterr(:,3);

pl1=figure('Name',['Tobyfitted SW intensity along dE; peak: ',cut_id]);
errorbar(e_sel_cut,Amp,Amp_err,'r');
%
ly 0 2
%legend(li2,'Tobifitted intensity','Tobyfit2 intensity')

%xxpf=max(min(qswm),-0.8):0.01:min(max(qswm),0.8);
%par_sw = [0,0,4*pi*pi*fp_arr1.p{1}(6)];
%yypf=parab(xxpf,par_sw);



pl2=figure('Name',['Tobyfitted FHHW along spin wave for peak: ', cut_id ]);
errorbar(e_sel_cut,fhhw,fhhw_err,'b');
ly 0 1
%---------------------------------------------------------------
par_sw = [0,0,4*pi*pi*fp_arr1.p{1}(6)];
disp(['Cut: ',cut_id,' fitting param: ',num2str(par_sw)]);
result.sw_par = par_sw;
result.ampl_vs_e = [e_sel_cut,Amp,Amp_err];
result.fhhw_vs_e = [e_sel_cut,fhhw,fhhw_err];
result.fhhw_along_sw = [q_sw_calc,e_sel_cut,fhhw_pl];
result.fitted_sw = [xxpf,yypf];
%result.eval_sw  = [q_sw_calc,e_sel_cut,fhhw_pl];

all_plots = [pl1,pl2];
%




function bg = lin_bg(x,par)
%
bg  = par(1)+x*par(2);

