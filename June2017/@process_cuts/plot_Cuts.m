function  cut_struct = plot_Cuts(obj,energy,direction,varargin)
% View sequence of cuts correspondent to energy transfer and direction provided
% as input and return the structure, usually stored with cut sequence
%
% options = {'-keep_fig'};
%

CutID = [num2str(energy),direction_id(direction)];

cut_struct = obj.build_stor_structure_(CutID);
plot_EnCuts(cut_struct,varargin{:});

