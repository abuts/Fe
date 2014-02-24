function All110_100a

%BZ=[ 2,0,0];
%BZ=[ -2,0,0; 2,0,0; 0,-2,0];
%BZ=[ 0,2,0; 0,0,-2; 0,0,2; 0,0,0];
%BZ=[ -1,-1,0; -1,1,0; -1,0,-1; -1,0,1];
BZ=[0,-1,-1; 0,-1,1;  0,1,-1; 0,1,1];
%BZ=[1,-1,0; 1,1,0;    1,0,-1; 1,0,1];

d1 = BZ(:,1);
d2 = BZ(:,2);
d3 = BZ(:,3);


% Ei=400
DK = 0.1;
Kr = [-2,0.5*DK,2];
DE = [-8,4,300];
data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei401.sqw';
% % Ei=800
% DK = 0.1;
% Kr = [-2,DK,3];
% DE = [-16,8,400];
%data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei787.sqw';
% % Ei=1371
% DK = 0.15;
% Kr = [-1,DK,1];
% DE = [-16,15,400];
% data_source='d:\Data\Fe\Feb2013\sqw\Fe_ei1371_base.sqw';


proj.u = [1,0,0];
proj.v = [0,1,0];
proj.type = 'ppp';
%proj.type = 'rrr';
proj.uoffset = [0,0,0,0];




ic=0;

uRange = {[1,0,0],[-1,0,0],[0,1,0],[0,-1,0],[0,0,1],[0,0,-1]};
rez = cell(numel(uRange)*numel(uRange)/2,1);
for hkl=1:numel(d1)
    for kk=1:numel(uRange)
        u0=uRange{kk};
        for ii=kk+1:numel(uRange)
            u1=uRange{ii}; 
            if(isequal(u0,-u1))
                continue;
            end
                     
            uc=(u0+u1)/2;
            [proj.u,proj.v,proj.w]=make_ortho_set(u1-uc);  
        
        
            prj1=[-DK,+DK];
            prj2=[-DK,+DK];
        
            prj0 = Kr;
            proj.uoffset = [d1(hkl)+uc(1),d2(hkl)+uc(2),d3(hkl)+uc(3),0];
            
            disp('------------------------------------------------------------');
            fprintf('-----------node :h: = %f :k: %f :l: %f :: ------\n',d1(hkl),d2(hkl),d3(hkl));        
            fprintf('-----------proj u   = %f ::: %f ::: %f :: ------\n',proj.u);
            fprintf('-----------uoffset  = %f ::: %f ::: %f :: ------\n',proj.uoffset(1:3));                    
            disp('------------------------------------------------------------');
            
            ic = ic+1;
            rez{ic} = cut_sqw(data_source,proj,prj0,prj1,prj2,DE,'-nopix');    
            
        end               
        
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


