function [cont,q0] = read_kun(file)

[q1,q2,q3,dE,s] = textread(file,'%f %f %f %f %f');
q0 = [q1(1),q2(1),q3(1)];

q1 = q1-q1(1);
q2 = q2-q2(1);
q3 = q3-q3(1);
Ny = floor(numel(q1)/100);

q1= reshape(q1,100,Ny);
q2= reshape(q2,100,Ny);
q3= reshape(q3,100,Ny);
dE= reshape(dE,100,Ny);
s = reshape(s, 100,Ny);

q = sqrt(q1.^2+q2.^2+q3.^2);

cont = IX_dataset_2d(q(1,:),dE(:,1),s);