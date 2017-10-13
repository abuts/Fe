function wdisp = disp_dft_parameterized(qh,qk,ql,en,varargin)
%
%   Detailed explanation goes here
persistent hi_grid;
persistent q_axis;
persistent e_axis;
%persistent x3;
%persistent x4;
if isempty(hi_grid)
    a0 = 2.866;
    e_max = 680;
    path = fileparts(mfilename('fullpath'));
    if isempty(varargin{1})
        disp('*** loading dft_data for interploation ****>')
        hi_grid= load(fullfile(path,'Volume.mat'),'dds');
        hi_grid = hi_grid.dds;
        disp('*** completed loading <*****')    
    else
        hi_grid = varargin{1};
    end
    q0 = 1;
    q_axis = single(0:q0/100:q0);
    e_axis = single(0:e_max/500:e_max);
    %[x1,x2,x3,x4] = ndgrid(q_axis,q_axis,q_axis,e_axis);
end
% move all vectors into 0-1 quadrant where the interpoland is defined.
q3 = [qh,qk,ql];
sq2 = 1/sqrt(2.);
sm = [sq2,sq2,0;sq2,0,sq2;0,sq2,sq2];
brav = q3*sm;


q3r  = brav-floor(brav);

%qr = single(q3r/sm);
qr = single(q3r);
qhi = abs(qr(:,1));
qki = abs(qr(:,2));
qli = abs(qr(:,3));
en  = single(en);

wdisp = interpn(q_axis',q_axis' ,q_axis' ,e_axis',hi_grid,qhi,qki,qli,en);

