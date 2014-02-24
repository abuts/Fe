function All100a

BZ=[ -2,0,0; 0,2,0; 0,0,2; 0,0,0];
%BZ=[ -1,-1,0; -1,1,0; -1,0,-1; -1,0,1];
%BZ=[0,-1,-1; 0,-1,1;  0,1,-1; 0,1,1];
%BZ=[1,-1,0; 1,1,0;    1,0,-1; 1,0,1];

scale = 2*pi/2.87;
%BZ = BZ*scale;
d1 = BZ(:,1);
d2 = BZ(:,2);
d3 = BZ(:,3);


% Ei=400
DK = 0.1;
Kr = [-1.2,0.5*DK,1.2];
DE = [-8,4,250];
% % Ei=800
% DK = 0.1;
% Kr = [-2,DK,3];
% DE = [-16,8,400];
% % Ei=1371
% DK = 0.15;
% Kr = [-2,DK,3];
% DE = [-16,15,400];

Rz=zeros(3,3);
Rz(3,3)=1;
Rz(1,2)=-1;
Rz(2,1)=1;
Rx = zeros(3,3);
Rx(1,1)=1;
Rx(2,3)=-1;
Rx(3,2)=1;


proj.u = [1,0,0];
proj.v = [0,1,0];
proj.type = 'ppp';
proj.uoffset = [0,0,0,0];
data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei401.sqw';
%data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei787.sqw';
%data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei1371_base.sqw';

ic=0;
uRange = {[1,0,0],[0,1,0],[0,0,1]};
rez = cell(numel(uRange));
for hkl=1:numel(d1)
    for kk=1:numel(uRange)
        [proj.u,proj.v,proj.w]=make_ortho_set(uRange{kk}); 
        %
%         proj.u = proj.u/scale;
%         proj.v = proj.v/scale;
%         proj.w = proj.w/scale;        
        
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
    %disp('-- enter something to contineue or ^C to finish ------------');    
    %pause
    ic=0;
end
