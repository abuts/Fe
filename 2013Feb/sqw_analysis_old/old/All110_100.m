function All110_100

BZ=[ 2,0,0];
%BZ=[ -2,0,0; 2,0,0; 0,-2,0];
%BZ=[ 0,2,0; 0,0,-2; 0,0,2; 0,0,0];
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
proj.uoffset = [0,0,0,0];




ic=0;

uRange = {[1,1,0],[1,-1,0],[0,1,1],[0,1,-1],[-1,1,0],[-1,-1,0],[-1,0,1],[-1,0,-1]};
rez = cell(numel(uRange));
for hkl=1:numel(d1)
    for kk=1:numel(uRange)
        u0= uRange{kk}/2;
        u1=minNon0(u0);
        [proj.u,proj.v,proj.w]=make_ortho_set(u1-u0);
        %
        
        
        prj1=[-DK,+DK];
        prj2=[-DK,+DK];
        
        prj0 = Kr;
        proj.uoffset = [d1(hkl)+u0(1),d2(hkl)+u0(2),d3(hkl)+u0(3),0];
        ic = ic+1;
        disp('------------------------------------------------------------');
        fprintf('-----------node :h: = %f :k: %f :l: %f :: ------\n',d1(hkl),d2(hkl),d3(hkl));        
        fprintf('-----------proj u   = %f ::: %f ::: %f :: ------\n',proj.u);
        fprintf('-----------uoffset  = %f ::: %f ::: %f :: ------\n',proj.uoffset(1:3));        
        disp('------------------------------------------------------------');
        
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

function u1=minNon0(u)

u1=[0,0,0];
for i=1:3
    if abs(u(i))>1.e-6
        u1(i)=1;
        return;
    end
end
