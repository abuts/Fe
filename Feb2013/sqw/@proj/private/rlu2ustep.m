function u_to_rlu = rlu2ustep(this)


u_to_rlu = zeros(3,3);
ulen = zeros(1,3);
ustep_to_rlu = zeros(3,3);
if this.type(i)=='r'
% length of ui in Ang^-1  normalise so ui has max(abs(h,k,l))=1
% get step vector in r.l.u. 
    for i=1:3
       ulen(i) = 1/max(abs(ubinv(:,i)));           
    end
        u_to_rlu(:,i) = ubinv(:,i)*ulen(i);                
        ustep_to_rlu(:,i) = ustep(i)*u_to_rlu(:,i);         
elseif this.type(i)=='a'
% length of ui in Ang^-1    
    ulen = ones(1,3);
        ulen(i) = 1;                                        
        u_to_rlu(:,i) = ubinv(:,i)*ulen(i);                 % ui normalised to 1 Ang^-1 already, so just copy
        ustep_to_rlu(:,i) = ustep(i)*u_to_rlu(:,i);         % get step vector in r.l.u.
elseif this.type(i)=='p'
        ulen(i) = abs(uvw_orthonorm(i,i));                  % length of ui in Ang^-1; take abs in case w does not form rh set with u and v
        u_to_rlu(:,i) = ubinv(:,i)*ulen(i);                 % normalise so ui has max(abs(h,k,l))=1
        ustep_to_rlu(:,i) = ustep(i)*u_to_rlu(:,i);         % get step vector in r.l.u.
else % this.type(i) =='n'
        ulen(i) = norml(i);                  % 
        u_to_rlu(:,i) = ubinv(:,i)*ulen(i);                 % 
        ustep_to_rlu(:,i) = ustep(i)*u_to_rlu(:,i);         %        
end


for i=1:3
    if this.type(i)=='r'
        ulen(i) = 1/max(abs(ubinv(:,i)));                   % length of ui in Ang^-1
        u_to_rlu(:,i) = ubinv(:,i)*ulen(i);                 % normalise so ui has max(abs(h,k,l))=1
        ustep_to_rlu(:,i) = ustep(i)*u_to_rlu(:,i);         % get step vector in r.l.u.
    elseif this.type(i)=='a'
        ulen(i) = 1;                                        % length of ui in Ang^-1
        u_to_rlu(:,i) = ubinv(:,i)*ulen(i);                 % ui normalised to 1 Ang^-1 already, so just copy
        ustep_to_rlu(:,i) = ustep(i)*u_to_rlu(:,i);         % get step vector in r.l.u.
    elseif this.type(i)=='p'
        ulen(i) = abs(uvw_orthonorm(i,i));                  % length of ui in Ang^-1; take abs in case w does not form rh set with u and v
        u_to_rlu(:,i) = ubinv(:,i)*ulen(i);                 % normalise so ui has max(abs(h,k,l))=1
        ustep_to_rlu(:,i) = ustep(i)*u_to_rlu(:,i);         % get step vector in r.l.u.
    else %this.type(i) =='n'
        ulen(i) = norml(i);                  % 
        u_to_rlu(:,i) = ubinv(:,i)*ulen(i);                 % 
        ustep_to_rlu(:,i) = ustep(i)*u_to_rlu(:,i);         %        
    end
end
