bp = [0,0,0;1,0,0;0.5,0.5,0;0,0,0;1/2,1/2,1/2;1/2,1/2,0];
%E200 DS_enhanced  [1,1,0]
%J0: 27.8836 +/- 0.08

%Ei400 DS3
% J0: 33.72 +/- 0.1
% drc = dispersion_plot([2.83,2.83,2.83,90,90,90],bp,@disp_bcc_hfm,[1,0,27.8836,0,0,0,0],'noplot');
% aline('-');
% acolor('r');
% [~,~,pl1]=dl(drc);
% drc = dispersion_plot([2.83,2.83,2.83,90,90,90],bp,@disp_bcc_hfm,[1,0,40,0,0,0,0],'noplot');
% aline('--');
% [~,~,pl2]=pl(drc);

%E400 DS3  [1,1,0]
%J0: 25.6 +/- 0.8
%J1: 8.04+/- 0.8;
%E400 DS3 [1,-1,0]
%J0: 27.346 +/- 0.630
%J1:  6.549 +/- 0.626;

% 
% acolor('g');
% aline('-');
% % drc = dispersion_plot([2.83,2.83,2.83,90,90,90],bp,@disp_bcc_hfm,[1,0,23.6,8.04,0,0,0],'noplot');
% [~,~,pl3]=pl(drc);
% drc = dispersion_plot([2.83,2.83,2.83,90,90,90],bp,@disp_bcc_hfm,[1,0,27.346,6.549,0,0,0],'noplot');
% aline('--');
% [~,~,pl4]=pl(drc);
% 
%"E200:  [1,1,0]
%J0: 28.146 +/- 0.068;
%J1: 12.931 +/- 0.064;
%J2: -4.232 +/- 0.020 
%E400 DS3 [1,1,0]
%J0:64.120 +/- 3.159; 
%J1: -8.249 +/- 2.186;
%J2: -7.536 +/- 0.524
%Ei400 DS3 [1,-1,0]
%J0: 65.663 +/- 3.055; 
%J1: -7.930 +/- 2.153; 
%J2: -8.047 +/- 0.476;

% aline('-');
% drc = dispersion_plot([2.83,2.83,2.83,90,90,90],bp,@disp_bcc_hfm,[1,0,28.146,12.931,-4.232,0,0],'noplot');
% acolor('b')
% aline('--');
% pl(drc)
% drc = dispersion_plot([2.83,2.83,2.83,90,90,90],bp,@disp_bcc_hfm,[1,0,64.120,-8.249,-7.536,0,0],'noplot');
% pl(drc)
acolor('r')
aline('-');
drc = dispersion_plot([2.83,2.83,2.83,90,90,90],bp,@disp_bcc_parameterized,[1,0,1],'noplot');
dl(drc)
% aline(':');
acolor('g')
drc = dispersion_plot([2.83,2.83,2.83,90,90,90],bp,@disp_bcc_hfm,[1,0,63.7446   -5.4095   -8.7849,0,0],'noplot');
pl(drc)
drc = dispersion_plot([2.83,2.83,2.83,90,90,90],bp,@disp_bcc_hfm,[1,0,46.8437   13.9260    2.6047   -5.0698,0],'noplot');
acolor('b')
pl(drc)
%ly 0 180







