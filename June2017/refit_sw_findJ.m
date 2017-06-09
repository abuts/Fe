function [result,all_plots]=refit_sw_findJ()

bragg_list = {[1,1,0],[1,-1,0],[2,0,0]};
file_list = {'Fe_ei200'};
cuts_list = containers.Map();
cuts_list('[110]') = {[1,0,0],[0,1,0],[0,0,1],...
    [1,1,0],[1,-1,0],[1,0,1],[1,0,-1],[0,1,1],[0,1,-1],...
    [1,1,1],[1,1,-1],[1,-1,-1],[1,-1,1]};
cuts_list('[1-10]') = {[1,0,0],[0,1,0],[0,0,1]};
cuts_list('[200]') = {[1,0,0],[0,1,0],[0,0,1]};

br_name = @(bragg)(['[' num2str(bragg(1)) num2str(bragg(2))  num2str(bragg(3)) ']']);

cut_list = {};
bg_params = {};
fitpar = zeros(1,10);
filenames = {};

for i=1:numel(bragg_list)
    bragg = bragg_list{i};
    cut_name  = br_name(bragg);
    cuts = cuts_list(cut_name);
    for j=1:numel(file_list)
        file = file_list{j};
        for k=1:numel(cuts)
            direction = cuts{k};
            data_file = rez_name(file,bragg,direction);
            if exist([data_file,'.mat'],'file') == 2
                filenames = [filenames(:);{data_file}];
            else
                error('file %s does not exist',data_file);
            end
        end
        
    end
end
n_files = numel(filenames);
for i=1:n_files 
    data_file = filenames{i};
    fprintf('reloading cut file: %s %d#%d\n',data_file,i,n_files);
    ld = load(data_file);
    cut_list = [cut_list(:);ld.cut_list(:)];
    bg_params = {bg_params{:},ld.fp_arr1.bp{:}};
    
    n_cuts= numel(ld.fp_arr1.sig);
    cut_fiterr = reshape([ld.fp_arr1.sig{:}],10,n_cuts)';
    cut_fitpar = reshape([ld.fp_arr1.p{:}],10,n_cuts)';
    not_valid = cut_fiterr>10;
    cut_fitpar(not_valid) = 0;
    n_cuts = sum(~not_valid,1);
    cut_fitpar_av = sum(cut_fitpar,1)./n_cuts;
    fitpar  = fitpar+cut_fitpar_av;
end
fitpar  = fitpar/n_files;


caption =@(vector)['[' num2str(vector(1)) ',' num2str(vector(2)) ',' num2str(vector(3)) ']'];
%cut_id = [caption(bragg),' Direction: ',caption(cut_direction)];


%for i=1:numel(e_sw)
%    e_sw(i) = w1D_arr1_tf(i).header{1}.efix;
%end

% S(Q,w) model
ff = 1; % 1
T = 8;  % 2
%gamma = 10; % 3
gamma = fitpar(3);
gap = 0;    % 5
%Seff = 2;   % 4
Seff = fitpar(4);
%J1 = 40;    % 6
J1 = fitpar(6);
par = [ff, T, gamma, Seff, gap, J1, 0 0 0 0];


%
kk = tobyfit2(cut_list);
%ff_calc = mff.getFF_calculator(cut_list(1));
kk = kk.set_local_foreground(true);
kk = kk.set_fun(@sqw_iron,par,[0,0,1,1,0,1,0,0,0,0]);
%kk = kk.set_fun(@(h,k,l,e,par)sw_disp(proj,ff_calc,h,k,l,e,par),[parR(1),parR(2),parR(3),ampl_avrg,fwhh_avrg],[1,1,1,1,1]);
%kk = kk.set_bind({1,[1,2],1},{2,[2,2],1},{3,[3,2],1});
kk = kk.set_bind({6,[6,2],1});

% set up its own initial background value for each background function
kk = kk.set_bfun(@lin_bg,bg_params);

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-2;60;1.e-6]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
%profile on;
[w1D_arr1_tf,fp_arr1]=kk.fit;
%profile off
%profile viewer

if iscell(fp_arr1.p)
    fitpar = reshape([fp_arr1.p{:}],10,numel(fp_arr1.p))';
    fiterr = reshape([fp_arr1.sig{:}],10,numel(fp_arr1.sig))';
else
    fitpar = fp_arr1.p;
    fiterr = fp_arr1.sig;
end
J = fitpar(1,6);
J_err = fiterr(1,6);
fprintf(' Average J over number of cuts: %d, Error: %d\n',J,J_err);

% %fback = kk.simulate(w110arr1_tf,'back');
% %pl(fback)
% Amp    = fitpar(:,4);
% Amp_err= fiterr(:,4);
% fhhw   = fitpar(:,3);
% fhhw_err=fiterr(:,3);
disp('fitpar')
disp(fitpar(3:10,:));
disp('fiterr')
disp(fiterr(3:10,:));

for i=1:numel(w1D_arr1_tf)
    acolor('k');
    plot(cut_list(i));
    acolor('r');
    pd(w1D_arr1_tf(i));
    pause(1)
end



function bg = lin_bg(x,par)
%
bg  = par(1)+x*par(2);

