function final_cut = cut_symop(data,proj0,q_range,Dqk ,Dql ,Erange,bg_fun,bg_param,...
    sym_op,sym_axis,...
    plot_final_result_only)
% helper function to make symmetic cuts and extract background
%
% Inputs:
% data -- the reference to file/sqw object, -- source of cuts.
% proj0 -- the projection, defining reference cut
% Dqk Dql -- integration limits in k and l directions
% Erange -- 3 element arra, defining cut in energy direction
% bg_fun -- the function used to evaluate background. if empty, build
%            background through replication.
% bg_param -- the parameters for background evaluation function or
%             integration ranges if replication is used
% sym_op --   cellarray of symops to combine cuts
% sym_axis -- the axis for final symetrisation
% plot_final_result_only - if true, close all previous images.
%
% Output:
% final_cut  -- symetrised final cut


% sum cuts to plot the part of the dispersion in  NP direction

[com_cut,part_cuts] = cut_sqw_sym(data,proj0,q_range,Dqk ,Dql ,Erange,sym_op);
% does not work. Bug in symcut?
if isempty(bg_fun)    
    if iscell(bg_param)
        cut_par = bg_param{1};
        n_cuts = numel(bg_param);
    else
        cut_par = bg_param;
        n_cuts = 0;
    end
    bg_cut = cut_sqw(com_cut,proj0,cut_par,Dqk ,Dql ,Erange);            
    for i=2:n_cuts
        bb = cut_sqw(com_cut,proj0,bg_param{i},Dqk ,Dql ,Erange);            
        bg_cut = combine_sqw(bg_cut,bb);
    end
    
    bg = replicate(bg_cut,com_cut);
    acolor('k');
    plot(bg_cut);    
else
    com_c1 = cut_sqw(com_cut,proj0,[-2,3],Dqk ,Dql ,Erange);
    %com_c1 = cut_sqw_sym(data,proj{9},[-2,3],Dqk ,Dql ,[0,dE,Emax],sym_op);
    bg_eval1D = func_eval(com_c1,bg_fun,bg_param);
    acolor('k');
    plot(com_c1)
    acolor('r')
    pl(bg_eval1D)
    logy
    keep_figure;
    bg = func_eval(com_cut,@(q,en,par)(par(1)*exp(-par(2)*(en-50))),bg_param);
end
dis_cut = com_cut -bg;
if plot_final_result_only
    close all
end

plot(dis_cut)
liny
keep_figure;
ly 0 500
lz  0 0.02
%
mff = MagneticIons('Fe0');
dis_cut_cor = mff.correct_mag_ff(dis_cut);
plot(dis_cut_cor)
keep_figure;
lz 0 0.5

v1=sym_axis{1}; v2=sym_axis{2}; v3=sym_axis{3};
final_cut =symmetrise_sqw(dis_cut_cor,v1,v2,v3);
plot(final_cut)
lz 0 0.5
keep_figure;
final_cut = cut_sqw(final_cut,proj0,[0.5,0.01,1],Dqk ,Dql ,Erange);
plot(final_cut)
lz 0 0.5
keep_figure;
dis_cut_theor = sqw_eval(final_cut,@disp_dft_param_Kun,[1,1]);
plot(dis_cut_theor)
lz 0 0.3
keep_figure;


