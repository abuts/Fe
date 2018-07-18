function fh = plot(obj,varargin)
%
% if -noextcted option is specified, plot only
% fittet SW and backgoud
accepted_options = {'-noextracted'};
[ok,mess,no_extracted]...
    = parse_char_options(varargin,accepted_options);
if ~ok
    error('EN_CUT_BLOCK:invalid_argument',mess);
end


acolor('k')
aline('-')
fh=plot(obj.cuts_list_(1));
for i=2:numel(obj.cuts_list_)
    pd(obj.cuts_list_{i})
end
acolor('r')
if isa(obj.fits_list(1),'sqw')
    
    pl(obj.fits_list(1))
    for i=2:numel(obj.cuts_list_)
        pl(obj.fits_list(i))
    end
elseif isstruct(obj.fits_list(1))
    if no_extracted
        pl(obj.fits_list(1).sum)
        pl(obj.fits_list(1).back)
    else
        pl(obj.fits_list(1).sum)
        acolor('g')
        pl(obj.fits_list(1).fore)
        pl(obj.fits_list(1).back)
    end
end

