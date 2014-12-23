function All05_05_0

d1 = [-1,0,1,0,0];
d2 = [0,0,0,-1,1];


% % Ei=400
% DK = 0.1;
% Kr = [-2,0.5*DK,3];
% DE = 4;
% % Ei=800
%DK = 0.02;
%DKcut = 0.05;
%Kr = [-2,DK,2];
%DE = [-16,8,400];
%data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei787.sqw';
% DK = 0.1;
% Kr = [-2,DK,3];
% DE = [-16,8,400];
% % Ei=1371
DK = 0.1;
DKcut = 0.1;
Kr = [-2,DK,2];
%Kr = DK;
DE = [-16,8,400];
%DE=16;
data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei1371_base.sqw';


proj_100.u = [1,1,0];
proj_100.v = [1,-1,0];
proj_100.type = 'rrr';
proj_100.uoffset = [0,0,0,0];



ic=0;
prj = cell(3);
rez = cell(15);
for i=1:3
    prj{i} =Kr;
    k1=i+1;
    if(k1>3)
       k1=1;
    end
    k2 = k1+1;
    if(k2>3)
        k2=1;
    end
     
    for j=1:5
       
        prj{k1}=[d1(j)-DKcut,d1(j)+DKcut];
        prj{k2}=[d2(j)-DKcut,d2(j)+DKcut];
 
        disp('------------------------------------------------------------');
        fprintf('-----------axis i = %d cut :: %f :: %f :: ------\n',i,d1(j),d2(j));
        disp('------------------------------------------------------------');            
        ic = ic+1;            
        rez{ic} = cut_sqw(data_source,proj_100,prj{1},prj{2},prj{3},DE,'-nopix');

        
    end
end    

fprintf(' IC= %d\n', ic)


for i=1:ic
     plot(rez{i});
     lz(0,1);
     keep_figure;
end
