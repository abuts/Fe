function [ws,all_cuts]= draw_masks_helper(fh,all_cuts,mask_field_name,varargin)
% Helper function to draw number of masks on an image used by a
% directional cut script (mlx)
% Inputs:
% fh        -- handle for the figure to draw mask on
% all_cuts  -- structure, containing mask information
% mask_field_name
%           -- the name of the field, which contains mask information
% Returns:
% ws        -- masked workspace
% all_cuts  -- the structure with fireld containing (modified) mask
%              information.
% If all_cuts.(mask_field_name) contains cellarray of non-empty masks
%              the routine applies this masks to the workspace.
%              If mask_field_name in the structure is absent or
%              some masks within this structure are empty, function returns
%              control to user to draw appropriate masks.
%              Existing masks are still applied to workspace
ws= src(fh);
if isfield(all_cuts,all_cuts)
    n_msks = numel(all_cuts.(mask_field_name));
else
    if nargin>3
        n_msks = varargin{1};
    else
        n_msks = 1;
    end
    all_cuts.(mask_field_name) = cell(1,n_msks);
end

mask_vert = cell(1,n_msks);
empty_mask = false(1,n_msks);
apply_old_masks = false;
if isfield(all_cuts,mask_field_name)
    existing_masks = cell(1,n_msks);
    draw_new_masks = false;
    for i=1:n_msks
        existing_masks{i}   = all_cuts.(mask_field_name){i};
        if isempty(existing_masks{i})
            empty_mask(i) = true;
            draw_new_masks = true;
        else
            apply_old_masks = true;
        end
    end
else
    existing_masks = {};
    draw_new_masks = true;
end
draw_masked_ws= draw_new_masks&&apply_old_masks;
if apply_old_masks
    for i=1:n_msks
        mskVert = existing_masks{i};
        if ~empty_mask(i)
            [msk1,~,mask_vert{i}]  = draw_mask(fh,'mask_vertices',mskVert');
            ws= mask(ws,msk1);
            if (draw_masked_ws)
                plot(ws);
            end
        end
    end
end
if draw_new_masks
    for i=1:n_msks
        if empty_mask(i)
            [msk1,~,mskVert]  = draw_mask(fh);
        else
            continue
        end
        mask_vert{i} = mskVert;
        ws = mask(ws,msk1);
        if (draw_masked_ws)
            plot(ws);
        end
    end
end
all_cuts.(mask_field_name)= mask_vert;
end