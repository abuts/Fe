function w = spectrum(varargin)
% SPECTRUM/SPECTRUM Spectrum class constructor
%
% Fields are:
%   x               Array of x values
%   y               Array of y values
%   e               Array of standard errors
%       [If length(x) = length(y)+1, then x values are taken as histogram bin boundaries.
%        If length(x) = length(y), then (x,y) are taken as points on a curve.]
%   title           Title for graphical display
%   xlab            X-axis label (excluding any explicit units declarations, see below)
%   ylab            Y-axis label (excluding any units arising from explicit declaration
%                  of being a distribution, see below)
%   xunits          Units of x-axis. e.g. 'meV'. The units will be incorporated into
%                  x-axis label at the moment of display.
%   distribution    =0 if y values are not a distribution in the units of the x-axis
%                   =1 if y values are a distribution
%                   If distribution=1, then the inverse of units of the x-axis as
%                  given by xunits will be used in the y-axis label at the moment of
%                  display.
%
%  e.g. if xlab = 'Energy transfer', ylab='Normalised counts', xunits = 'meV',
%       and distribution=1, then the labels for the x and y axis on a plot will be
%       'Energy transfer (meV)' and 'Normalised counts / meV'
%
% Syntax: 
%   >> w = spectrum(x,y)                                       x,y, arrays only
%   >> w = spectrum(x,y,e)                                     x,y,e arrays only
%   >> w = spectrum(x,y,e,title,xlab,ylab)                     with title and axis labels
%   >> w = spectrum(x,y,e,title,xlab,ylab,xunit)               with x-axis units
%   >> w = spectrum(x,y,e,title,xlab,ylab,xunit,distribution)  y values a distribution in x-axis units
%
%   >> w = spectrum(win)    % win is a structure with the fields of a spectrum
%
%   >> w = spectrum         % will return spectrum, but with zero values or empty strings for all fields
%
% Note: title, xlab, ylab can be character arrays, or cellarrays of character strings
%   e.g. xlab = {'hello' 'its' 'me'}
%        or   = {'hello' ; 'me old mate'}
%        or   = ['hello' ; 'tiger']
%

% Recursive call if given a single variable that is a structure. Is this the most efficient way ?

switch nargin
case 0  % default spectrum - empty fields
    w.x = [];
    w.y = [];
    w.e = [];
    w.title = '';
    w.xlab = '';
    w.ylab = '';
    w.xunit = '';
    w.distribution = 0;
    w = class(w,'spectrum');
    
case 1
    if (isa(varargin{1},'spectrum'))        % single input that is already a spectrum
        w = varargin{1};
    elseif (isa(varargin{1},'struct'))      % structure; calls spectrum recursively. is this the most efficient way ?
        for i=1:numel(varargin{1})
            if (isfield(varargin{1}(i),'x') & isfield(varargin{1}(i),'y') & isfield(varargin{1}(i),'e') & ...
                    isfield(varargin{1}(i),'title') & isfield(varargin{1}(i),'xlab') & isfield(varargin{1}(i),'ylab') & ...
                    isfield(varargin{1}(i),'xunit') & isfield(varargin{1}(i),'distribution') )
                w(i) = spectrum (varargin{1}(i).x, varargin{1}(i).y, varargin{1}(i).e, varargin{1}(i).title, ...
                    varargin{1}(i).xlab, varargin{1}(i).ylab, varargin{1}(i).xunit, varargin{1}(i).distribution);
            elseif isfield(varargin{1}(i),'x') & isfield(varargin{1}(i),'y') & isfield(varargin{1}(i),'e') & ...     % 1D mslice cut
                    isfield(varargin{1}(i),'title') & isfield(varargin{1}(i),'x_label') & isfield(varargin{1}(i),'y_label')
                w(i) = spectrum (varargin{1}(i).x, varargin{1}(i).y, varargin{1}(i).e, varargin{1}(i).title, ...
                    varargin{1}(i).x_label, varargin{1}(i).y_label);
            else
                error ('Wrong fields in structure for spectrum constructor')
            end
        end
    else
        error ('Wrong argument type for spectrum constructor')
    end
    
case {2,3,6,7,8}  % x,y double, x,y,e triple, or x,y,e,title,xlab,ylab,[xunit,[distribution]]
    % check type, size and dimensions of the x,y,e arrays; the arrays in the class are converted to column vectors
    if (nargin==2)
        if (isa(varargin{1},'double') & isa(varargin{2},'double'))
            dx=size(varargin{1}); dy=size(varargin{2});
            if (min(dx)==1 & min(dy)==1 & (max(dx)==max(dy)|max(dx)==max(dy)+1))
                w.x = varargin{1};
                w.y = varargin{2};
                w.e = zeros(max(dy),1);
                if (dx(1)==1)
                    w.x = w.x';
                end
                if (dy(1)==1)
                    w.y = w.y';
                end
            else
                error ('Inconsistent dimensions for x,y arrays in spectrum constructor')
            end
        else
            error ('Wrong argument types for spectrum constructor')
        end
    elseif (nargin>=3)
        if (isa(varargin{1},'double') & isa(varargin{2},'double') & isa(varargin{3},'double'))
            dx=size(varargin{1}); dy=size(varargin{2}); de=size(varargin{3});
            if (min(dx)==1 & min(dy)==1 & min(de)==1 & (max(dx)==max(dy)|max(dx)==max(dy)+1) & max(dy)==max(de))
                w.x = varargin{1};
                w.y = varargin{2};
                w.e = varargin{3};
                if (dx(1)==1)
                    w.x = w.x';
                end
                if (dy(1)==1)
                    w.y = w.y';
                end
                if (de(1)==1)
                    w.e = w.e';
                end
            else
                error ('Inconsistent dimensions for x,y,e arrays in spectrum constructor')
            end
        else
            error ('Wrong argument types for spectrum constructor')
        end
    end

    w.title = '';
    w.xlab = '';
    w.ylab = '';
    w.xunit = '';
    w.distribution = 0;

    % check title, xlab and ylab are cellarrays of strings or character arrays:
    if (nargin >=6)
        if ((iscellstr(varargin{4}) | ischar(varargin{4})) & (iscellstr(varargin{5}) | ischar(varargin{5})) ...
                & (iscellstr(varargin{6}) | ischar(varargin{6})))
            w.title = varargin{4};
            w.xlab = varargin{5};
            w.ylab = varargin{6};
        else
            error ('Wrong argument types for spectrum constructor')
        end
    end

    % check units
    if (nargin >=7)
        if (ischar(varargin{7}) & size(varargin{7},1)<=1)  % single character string (including empty string)
            if (length(deblank(varargin{7}))>0)  % if blank, then ensure units set = ''
                w.xunit = varargin{7};
            else
                w.xunit = '';
            end
        else
            error ('Wrong argument types for spectrum constructor')
        end
    end
    
    % check distribution (=0 then not a distribution in x units; =1 then is) - if units are blank, then must =0
    if (nargin >=8)
        if (isa(varargin{8},'double'))
            if ( (length(deblank(w.xunit))==0 & varargin{8}==0) | (length(deblank(w.xunit))>0 & ...
                    (varargin{8}==0|varargin{8}==1)) )
                w.distribution = varargin{8};
            else
                error ('Inconsistent values of units and distribution for spectrum constructor')
            end
        else
%            class(varargin{8})
            w=(varargin{8});
            error ('Wrong argument types for spectrum constructor')
        end
    end
    
%    w = class(w,'spectrum');
    
otherwise
    error ('Wrong number of input arguments for spectrum constructor')
end
