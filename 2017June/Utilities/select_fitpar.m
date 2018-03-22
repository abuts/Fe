function fitpar_selected = select_fitpar(fitpar,keep_only)
% Build a structure, containing selected fitpar parameters
%

fitpar_selected=struct();
fitpar_selected.p = fitpar.p(keep_only);
fitpar_selected.sig =fitpar.sig(keep_only);
fitpar_selected.bp  = fitpar.bp(keep_only);
fitpar_selected.bsig =fitpar.bsig(keep_only);
fitpar_selected.chisq = fitpar.chisq;
fitpar_selected.converged = fitpar.converged;


end

