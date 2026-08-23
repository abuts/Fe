function fit_res = plot_j0_fit_result(fit_res,varargin)
if nargin > 1
    file_name = varargin{1};
    file_name = strrep(file_name,'_','\_');
    fit_res.S.title = ['Amplitude, ',file_name];
    fit_res.gamma.title =['Gamma, ',file_name ];
    fit_res.J0.title =['J0, ',file_name];
end

plot(fit_res.S); ly 0 2;keep_figure;
plot(fit_res.J0); ly 0 60; keep_figure;
plot(fit_res.gamma);ly 0 200; keep_figure;
end
