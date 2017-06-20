function stor = build_stor_structure_(obj,CutID)
% build structure to store sequence of cuts corresponding to given energy
%
stor = struct();

binding = obj.equal_cuts_map(CutID);
ind = [binding{:}];

stor.cut_list = obj.cuts_list(ind);
stor.w1D_arr1_tf = obj.fits_list(ind);


cuts_fitpar=struct();
cuts_fitpar.p = obj.fitpar.p(ind);
cuts_fitpar.sig =obj.fitpar.sig(ind);
cuts_fitpar.bp  = obj.fitpar.bp(ind);
cuts_fitpar.bsig =obj.fitpar.bsig(ind);
cuts_fitpar.chisq = obj.fitpar.chisq;

stor.fp_arr1 = cuts_fitpar;

stor.es_valid = arrayfun(@f_en,stor.cut_list);



function en = f_en(sqw_obj)
en = 0.5*(sqw_obj.data.iint(2,3)+sqw_obj.data.iint(1,3));

