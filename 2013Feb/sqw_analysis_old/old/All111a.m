function All111a

BZ=[ -2,0,0; 2,0,0; 0,-2,0; 0,2,0; 0,0,-2; 0,0,2; 0,0,0];
%BZ=[ -1,-1,0; -1,1,0; -1,0,-1; -1,0,1];
%BZ=[0,-1,-1; 0,-1,1;  0,1,-1; 0,1,1];
%BZ=[1,-1,0; 1,1,0;    1,0,-1; 1,0,1];

d1 = BZ(:,1);
d2 = BZ(:,2);
d3 = BZ(:,3);


% Ei=400
DK = 0.1;
Kr = [-1,0.5*DK,1];
DE = [-8,4,250];
data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei401.sqw';
% % Ei=800
% DK = 0.1;
% Kr = [-2,DK,3];
% DE = [-16,8,400];
%data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei787.sqw';
% % Ei=1371
% DK = 0.15;
% Kr = [-2,DK,3];
% DE = [-16,15,400];
%data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei1371_base.sqw';



proj.u = [1,0,0];
proj.v = [0,1,0];
proj.type = 'ppp';
%proj.type = 'rrr';
%proj.type = 'aaa';
proj.uoffset = [0,0,0,0];




ic=0;
uRange = {[1,1,1], [1,-1,1], [1,1,-1],[-1,1,1]};
%         -1-1-1   -1  1-1,  -1-1 1     1-1-1 
rez = cell(numel(uRange));
for hkl=1:numel(d1)
    for kk=1:numel(uRange)
        [proj.u,proj.v,proj.w]=make_ortho_set(uRange{kk});
        %
        %Norm = 2*pi/2.87;
        Norm = 1;
        
        prj1=[d2(hkl)-DK,d2(hkl)+DK]*Norm;
        prj2=[d3(hkl)-DK,d3(hkl)+DK]*Norm;
        disp('------------------------------------------------------------');
        fprintf('-----------node :h: = %f :k: %f :l: %f :: ------\n',d1(hkl),d2(hkl),d3(hkl));        
        fprintf('-----------proj u   = %f ::: %f ::: %f :: ------\n',proj.u);
        disp('------------------------------------------------------------');
        
        prj0 = Kr*Norm;
        if numel(Kr)==3
            prj0(1)=prj0(1)+d1(hkl)*Norm;
            prj0(3)=prj0(3)+d1(hkl)*Norm;
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


