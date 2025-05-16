function result = move_all_to_proj(pageop_obj,proj_array,range)
% convert all equivalent directions found in the input dataset into the
% cut projection's direction.
% 
% Inputs:
% pageop_obj  -- instance of PageOp_sqw_binning object containing
%                information about source sqw object(s), including page of
%                pixel data currently loaded in memory.
% proj_array  -- array of projections which describe alternative directions
%                and cuts in the directions to combine.
% range       -- two elements min/max array of values to exclude frin data
% 
% Retugns
% result      -- page of modified pixels data to bin using
%                PageOp_sqw_binning algorithm
% 
%
data = pageop_obj.page_data;
targ_proj = pageop_obj.proj;
q_coord = data(1:3,:);
result = cell(1,numel(proj_array));
for i=1:numel(proj_array)
    coord_tr = proj_array(i).transform_pix_to_img(q_coord);
    include = coord_tr(2,:)>=range(1)&coord_tr(2,:)<=range(2)&coord_tr(3,:)>=range(1)&coord_tr(3,:)<=range(2);
    coord_tr  = coord_tr(:,include);
    res_l = data(:,include);
    res_l(1:3,:) = targ_proj.transform_img_to_pix(coord_tr);
    result{i} = res_l;

    data = data(:,~include);
    if isempty(data)
        break
    end
    q_coord = data(1:3,:);    
end
result = cat(2,result{:});
end