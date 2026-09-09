function [fg,pl_pannels]  = build_or_show_spaghetty()
% Build spaghetti plot if it is not present and show it to the users
% setting source information for this plot as the UserData field of the
% plot.
%
% If spaghetty plot is already present, get access to it and 
% return source information from UserData field

fg = findobj('Tag','Fe_Spaghetty_Plot');
if ~isempty(fg) && isgraphics(fg)
    pl_pannels = fg.UserData;
else
    [pl_pannels,fg] = build_spaghetti_from_data();
    fg.Tag = 'Fe_Spaghetty_Plot';
    fg.UserData = pl_pannels;
    fg.Name = 'Fe Dispersion search area';
end
end