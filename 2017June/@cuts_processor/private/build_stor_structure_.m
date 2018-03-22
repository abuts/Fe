function [stor,ind] = build_stor_structure_(obj,CutID)
% build structure to store sequence of cuts corresponding to given energy
%


binding = obj.equal_cuts_map(CutID);
ind = [binding{:}];

cuts_fitpar = select_fitpar(obj.fitpar,ind);

stor = EnCutBlock(obj.cuts_list(ind),obj.fits_list(ind),cuts_fitpar);

file_list = obj.file_list;
FileSourceID = [file_list{:}];
direction_id = regexp(CutID,'[<>]');
dir_id = CutID(direction_id(1)+1:direction_id(2)-1);


stor.filename = sprintf('EnCuts_%s_dE%d_dir_!%s!',FileSourceID,stor.cut_energies(1),dir_id);




