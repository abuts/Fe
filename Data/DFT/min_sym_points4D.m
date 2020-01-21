function  sym_points = min_sym_points4D(Np)
close all


if nargin<1
    Nip = 21;
else
    Nip = Np;
end
[px,py,pz,Xj] = min_sim_pointsQ(Nip,'visual');

e_max = 800;
q0 = 1;

%-----------------------------------------------
[pxp,pyp,pzp] = expand_sim_points(px,py,pz,Xj);
figure('Name','Recovered all')
scatter3(pxp,pyp,pzp);
np = numel(pzp);
disp([' NP_all_rec: ',num2str(np)]);


rG = dist2p(px,py,pz,0,0,0);
rH = dist2p(px,py,pz,1,0,0);
rP = dist2p(px,py,pz,0.5,0.5,0.5);
isnear_Gp = (rG<=rH) & (rG<rP);
isnear_Hp = (rH<rG) & (rH<=rP);
isnear_Pp = (rP<=rG) & (rP<rH);
cs =sum(isnear_Gp)+sum(isnear_Hp)+sum(isnear_Pp);
%qr = sort(qr);
% E = al*q^2+bt*(q)^4;
% 800 = al+bt
% 0  = 2*al+4*bt

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
qd = build_q_arr(dir,50);
rGm = dist2p(qd{1},qd{2},qd{3},0,0,0);
rHm = dist2p(qd{1},qd{2},qd{3},1,0,0);
rPm = dist2p(qd{1},qd{2},qd{3},0.5,0.5,0.5);

disp_line = disp_bcc_hfm(qd{:},par_Kun);
disp_line = disp_line{1};

is_Gp_disp = (rGm<rHm) & (rGm<rPm);
is_Hp_disp = (rHm<=rGm) & (rHm<=rPm);
is_Pp_disp = (rPm<=rGm) & (rPm<=rHm);

dist_nGp = rGm(is_Gp_disp);
disp_nGp = disp_line(is_Gp_disp);
dist_nHp = rHm(is_Hp_disp);
disp_nHp = disp_line(is_Hp_disp);
dist_nPp = rPm(is_Pp_disp );
disp_nPp = disp_line(is_Pp_disp );

figure
hold on
acolor('r');
scatter(dist_nGp,disp_nGp)
qqq = 0:0.01:0.55;
E_near_Gp = @(dist)(960*dist.^2);
plot(qqq,E_near_Gp(qqq));
acolor('g');
scatter(dist_nHp ,disp_nHp )
E_near_Hp = @(dist)(800-2000*dist.^2);
plot(qqq,E_near_Hp(qqq));
acolor('b');
E_near_Pp = @(dist)(420-1200*(1-2*dist.^2).*dist.^2);
scatter(dist_nPp ,disp_nPp )
plot(qqq,E_near_Pp(qqq));

hold off

[Gpp,Gd,EG_range] = E_rangeGp([px(isnear_Gp),py(isnear_Gp),pz(isnear_Gp)],E_near_Gp);
[Hpp,Hd,EH_range] = E_rangeHp([px(isnear_Hp),py(isnear_Hp),pz(isnear_Hp)],E_near_Hp);
[Ppp,Pd,EP_range] = E_rangePp([px(isnear_Pp),py(isnear_Pp),pz(isnear_Pp)],E_near_Pp);
figure
hold on
scatter(Gd,EG_range(:,1),'r');
scatter(Gd,EG_range(:,2),'r');
scatter(Hd,EH_range(:,1),'g');
scatter(Hd,EH_range(:,2),'g');
scatter(Pd,EP_range(:,1),'b');
scatter(Pd,EP_range(:,2),'b');
hold off

sym_points = [Gpp;Hpp;Ppp];

file = 'sim_range.dat';
fh = fopen(file,'w');
clob = onCleanup(@()fclose(fh));

for i=1:size(sym_points,1)
    space_pt = sym_points(i,:);
    E_range = space_pt(4):8:space_pt(5);
    for j=1:numel(E_range)
        fprintf(fh,'%6.4f %6.4f %6.4f %6.1f\n',...
            space_pt(1),space_pt(2),space_pt(3),E_range(j));
    end
    fprintf(fh,'\n');
end


function [rng,dist,Range] = E_rangePp(qp,f_dist)

dist = dist2p(qp(:,1),qp(:,2),qp(:,3),0.5,0.5,0.5);
E_avrg = f_dist(dist);

E_range = PpDist(dist);
E_min = E_avrg-E_range;
E_max = E_avrg+E_range;
low = E_min<8;
E_min(low) = 8;
high = E_max>800;
E_min(high) = 800;


E_min = floor(E_min/8)*8;
E_max = floor(E_max/8)*8;
rng = [qp,E_min,E_max];

%[dist,ind] = unique(dist);
%Range = [rng(ind,4),rng(ind,5)];
Range = [rng(:,4),rng(:,5)];


function Range = PpDist(dist)

Range = 200*ones(size(dist));
in_range = dist>=0.2 & dist<=0.45;

Range(in_range) = Range(in_range)+((dist(in_range)-0.2)/(0.45-0.2))*150;

function [rng,dist,Range] = E_rangeGp(qp,f_dist)

dist = dist2p(qp(:,1),qp(:,2),qp(:,3),0,0,0);
E_avrg = f_dist(dist);
E_min = E_avrg-200;
E_max = E_avrg+200;
low = E_min<8;
E_min(low) = 8;

E_min = floor(E_min/8)*8;
E_max = floor(E_max/8)*8;
rng = [qp,E_min,E_max];

%[dist,ind] = unique(dist);
%Range = [rng(ind,4),rng(ind,5)];
Range = [rng(:,4),rng(:,5)];

function [rng,dist,Range] = E_rangeHp(qp,f_dist)

dist = dist2p(qp(:,1),qp(:,2),qp(:,3),1,0,0);
E_avrg = f_dist(dist);
E_min = E_avrg-200;
E_max = E_avrg+200;
high = E_max>800;
E_max(high) = 800;

E_min = floor(E_min/8)*8;
E_max = floor(E_max/8)*8;
rng = [qp,E_min,E_max];

%[dist,ind] = unique(dist);
%Range = [rng(ind,4),rng(ind,5)];
Range = [rng(:,4),rng(:,5)];




function dist = dist2p(px,py,pz,p1,p2,p3)
dist = sqrt((px-p1).*(px-p1)+(py-p2).*(py-p2)+(pz-p3).*(pz-p3));