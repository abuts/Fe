function [cont,q_bg,q1,q2,q3,dE,s] = read_kun(file,IXd_format,zero_shift)

Np = 100;

[q1,q2,q3,dE,s] = textread(file,'%f %f %f %f %f');
q_bg = [q1(1),q2(1),q3(1)];
q_end=[q1(end),q2(end),q3(end)];

Ny = floor(numel(q1)/Np );
q1= reshape(q1,Np ,Ny);
q2= reshape(q2,Np ,Ny);
q3= reshape(q3,Np ,Ny);
dE= reshape(dE,Np ,Ny);
s = reshape(s, Np ,Ny);
if nargin<3
    zero_shift = true;
end
if zero_shift
    q1 = q1-q_bg(1);
    q2 = q2-q_bg(2);
    q3 = q3-q_bg(3);
    q = sqrt(q1.^2+q2.^2+q3.^2);
else
    q = sqrt((q1-q_bg(1)).^2+(q2-q_bg(2)).^2+(q3-q_bg(3)).^2);
end

if ~exist('IXd_format','var')
    IXd_format = false;
end
if IXd_format
    cont = IX_dataset_2d(q(1,:),dE(:,1),s);
else
    q_bg = [q_bg,q_end];
    cont = {q,dE,s};
end