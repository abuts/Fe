function [fit_res,Sg,J0,Gamma,figa,figb] = refit_data_around_peaks(cuts_list,fit_res,peak_fraction,refit_data)
%REFIT_DATA_AROUND_PEAKS small utility which takes fit results and uses
%them to set-up and run fitting around SW peaks
%
%

input_is_struct = false;
if isstruct(fit_res)
    if isfield(fit_res,'peak_fit_par') && ~refit_data
        fit_par0   = num2cell(fit_res.peak_fit_par);
    else
        fit_par0 = num2cell(fit_res.all_fit_par); % Assign refit_data to fit_par0 if it's not a struct
        refit_data = true;
    end
    input_is_struct = true;
else
    fit_par0  = fit_res;
end

if refit_data
    n_runs = numel(fit_par0);
    peak_fit_par = cell(1,n_runs);
    for idx = 1:n_runs
        fprintf('*************************************************************\n');
        fprintf('*** step: %d#%d  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ***\n',idx,n_runs);
        fprintf('*************************************************************\n');
        cur_fit = fit_par0{idx};
        en_range = cur_fit.en_range;

        [~,ftpr,figa,figb]=refit_singleset_peaks(cuts_list,en_range,cur_fit,peak_fraction,true,true);
        peak_fit_par{idx} = ftpr;
        fprintf('*************************************************************\n');
        fprintf('*** <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< ***\n');
        fprintf('*************************************************************\n');        

    end
else
    peak_fit_par = fit_par0;
end
[Sg,Gamma,J0] = extract_fit_par(peak_fit_par);

if input_is_struct
    fit_res.peak_fit_par = [peak_fit_par{:}];
else
    fit_res = [peak_fit_par{:}];
end
end
