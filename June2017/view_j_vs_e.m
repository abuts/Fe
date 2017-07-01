%
%cb2 = cuts_le_processor('J_CenFit_Fe_ei200_8Braggs_J0-0')
%jp2 = cb2.get_fitpar_vs_en(6,100)
%cb4 = cuts_le_processor('J_CenFit_Fe_ei401_8Braggs_J0-0')
%jp4 = cb4.get_fitpar_vs_en(6,100)
%cb4_3 = cuts_le_processor('J_fit_Fe_ei401_3Braggs_J0-0')
%jp4_3 = cb4_3.get_fitpar_vs_en(6,100)
acolor('r')
dd(jp4);
acolor('b')
pl(jp2)
aline(':')
pl(jp4_3);
ly 20 40

cb4.plot_sw_par();
