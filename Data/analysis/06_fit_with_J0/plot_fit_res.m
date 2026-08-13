%bs_fld = {'S','J0','gamma'};
%plot_field_name = {'Speak','J0peak','gamma_peak'};
bs_fld = {'Speak','J0peak','gamma_peak'};
plot_field_name = {'Speak_varsl','J0peak_varsl','gamma_peak_varsl'};



acolor b; plot(fit_resEi800.(bs_fld{1}))
acolor b; pd(fit_resEi800.(plot_field_name{1}))
acolor r; pp(fit_resEi200.(bs_fld{1}))
acolor r; pd(fit_resEi200.(plot_field_name{1})); 
acolor g; pp(fit_resEi400.(bs_fld{1}))
acolor g; pd(fit_resEi400.(plot_field_name{1})); 

ly 0 2
keep_figure
acolor b; plot(fit_resEi800.(bs_fld{2}))
acolor b; pd(fit_resEi800.(plot_field_name{2}))
acolor r; pp(fit_resEi200.(bs_fld{2}))
acolor r; pd(fit_resEi200.(plot_field_name{2}))
acolor g; pp(fit_resEi400.(bs_fld{2}))
acolor g; pd(fit_resEi400.(plot_field_name{2}))

ly 10 50
keep_figure
acolor b; plot(fit_resEi800.(bs_fld{3}))
acolor b; pd(fit_resEi800.(plot_field_name{3}))
acolor r; pp(fit_resEi200.(bs_fld{3}))
acolor r; pd(fit_resEi200.(plot_field_name{3}))
acolor g; pp(fit_resEi400.(bs_fld{3}))
acolor g; pd(fit_resEi400.(plot_field_name{3}))
ly 0 200
keep_figure