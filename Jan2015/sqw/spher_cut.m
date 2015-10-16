function cut4D =spher_cut()
% Sample spherical cut
dr = [0.1,0.35];
en = [50,60];


data_source= fullfile('d:\users\abuts\SVN\Fe\Feb2013\sqw','sim_sqw_ei200.sqw');
proj = projection([1,0,0],[0,1,0]);
centre=[2,0,0];
cut4D = cut_sqw(data_source,proj,[1,0.01,3],[-1,0.01,1],[-1,0.01,1],[0,2,100]);
%save(cut4D,'Sim200_cutEi200.sqw')

cut4D= sqw_eval(cut4D,@sw_sqw_model,centre);
%save(cut4D,'Sim200_cutEi200.sqw')

%plot(cut3D);


proj = spher_proj(centre);
cut = cut_sqw(cut4D,proj,dr,[-90,2,90],4,en);
plot(cut)
keep_figure;
proj = projection([1,0,0],[0,1,0]);
cut = cut_sqw(cut4D ,proj,0.01,0.01,[-0.1,0.1],en);
plot(cut)
keep_figure;

return

data_source= fullfile('d:\users\abuts\SVN\Fe\Feb2013\sqw','Fe_ei200.sqw');
proj = [spher_proj([-1,-1,0]),...
    spher_proj([0,2,0]),spher_proj([0,-1,-1]),spher_proj([0,-1,1]),...
    spher_proj([1,1,0]),spher_proj([1,0,-1]),spher_proj([1,0,1]),spher_proj([1,-1,0]),spher_proj([2,0,0])];
proj_h = [spher_proj([1,1,0]),spher_proj([1,-1,0]),spher_proj([2,0,0])];


en = [50,60];
enh = [100,110];
dr_h = [0.2,0.45];
dr = [0.1,0.35];
mf = MagneticIons('Fe0');

%proj = proj_h;
%dr = dr_h;

cut_sum = [];
for i=1:numel(proj)
    prj = proj(i);
    cut = cut_sqw(data_source,prj,dr,[-90,2,90],4,en);
    cut= mf.fix_magnetic_ff(cut);
    
    %cut1 = cut_sqw(data_source,proj,[0,0.01,0.6],[-90,90],[-180,180],2);
    h=plot(cut);
    figure(h)
    lz 0 20
    keep_figure
    pause(1)    
    %    if isempty(cut_sum)
    %        cut_sum= cut;
    %    else
    %        cut_sum= combine_sqw(cut_sum,cut);
    %    end
end


cut_sum = [];
for i=1:numel(proj_h)
    prj = proj_h(i);
    cut = cut_sqw(data_source,prj,dr_h,[-90,2,90],4,enh);
    cut= mf.fix_magnetic_ff(cut);
    
    %cut1 = cut_sqw(data_source,proj,[0,0.01,0.6],[-90,90],[-180,180],2);
    h=plot(cut);
    figure(h)
    lz 0 20    
    keep_figure
    pause(1)
    %    if isempty(cut_sum)
    %        cut_sum= cut;
    %    else
    %        cut_sum= combine_sqw(cut_sum,cut);
    %    end
end

function weight=sw_sqw_model(h,k,l,en,k0)
D = 1024;
dRsq= 0.05;

hp=h-k0(1);
kp=k-k0(2);
pp=l-k0(3);
RSq = hp.*hp+kp.*kp+pp.*pp;
ep = en/D;
inside = RSq>=ep & RSq<=ep+dRsq;
weight=false(numel(ep),1);
weight(inside)=1;