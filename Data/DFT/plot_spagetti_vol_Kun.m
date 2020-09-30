function [calc_arr,q_bg] = plot_spagetti_vol_Kun(varargin)
% Script is used to build spagetty plot of Kun's DFT calculations
% 
% It can also be used to plot and verify various interpolation formulas, 
% used for volume interpolations
% 8 ACSII data files with high symmetry Kun calculations must be located 
% in the same folder as this file. 
%
% Usage:
% [calc_arr,q_bg] = check_spagetti_vol_Kun() -- plot high symmetry q-dE
% spagetty plot using high symmetry data, produced by Kun.
% [calc_arr,q_bg] = check_spagetti_vol_Kun(1) -- plot high symmetry q-dE
%  data using chebyshev approximation.
% 
% Outpus:
% calc_arr -- 8x1 array of IX_dataset_2d, containing data for all symmetry
%             pannels of BCC lattices.
% q_bg     -- The initial q points for every high symmetry pannel.
%             

labels   = {'H','P',' \Gamma','H','N',' \Gamma','P','N'};
datasets = {'HP.dat','PG.dat','GH.dat','HN.dat','NG.dat','GP.dat','PN.dat'};

calc_arr = repmat(IX_dataset_2d(),numel(datasets),1);
q_bg = zeros(3,numel(datasets));
for i=1:numel(calc_arr)
    [calc_arr(i),q_bg(:,i),q1,q2,q3,dE] = read_kun(datasets{i},true);
    calc_arr(i).title = [labels{i},labels{i+1}];
    if nargin>0
        szd = size(q1);
        q1=reshape(q1,numel(q1),1)+ q_bg(1,i);
        q2=reshape(q2,numel(q2),1)+ q_bg(2,i);
        q3=reshape(q3,numel(q3),1)+ q_bg(3,i);
        dE= reshape(dE,numel(dE),1);
        w_disp = disp_dft_kun4D(q1,q2,q3,dE,[1,0]);
        calc_arr(i).signal = reshape(w_disp,szd);
    end
end

spaghetti_plot(calc_arr,'labels',labels);
lz 0 10
%spaghetti_plot(calc_arr);

gap = 0;    % 5
%Seff = 2;   % 4
Seff = 0.5816;
%J1 = 40;    % 6
J0 = 49.8037;
J1 = 5.8036;
J2 = -7.0439;
J3 = -2.0729;
J4 = 1.4187;
par_exp = [Seff, gap, J0, J1, J2, J3, J4];

gap = 0;    %
%Seff = 2;   %
Seff = 1.4573;      %1.4489;
%J1 = 40;    % 6
J0 = 51.6456;       %51.6079;
J1 = 1.4097;         %1.4083;
J2 = -8.4474;       %-8.4407;
J3 = -0.7469;       %-0.7448;
J4 = 0.6056;        %0.6047;
par_Kun = [Seff, gap, J0, J1, J2, J3, J4];
dir = {[1,0,0],[1/2,1/2,1/2],[0,0,0],[1,0,0],[1/2,1/2,0],[0,0,0],[1/2,1/2,1/2],[1/2,1/2,0]};
[q_dir,dist,scales] = build_q_arr(dir,50);

disp_line = disp_bcc_hfm(q_dir{:},par_Kun);
%acolor('r');
hold on
plot(dist,disp_line{1},'r','LineWidth',2);

disp_line_exp = disp_bcc_hfm(q_dir{:},par_exp);
plot(dist,disp_line_exp{1},'r:','LineWidth',4);
hold off
% figure
% qr = sqrt(q_dir{1}.*q_dir{1}+q_dir{2}.*q_dir{2}+q_dir{3}.*q_dir{3});
% plot(qr,disp_line{1});
% figure
% plot(dist,qr)
% hold on
% qr = sqrt((q_dir{1}-0.5).*(q_dir{1}-0.5)+(q_dir{2}-0.5).*(q_dir{2}-0.5)+(q_dir{3}-0.5).*(q_dir{3}-0.5));
% plot(dist,qr)
% qr = sqrt((q_dir{1}-1).*(q_dir{1}-1)+(q_dir{2}).*(q_dir{2})+(q_dir{3}).*(q_dir{3}));
% plot(dist,qr)
% hold off
%
