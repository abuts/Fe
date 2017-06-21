function  [res100,res110,res111]=...
    plot_sw_par(obj,emin_real,emax_real)
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
[ixS100,ixG100] = build_ds(en100,S100,S100_err,G100,G100_err,name);
[ixS110,ixG110] = build_ds(en110,S110,S110_err,G110,G110_err,name);
[ixS111,ixG111] = build_ds(en111,S111,S111_err,G111,G111_err,name);

acolor('r');
li1=plot(ixS100);
acolor('g');
li2=pd(ixS110);
acolor('b');
li3=pd(ixS111);
ly 0 2.5
plots = [li1, li2, li3];
legend(plots,'<100>','<110>','<111>');
%
%-------------------------------------------------------------
acolor('r');
li1=plot(ixG100);
acolor('g');
li2=pd(ixG110);
acolor('b');
li3=pd(ixG111);
ly 0 2.5
plots = [li1, li2, li3];
legend(plots,'<100>','<110>','<111>');
%
plots = [li1, li2, li3];
ly 0 80
legend(plots,'<100>','<110>','<111>');

res100 = [en100',S100,S100_err,G100,G100_err];
res110 = [en110',S110,S110_err,G110,G110_err];
res111 = [en111',S111,S111_err,G111,G111_err];

function [ixd_s,ixd_g]=build_ds(en,s,s_err,g,g_err,name)
valid = ~isnan(en);
ixd_s = IX_dataset_1d(en(valid),s(valid),s_err(valid),...
    ['Intensity scale for peaks',name],IX_axis('Energy transfer','mEv'),...
    IX_axis('intensity',''));

ixd_g = IX_dataset_1d(en(valid),g(valid),g_err(valid),...
    ['Inverse lifetime for peaks: ',name],IX_axis('Energy transfer','mEv'),...
    IX_axis('Decay','mEv'));



