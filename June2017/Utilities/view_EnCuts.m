function  stor=view_EnCuts(cut_fname,varargin)
% View group of cuts,
%   Detailed explanation goes here
options = {'-keep_fig'};
[ok,mess,keep_fig] = parse_char_options(varargin,options);
if~ok
    error('view_EnCuts:invalid_argument',mess);
end


if isstruct(cut_fname)
    stor = cut_fname;
else
    stor = load(cut_fname);
end

ps = pic_spread();

n_cuts = numel(stor.cut_list);
disp('energies:')
disp(stor.es_valid');
cuts_fitpar = stor.fp_arr1;
for j=1:n_cuts
    acolor('k');
    fh=plot(stor.cut_list(j));
    acolor('r');
    pl(stor.w1D_arr1_tf(j));
    fprintf(' cut N: %d/%d\n',j,n_cuts);
    if iscell(cuts_fitpar.p)
        fitpar = cuts_fitpar.p{j};
        fiterr = cuts_fitpar.sig{j};
    else
        fitpar = cuts_fitpar.p;
        fiterr = cuts_fitpar.sig;
    end
    fprintf(' par: %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f\n',fitpar(3:10));
    fprintf(' err: %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f\n',fiterr(3:10));
    if keep_fig
        ps = ps.place_pic(fh);
        keep_figure();
    else
        pause(1)
    end
end


