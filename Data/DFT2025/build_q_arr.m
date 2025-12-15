function [q_rid,dist_pt,scales]=build_q_arr(dir,NppEdge,datasets2plot)
% build q values for plotting dispersion line on a spagetti plot.
% Inputs:
% dir -- cellarray of 3-vectors, defining spagetti plot ref points
% NppEdge -- number of q-points for each spagetti plot direction
% Outputs:
% q_rid -- cellarray of q-points {qh,qk,ql} to calculate dispersion 
% dist_pt -- array of distances along q-direction as plotted on a spagetti plot
% scales  -- array of spagetti plot length-es

norm_provided = false;
if exist('datasets2plot','var')
    norm_provided = true;
end

n_points = (numel(dir)-1)*NppEdge;
qh = zeros(n_points,1);
qk = zeros(n_points,1);
ql = zeros(n_points,1);
dist_pt = zeros(n_points,1);
scales = zeros((numel(dir)-1),1);
q0 = 0;

ip = 0:NppEdge-1;
for i=2:numel(dir)
    e0 = dir{i-1};
    ort = dir{i}-e0;
    if norm_provided
        norm = datasets2plot(i-1).x(end);
    else
        norm = sqrt(sum(ort.*ort));
    end
    scales(i-1)= norm;
    ort = ort/norm;
    step = norm/(NppEdge-1);
    
    loc_ind = (i-2)*NppEdge+ip+1;

    dist_block = ip*step;
    
    dist_pt(loc_ind) = q0+dist_block ;
    qh(loc_ind) = e0(1)+ort(1)*dist_block;
    qk(loc_ind) = e0(2)+ort(2)*dist_block;
    ql(loc_ind) = e0(3)+ort(3)*dist_block;    
    q0 = dist_pt(loc_ind(end));
end
q_rid = {qh,qk,ql};


