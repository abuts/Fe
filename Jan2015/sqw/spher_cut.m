function cut_sum=spher_cut()
% Sample spherical cut
data_source= fullfile('d:\users\abuts\SVN\Fe\Feb2013\sqw','Fe_ei200.sqw');
proj = [spher_proj([-1,-1,0]),...
        spher_proj([0,2,0]),spher_proj([0,-1,-1]),spher_proj([0,-1,1]),...
        spher_proj([1,1,0]),spher_proj([1,0,-1]),spher_proj([1,0,1]),spher_proj([1,-1,0]),spher_proj([2,0,0])];
proj_h = [spher_proj([1,1,0]),spher_proj([1,-1,0]),spher_proj([2,0,0])];
dr_h = [0.25,0.45];
%en = [50,60];
en = [100,110];
dr = [0.15,0.25];
mf = MagneticIons('Fe0');

proj = proj_h;
dr = dr_h;

cut_sum = [];
for i=1:numel(proj)
    prj = proj(i);
    cut = cut_sqw(data_source,prj,dr,[-90,2,90],4,en);
    cut= mf.fix_magnetic_ff(cut);

    %cut1 = cut_sqw(data_source,proj,[0,0.01,0.6],[-90,90],[-180,180],2);
    h=plot(cut,'-noasp');
    figure(h)
    keep_figure
    pause(1)
    if isempty(cut_sum)
        cut_sum= cut;
    else
        cut_sum= combine_sqw(cut_sum,cut);
    end
end


