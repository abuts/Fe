function CheckKunInterpValidity(varargin)
root_dir = fileparts(fileparts(mfilename('fullpath')));
data = fullfile(root_dir,'Data','sqw','Fe_ei1371_base.sqw');

persistent xyze_s;

if isempty(xyze_s)
    [ses,~,~,pxs,pys,pzs,ens]=read_add_sim_Kun(true,...
        false,false);
    xyze_s = [pxs',pys',pzs',ens',ses'];
end

if nargin>0
    e_range = varargin{1};
    e_min = e_range(1);
    e_max = e_range(2);    
else
    e_min = 40;
    e_max = 800;    
end
qxr = [1,0.05,5];
qyr = [-2,0.05,2];
qzr = [-0.1,0.1];
qx = qxr(1):qxr(2):qxr(3);
qy = qyr(1):qyr(2):qyr(3);
bravx = fix(qx');
bravy = fix(qy');

transl_x = unique(bravx);
transl_y = unique(bravy);

en = e_min:8:e_max;
proj = struct('u',[1,0,0],'v',[0,1,0]);

for i=1:numel(en)-1
    e_range = [e_min+(i-1)*8,e_min+(i)*8];
    w2 = cut_sqw(data,proj,qxr,qyr,qzr,e_range);
    %    
    w2s = sqw_eval(w2,@disp_dft_kun4D_lint,[1,0]);
    plot(w2s);
    keep_figure;
    % plot interpolation points
    in_range = xyze_s(:,4)>=e_range(1) & xyze_s(:,4)<e_range(2) & ...
        xyze_s(:,3)>=qzr(1) & xyze_s(:,3)<=qzr(2);    
    xyzesi = xyze_s(in_range,:);
    
    sub_points = [];
    for jj=1:numel(transl_y)-1
        for ii = 1:numel(transl_x)-1
            if abs(rem(transl_x(ii)+transl_y(jj),2))>0
                continue
            end
            lat = xyzesi+[transl_x(ii),transl_y(jj),0,0,0];
            sub_points = [sub_points;lat];
        end
    end
    hold on    
    mir = min(sub_points(:,5));
    mar = max(sub_points(:,5));    
    c = sub_points(:,5)*(10/(mar-mir));
    scatter(sub_points(:,1),sub_points(:,2),1,c,'*');
    hold off
end