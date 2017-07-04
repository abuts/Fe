function  [cut_struct,ind] = plot_Cuts(obj,energy,direction,varargin)
% View sequence of cuts correspondent to energy transfer and direction provided
% as input and return the structure, usually stored with cut sequence
% inputs:
%
% options = {'-keep_fig'};
%

CutID = [num2str(energy(1)),direction_id(direction)];

[cut_struct,ind] = obj.build_stor_structure_(CutID);
[cut_struct,plot_map]=plot_EnCuts(cut_struct,varargin{:});


for i=2:numel(energy)
    CutID = [num2str(energy(i)),direction_id(direction)];
    
    cut_struct = obj.build_stor_structure_(CutID);
    [~,]=plot_EnCuts(cut_struct,plot_map,varargin{:});
end

