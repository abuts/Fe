function fh = plot(obj)
%
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
    pl(obj.fits_list(1).sum)
    acolor('g')
    pl(obj.fits_list(1).fore)
    pl(obj.fits_list(1).back)
end



