% plot DFT -sumulated dispersion
%
wt=sqw_plot([2.84,2.84,2.84,90,90,90],[0,0,0;0,1,0;0.5,0.5,0;0,0,0;0.5,0.5,0.5;0.5,0.5,0],...
    @disp_dft_parameterized,[1,0],[0,1,680]);
