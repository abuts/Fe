function cut_sum=spher_cut()
% Sample spherical cut
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

