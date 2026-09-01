function fit_src_struc = save_selected_cuts(fit_src_struc,Jfitfile,field_name,cut_obj,force_save)
%
if ~exist('force_save','var')
    force_save = false;
end

if isempty(fit_src_struc)
    if isfile(Jfitfile)
        ld = load(Jfitfile);
        fit_src_struc = ld.fit_src_struc;
    else
        fit_src_struc = struct();
    end
end
if ~force_save && isfield(fit_src_struc,field_name)
    if equal_to_tol(fit_src_struc.(field_name),cut_obj,'-ignore_str','-ignore_date')
        return;
    end
end

fit_src_struc.(field_name) = cut_obj;
save(Jfitfile,'fit_src_struc','-v7.3')