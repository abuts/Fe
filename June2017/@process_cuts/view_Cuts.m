function  cut_struct = view_Cuts(obj,energy,direction,varargin)
% View sequence of cuts correspondent to energy transfer and direction provided
% as input and return the structure, usually stored with cut sequence
%

CutID = [num2str(energy),direction_id(direction)];

cut_struct = obj.build_stor_structure_(CutID);
view_EnCuts(cut_struct,varargin{:});



