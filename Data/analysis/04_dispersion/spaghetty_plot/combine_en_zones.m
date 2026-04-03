function result = combine_en_zones(pageop_obj,zones,trans_proj,source_proj,varargin)
% Combine multiple datasets 
% the coordinate system specified by pageop_obj.
%
% Inputs:
% pageop_obj  -- instance of PageOp_sqw_binning object containing
%                information about source sqw object(s), including page of
%                pixel data currently loaded in memory.
%

% get access to current page of pixels data, defined by input 
% PixedDataBase objects, assigned to pageop_obj on initialization
data = pageop_obj.page_data;
% 
ds_number = pageop_obj.page_num;
en_range = zones(ds_number);
in_range = data(4,:)>=en_range(1) & data(4,:)<=en_range(2);

result = data(:,in_range);
if isempty(result)
    return;
end
% Extract momentum coordinates from pixel data array.
q_coord = result(1:3,:);

coord_tr = source_proj(ds_number).transform_pix_to_img(q_coord);
result(1:3,:) = trans_proj.transform_img_to_pix(coord_tr);

end