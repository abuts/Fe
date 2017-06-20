function  [res100,res110,re111]=extract_and_plot_sw_par(obj,emin_real,emax_real)
% Method to view the life time and intensity of fitted sw
% 
% 
if ~exist('emin_real','var')    
    emin_real = obj.e_range(1);
    emax_real = obj.e_range(2);
end
    
[en100,S100,S100_err,G100,G100_err] = obj.extract_fitpar([1,0,0],emin_real:5:emax_real);
[en110,S110,S110_err,G110,G110_err] = obj.extract_fitpar([1,1,0],emin_real:5:emax_real);
[en111,S111,S111_err,G111,G111_err] = obj.extract_fitpar([1,1,1],emin_real:5:emax_real);
%-------------------------------------------------------------
brn = cellfun(@(br)(['[',num2str(br(1)),num2str(br(2)),num2str(br(3)),'];']),obj.bragg_list,'UniformOutput',false);
name = [brn{:}];
figure('Name',['Intensity scale for peaks: ',name]);
li1=errorbar(en100,S100,S100_err,'r');
hold on
li2=errorbar(en110,S110,S110_err,'g');
li3=errorbar(en111,S111,S111_err,'b');
%
plots = [li1, li2, li3];
ly 0 2.5
legend(plots,'<100>','<110>','<111>');
%-------------------------------------------------------------
figure('Name',['Inverse lifetime (meV) for peaks: ',name]);
li1=errorbar(en100,G100,G100_err,'r');
hold on
li2=errorbar(en110,G110,G110_err,'g');
li3=errorbar(en111,G111,G111_err,'b');
%
plots = [li1, li2, li3];
ly 0 80
legend(plots,'<100>','<110>','<111>');

res100 = [en100',S100,S100_err,G100,G100_err];
res110 = [en110',S110,S110_err,G110,G110_err];
re111 = [en111',S111,S111_err,G111,G111_err];


