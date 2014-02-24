function All110b

BZ=[ 2,0,0; 1,1,0]; % for 200mEv
%BZ=[ -2,0,0; 2,0,0; 0,-2,0; 0,2,0; 0,0,-2; 0,0,2; 0,0,0];
%BZ=[ -1,-1,0; -1,1,0; -1,0,-1; -1,0,1]; %
%BZ=[0,-1,-1; 0,-1,1;  0,1,-1; 0,1,1]; %
%BZ=[1,-1,0; 1,1,0;    1,0,-1; 1,0,1];

d1 = BZ(:,1);
d2 = BZ(:,2);
d3 = BZ(:,3);


% Ei=200
DK = 0.05;
Kr = [-1,0.5*DK,1];
DE = [-8,2,180];
data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei200.sqw';


% % Ei=400
% DK = 0.1;
% Kr = [-1,0.5*DK,1];
% DE = [-8,4,250];
% data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei401.sqw';
% Ei=800
% DK = 0.1;
% Kr = [-1,0.5*DK,1];
% DE = [-16,8,400];
% data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei787.sqw';
% % Ei=1371
% DK = 0.1;
% Kr = [-2,DK,2];
% DE = [-16,8,400];
% data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei1371_base.sqw';


proj.u = [1,0,0];
proj.v = [0,1,0];
proj.type = 'ppp';
%proj.type = 'rrr';
proj.uoffset = [0,0,0,0];




ic=0;
uRange = {[1,1,0],[1,-1,0],[0,1,1],[0,1,-1]};
rez = cell(numel(uRange));
for hkl=1:numel(d1)
    for kk=1:numel(uRange)
        [proj.u,proj.v,proj.w]=make_ortho_set(uRange{kk});
        %
        
        
        prj1=[-DK,+DK];
        prj2=[-DK,+DK];
        disp('------------------------------------------------------------');
        fprintf('-----------node :h: = %f :k: %f :l: %f :: ------\n',d1(hkl),d2(hkl),d3(hkl));        
        fprintf('-----------proj u   = %f ::: %f ::: %f :: ------\n',proj.u);
        disp('------------------------------------------------------------');
        
        prj0 = Kr;
        proj.uoffset = [d1(hkl),d2(hkl),d3(hkl),0];
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
