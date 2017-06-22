function stor = build_stor_structure_(obj,CutID)
% build structure to store sequence of cuts corresponding to given energy
%


binding = obj.equal_cuts_map(CutID);
ind = [binding{:}];


cuts_fitpar=struct();
cuts_fitpar.p = obj.fitpar.p(ind);
cuts_fitpar.sig =obj.fitpar.sig(ind);
cuts_fitpar.bp  = obj.fitpar.bp(ind);
cuts_fitpar.bsig =obj.fitpar.bsig(ind);
cuts_fitpar.chisq = obj.fitpar.chisq;

stor = EnCutBlock(obj.cuts_list(ind),obj.fits_list(ind),cuts_fitpar);




