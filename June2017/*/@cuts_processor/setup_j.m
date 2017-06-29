function  [obj,fitpar,fiterr,capt] = setup_j(obj,fp_arr1)
% extract and display exchange interaction energies using fitted data as
% input
%
if ~exist('fp_arr1','var')
    if ~isempty(obj.fitpar)
        fp_arr1 = obj.fitpar;
        setup_j = true;
    else
        setup_j = false;
    end
else
    setup_j = true;
end
if setup_j
    if iscell(fp_arr1.p)
        fitpar = reshape([fp_arr1.p{:}],10,numel(fp_arr1.p))';
        fiterr = reshape([fp_arr1.sig{:}],10,numel(fp_arr1.sig))';
    else
        fitpar = fp_arr1.p;
        fiterr = fp_arr1.sig;
    end
    obj.J0 = fitpar(1,6);
    obj.J1 = fitpar(1,7);
    obj.J2 = fitpar(1,8);
    obj.J3 = fitpar(1,9);
    obj.J4 = fitpar(1,10);
    
    obj.J0_err = fiterr(1,6);
    obj.J1_err = fiterr(1,7);
    obj.J2_err = fiterr(1,8);
    obj.J3_err = fiterr(1,9);
    obj.J4_err = fiterr(1,10);
else
    fitpar = [];
    fiterr = [];
end

capt = sprintf([' J for selected cuts:\n J0: %6.3f +/-%6.3f; J1: %6.3f +/-%6.3f;',...
    ' J2: %6.3f +/-%6.3f\n J3: %6.3f +/-%6.3f  J4: %6.3f +/-%6.3f\n'],...
    obj.J0,obj.J0_err,obj.J1,obj.J1_err,obj.J2,obj.J2_err,obj.J3,obj.J3_err,obj.J4,obj.J4_err);
disp(capt);




