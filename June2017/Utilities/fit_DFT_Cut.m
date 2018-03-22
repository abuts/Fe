function [fp_arr1,ws_arr_tf]=fit_DFT_Cut(cut_list)



sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);


for i=1:numel(cut_list)
    if isempty(fieldnames(cut_list(i).header{1}.instrument))
        cut_list(i) = set_sample_and_inst(cut_list(i),sample,@maps_instrument_for_tests,'-efix',600,'S');        
    end
end

% SW amplitude to fit
par = 0.1;

%
kk = tobyfit2(cut_list);
%ff_calc = mff.getFF_calculator(cut_list(1));
%kk = kk.set_local_foreground(true);
kk = kk.set_fun(@disp_dft_parameterized,par,1);


% set up its own initial background value for each background function
%bpin = fp_arr.bp;
%kk = kk.set_bfun(@lin_bg,bpin);

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-2;60;1.e-6]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
%profile on;
%[ws_arr_tf,fp_arr1]=kk.simulate;
[ws_arr_tf,fp_arr1]=kk.fit;
%profile off
%profile viewer

%




function bg = lin_bg(x,par)
%
bg  = par(1)+x*par(2);

