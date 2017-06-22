function  stor=plot_EnCuts(cut_fname,varargin)
% View group of cuts,
%
%Load the group from hdd if this option is specified
%
options = {'-keep_fig'};
[ok,mess,keep_fig] = parse_char_options(varargin,options);
if~ok
    error('plot_EnCuts:invalid_argument',mess);
end


if isstruct(cut_fname)
    stor = EnCutBlock(cut_fname);
elseif isa(cut_fname,'EnCutBlock')
    stor = cut_fname;
else
    stor = EnCutBlock.load(cut_fname);
end

ps = pic_spread();

n_cuts = numel(stor.cuts_list);
disp('energies:')
disp(stor.cut_energies);
cuts_fitpar = stor.fit_param;
for j=1:n_cuts
    acolor('k');
    fh=plot(stor.cuts_list(j));
    acolor('r');
    pl(stor.fits_list(j));
    fprintf(' cut N: %d/%d\n',j,n_cuts);
    if iscell(cuts_fitpar.p)
        fitpar = cuts_fitpar.p{j};
        fiterr = cuts_fitpar.sig{j};
    else
        fitpar = cuts_fitpar.p;
        fiterr = cuts_fitpar.sig;
    end
    if numel(fitpar)==10
        fprintf(' par: %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f\n',fitpar(3:10));
        fprintf(' err: %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f\n',fiterr(3:10));
    end
    if keep_fig
        ps = ps.place_pic(fh);
        keep_figure();
    else
        pause(1)
    end
end


