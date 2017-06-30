function  [stor,ps]=plot_EnCuts(cut_fname,varargin)
% View group of cuts,
% Inputs:
% either:
%  cut_fname -- the name of the .mat file containing energy cuts
% or:
%              EnCutBlock structure, containing the cuts
% or:
%              The structure, with cuts and fits which may be a source of
%              an EnCutBlock
% or:         3 values to build standard EnCut file name namely:
%             Ei,dE,direction
% where:  Ei :: the incident energy -- the key part of Fe_eiEi file name
%         dE :: the energy transfer defining the sequence of cuts
%   direction:: either
%               3-vector defining
%               sequence of equivalent directions
%              (e.g. [1,0,0] corresponging to <1,0,0> plains or [1,1,1])
%             or
%              a 3-digit integer, defining a sequence of directions
%              (e.g 100, 110 or 111);
%
%Load the group from hdd if this option is specified
%
options = {'-keep_fig','-tight'};
[ok,mess,keep_fig,tight,pars] = parse_char_options(varargin,options);
if~ok
    error('plot_EnCuts:invalid_argument',mess);
end
if ~keep_fig
    ps = [];
else
    if tight
        ps = pic_spread('-tight');
    else
        ps = pic_spread();
    end
    
    
end

if isstruct(cut_fname)
    stor = EnCutBlock(cut_fname);
elseif isa(cut_fname,'EnCutBlock')
    stor = cut_fname;
elseif isnumeric(cut_fname)
    Ei = cut_fname;
    dE = pars{1};
    dir = pars{2};
    if numel(dir) == 3
        dir = 100*dir(1)+10*dir(2)+dir(3);
    end
    cut_fname = ['EnCuts_Fe_ei',num2str(Ei),'_dE',num2str(dE),'_dir_!',num2str(dir),'!'];
    stor = EnCutBlock.load(cut_fname);
else
    stor = EnCutBlock.load(cut_fname);
end


n_cuts = numel(stor.cuts_list);
disp('energies:')
disp(stor.cut_energies');
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


