function wtot=combine_cuts(w)
% Combine cuts.
%
%   >> wtot=combine_cuts(w)
%
% Assumes that combining is valid - no checks performed.
nbin_per_cut=arrayfun(@(x)(size(x.data.npix,1)),w);
nbin_selected = get_nbin_in_max(nbin_per_cut);
valid = arrayfun(@(x)(size(x.data.npix,1)==nbin_selected),w);

if ~all(valid)
    warning('COMBINE_CUTS:invalid_cuts',...
        'rejecting %d different cuts out of total %d',...
        sum(~valid),numel(valid))
    w= w(valid);
end

nw=numel(w);
if nw==1    % catch case of single cut
    wtot=w;
    return
end

nfiles=arrayfun(@(x)(x.main_header.nfiles),w);
npixtot=arrayfun(@(x)(size(x.data.pix,2)),w);


% Construct main header
main_header.filename='';
main_header.filepath='';
main_header.title='';
main_header.nfiles=sum(nfiles);

% Construct header
nend_f=cumsum(nfiles);
nbeg_f=nend_f-nfiles+1;
header=cell(nend_f(end),1);
for i=1:nw
    if nbeg_f(i)==nend_f(i)
        header(nbeg_f(i):nend_f(i))={w(i).header};
    else
        header(nbeg_f(i):nend_f(i))=w(i).header;
    end
end

% Construct data
nbin=size(w(1).data.npix,1);
npix=zeros(nbin,1);
nend=cumsum(npixtot);
nbeg=nend-npixtot+1;
pix=zeros(9,nend(end));
ibin=zeros(1,nend(end));
for i=1:numel(w)
    npix=npix+w(i).data.npix;
    pix(:,nbeg(i):nend(i))=w(i).data.pix;
    pix(5,nbeg(i):nend(i))=pix(5,nbeg(i):nend(i))+(nbeg_f(i)-1);
    ibin(nbeg(i):nend(i))=replicate_array(1:nbin,w(i).data.npix);
end
[~,ix]=sort(ibin);
pix=pix(:,ix);

data=w(1).data;
data.npix=npix;
data.pix=pix;

% Build final object
wtot.main_header=main_header;
wtot.header=header;
wtot.detpar=w(1).detpar;
wtot.data=data;

wtot=recompute_bin_data(wtot);
wtot=sqw(wtot);


%----------------------------------------------------------------------------------------
function vout = replicate_array (v, npix)
% Replicate array elements according to list of repeat indicies
%
%   >> vout = replicate_array (v, n)
%
%   v       Array of values
%   n       List of number of times to replicate each value
%
%   vout    Output array: column vector
%               vout=[v(1)*ones(1:n(1)), v(2)*ones(1:n(2), ...)]'

% Original author: T.G.Perring
%
% $Revision: 1524 $ ($Date: 2017-09-27 15:48:11 +0100 (Wed, 27 Sep 2017) $)

if numel(npix)==numel(v)
    % Get the bin index for each pixel
    nend=cumsum(npix(:));
    nbeg=nend-npix(:)+1;    % nbeg(i)=nend(i)+1 if npix(i)==0, but that's OK below
    nbin=numel(npix);
    npixtot=nend(end);
    vout=zeros(npixtot,1);
    for i=1:nbin
        vout(nbeg(i):nend(i))=v(i);     % if npix(i)=0, this assignment does nothing
    end
else
    error('Number of elements in input array(s) incompatible')
end

%----------------------------------------------------------------------------------------
function wout=recompute_bin_data(w)
% Given sqw_type object, recompute w.data.s and w.data.e from the contents of pix array
%
%   >> wout=recompute_bin_data(w)

% See also average_bin_data, which uses en essentially the same algorithm. Any changes
% to the one routine must be propagated to the other.

% Original author: T.G.Perring
%
% $Revision: 1524 $ ($Date: 2017-09-27 15:48:11 +0100 (Wed, 27 Sep 2017) $)

wout=w;

% Get the bin index for each pixel
nend=cumsum(w.data.npix(:));
nbeg=nend-w.data.npix(:)+1;
nbin=numel(w.data.npix);
npixtot=nend(end);
ind=zeros(npixtot,1);
for i=1:nbin
    ind(nbeg(i):nend(i))=i;
end

% Accumulate signal
wout.data.s=accumarray(ind,w.data.pix(8,:),[nbin,1])./w.data.npix(:);
wout.data.s=reshape(wout.data.s,size(w.data.npix));
wout.data.e=accumarray(ind,w.data.pix(9,:),[nbin,1])./(w.data.npix(:).^2);
wout.data.e=reshape(wout.data.e,size(w.data.npix));
nopix=(w.data.npix(:)==0);
wout.data.s(nopix)=0;
wout.data.e(nopix)=0;


function nbin= get_nbin_in_max(nbin_array)
% find the number of bing, which corresponds to maximal number of cuts
max_nbin = max(nbin_array);
nbin = max_nbin;
selected = arrayfun(@(x)(x == max_nbin),nbin_array);
n_other = sum(~selected);
n_selected = numel(nbin_array)-n_other;
while n_other ~=0
    nbin_array = nbin_array(~selected);
    max_nbin = max(nbin_array);
    selected = arrayfun(@(x)(x == max_nbin),nbin_array);
    n_other = sum(~selected);
    n_rest = numel(nbin_array)-n_other;
    if n_rest > n_selected 
        n_selected = n_rest;
        nbin = max_nbin;
    end
end
