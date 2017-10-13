function wdisp = disp_dft_parameterized(qh,qk,ql,en,varargin)
%
%   Detailed explanation goes here
persistent hi_grid;
persistent q_axis;
persistent e_axis;
persistent transf_vec;
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
    %-0.7029    1.4075
    q_axis = single(0:q0/100:q0);
    e_axis = single(0:e_max/500:e_max);
    transf_vec = {[0,0,0],[-2,0,0],[2,0,0],...
        [-1,-1,0],[1,-1,0],[3,-1,0],...
        [0,2,0],[0,4,0],...
        [1,1,0],[1,3,0],[1,4,0],...
        [3,1,0],[3,3,0]};
end
% move all vectors into 0-1 quadrant where the interpoland is defined.
q3 = [qh,qk,ql];
sq2 = 1/sqrt(2.);
sm = [sq2,sq2,0;sq2,0,sq2;0,sq2,sq2];
brav = floor(q3*sm)/sm;
%q3r  = brav-floor(brav);
%qr = single(q3r/sm);

qr = single(q3r-brav);
% qr = zeros(size(q3));
% for i=1:numel(transf_vec)
%     qt = q3+transf_vec{i};
%     valid =qt(:,1)>=0 & qt(:,1)<=1 &qt(:,2)>=0 & qt(:,2) <=1;
%     qr(valid,:) = qt(valid,:);
% end

qhi = single(qr(:,1));
qki = single(qr(:,2));
qli = single(qr(:,3));
en  = single(en);

wdisp = interpn(q_axis',q_axis' ,q_axis' ,e_axis',hi_grid,qhi,qki,qli,en);

