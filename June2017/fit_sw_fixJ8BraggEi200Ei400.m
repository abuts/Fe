function [cp2,cp4]=fit_sw_fixJ8BraggEi200Ei400(varargin)
%
%

bragg_list = {[1,1,0],[1,-1,0],[2,0,0],...
    [0,-1,-1],[1,0,-1],[0,1,-1],...
    [0,-1,1],[1,0,1]};
%bragg_list = {[0,-1,1]};

cp4 = cuts_le_processor(bragg_list,'Fe_ei401');
cp4.J0 = 80.3280;
cp4.J1 =  -6.4290;
cp4.J2 = -13.5589;
cp4.fit_par_range = [0,0,1,1,0,0,0,0,0,0];

%cp = cuts_processor(bragg_list,'Fe_ei401');
cp4 = cp4.refit_sw_findJ();

       
cp2 = cuts_le_processor(bragg_list,'Fe_ei200');
cp2.J0 = 80.3280;
cp2.J1 =  -6.4290;
cp2.J2 = -13.5589;
cp2.fit_par_range = [0,0,1,1,0,0,0,0,0,0];

%cp = cuts_processor(bragg_list,'Fe_ei401');
cp2 = cp2.refit_sw_findJ();

