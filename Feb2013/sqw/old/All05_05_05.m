function All05_05_05

D=[-2,0,0;0,2,0; 0,0,2;
   -1,-1,0; -1,0,-1; -1,0,0; -1,1,0;-1,0,1;
   0,-1,-1; 0,-1,0; 0,0,-1; 0,0,0; 0,1,0; 0,0,1; 0,1,1;
   1,0,-1; 1,-1,0; 1,0,0; 1,1,0; 1,0,1];

d1 = D(:,1);
d2 = D(:,2);
d3 = D(:,3);


% % Ei=400
DK = 0.1;
Kr = 0.05;
%Kr = [-2,0.5*DK,2];
DE = [-8,4,200];
% % Ei=800
%DK = 0.1;
%Kr = DK;
%DE = 4;
% DK = 0.1;
% Kr = [-2,DK,3];
% DE = [-16,8,400];
% % Ei=1371
%DK = 0.2;
%Kr = DK;
%DE = 16;




Rz=zeros(3,3);
Rz(3,3)=1;
Rz(1,2)=-1;
Rz(2,1)= 1;


proj.type = 'rrr';
proj.uoffset = [0,0,0,0];
data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei401.sqw';
%data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei787.sqw';
%data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei1371_base.sqw';

ic=0;

uRange = {[1,1,1],[-1,1,1],[1,-1,1],[-1,-1,1],[1,1,-1],[-1,1,-1],[1,-1,-1],[-1,-1,-1]};
rez = cell(numel(uRange));
for hkl=1:numel(d1)
    for kk=1:numel(uRange)
        proj.u = uRange{kk};
        proj.v = (Rz*proj.u')';
        proj.w = cross(proj.u,proj.v);
        
        prj1=[d2(hkl)-DK,d2(hkl)+DK];
        prj2=[d3(hkl)-DK,d3(hkl)+DK];
        disp('------------------------------------------------------------');
        fprintf('-----------proj u   = %f ::: %f ::: %f :: ------\n',proj.u);
        fprintf('-----------node :h: = %f :k: %f :l: %f :: ------\n',d1(hkl),d2(hkl),d3(hkl));
        disp('------------------------------------------------------------');
        
        prj0 = Kr;
        if numel(Kr)==3
            prj0(1)=prj0(1)+d1(hkl);
            prj0(3)=prj0(3)+d1(hkl);
        else
        end
        
        ic = ic+1;
        rez{ic} = cut_sqw(data_source,proj,prj0,prj1,prj2,DE,'-nopix');
        
        
    end
    for i=1:ic
     plot(rez{i});
     lz(0,1);
     keep_figure;
    end    
    disp('-- enter something to contineue or ^C to finish ------------');    
    pause
    ic=0;
end
%fprintf(' IC= %d\n', ic)



