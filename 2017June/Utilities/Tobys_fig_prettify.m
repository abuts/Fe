function Tobys_fig_prettify (fh,notitle)
% Prettify a figure, optionally removing the title first

if ~exist('fh','var')
    fh = gcf;
else
    if ~ishandle(fh)
        notitle = fh;
        fh = gcf;
    end
end

if ~exist('notitle','var')
    notitle=true;
else
    notitle=false;
end

fontname = 'Arial';
fontsize = 14;
fontsize_title = 12;
linewidth = 0.3;    % in mm; will convert to points later on
ticklength = [0.025,0.025];

h=get(fh,'children');   % Get handles of children of figure

% Find the axis handle for the main plot
ax = h(strcmp(get(h,'type'),'axes')); % find which are axes objects - there should be two (the colorbar and main plot)
ax_bar = findobj(ax,'Tag','Colorbar');  % colorbar object
if ~isempty(ax_bar)
    ax_main = ax(ax~=ax_bar);    % the main plot
else
    ax_main = ax;
end

% Delete unwanted uicontrols and determine which object is the main plot and which is the colorbar
uicont = h(strcmp(get(h,'type'),'uicontrol'));
delete(uicont)

% Change annotations and ticks
set(ax_main,'fontsize',fontsize,'fontname',fontname)

if notitle
    delete(get(gca,'title'))
else       
    set(get(ax_main,'Title'),'fontsize',fontsize_title,'fontname',fontname)
end
set(get(ax_main,'Xlabel'),'fontsize',fontsize,'fontname',fontname)
set(get(ax_main,'Ylabel'),'fontsize',fontsize,'fontname',fontname)

set(ax_main,'linewidth',linewidth/0.352777778);
set(ax_main,'ticklength',ticklength);
set(ax_main,'layer','top');         % ticks above graphics

% saveas(gcf,'c:\temp\crap.emf')


