function omega = dynamical_bcc_5nn(qh,qk,ql,AB)
% Full 3x3 dynamical matrix for BCC, 5NN GFC model

[D11,D12,D13,D22,D23,D33] = dynamical_bcc(qh,qk,ql,AB);
[D110,D120,D130,D220,D230,D330] = dynamical_bcc(0,0,0,AB);
D11 = D11-D110; D12 = D12-D120; D13= D13-D130;D22=D22-D220;D23 = D23-D230; D33 = D33-D330;
%% -------- Symmetrize ----------------------------------------
NP = numel(qh);
omega = zeros(3,NP);
for i=1:NP
    DM =[...
        D11(i),    0.5*D12(i) , 0.5*D13(i);...
        0.5*D12(i), D22(i)    , 0.5*D23(i);...
        0.5*D13(i), 0.5*D23(i), D33(i)];
    omega(:,i) = sqrt(abs(eig(DM)));
end

end

function [D11,D12,D13,D22,D23,D33] = dynamical_bcc(qh,qk,ql,AB)

A  = AB(1:5);
B  = AB(6:10);

cx=cos(qh*pi); cy=cos(qk*pi); cz=cos(ql*pi);
sx=sin(qh*pi); sy=sin(qk*pi); sz=sin(ql*pi);

NP = numel(qh);
D11=zeros(NP,1);
D22=zeros(NP,1);
D33=zeros(NP,1);
D12=zeros(NP,1);
D13=zeros(NP,1);
D23=zeros(NP,1);


%% -------- 1st neighbours (8) --------------------------------
D11=D11+(8/3)*(A(1)+2*B(1))*(1-cx.*cy.*cz);
D22=D22+(8/3)*(A(1)+2*B(1))*(1-cx.*cy.*cz);
D33=D33+(8/3)*(A(1)+2*B(1))*(1-cx.*cy.*cz);

D12=D12+(8/3)*(A(1)-B(1))*sx.*sy.*cz;
D13=D13+(8/3)*(A(1)-B(1))*sx.*sz.*cy;
D23=D23+(8/3)*(A(1)-B(1))*sy.*sz.*cx;

%% -------- 2nd neighbours (6) --------------------------------
D11=D11+4*( A(2)*(1-cx) + B(2)*(2-cy-cz) );
D22=D22+4*( A(2)*(1-cy) + B(2)*(2-cx-cz) );
D33=D33+4*( A(2)*(1-cz) + B(2)*(2-cx-cy) );

%% -------- 3rd neighbours (12) -------------------------------
D11=D11+4*( A(3)*(2-cx.*cy-cx.*cz) + B(3)*(4-cy.*cz-cx.*cy-cx.*cz) );
D22=D22+4*( A(3)*(2-cx.*cy-cy.*cz) + B(3)*(4-cx.*cz-cx.*cy-cy.*cz) );
D33=D33+4*( A(3)*(2-cx.*cz-cy.*cz) + B(3)*(4-cx.*cy-cx.*cz-cy.*cz) );

D12=D12+4*(A(3)-B(3))*sx.*sy;
D13=D13+4*(A(3)-B(3))*sx.*sz;
D23=D23+4*(A(3)-B(3))*sy.*sz;

%% -------- 4th neighbours (24) -------------------------------
D11=D11+(8/11)*(A(4)+5*B(4))*(1-cx.*cy.*cz);
D22=D22+(8/11)*(A(4)+5*B(4))*(1-cx.*cy.*cz);
D33=D33+(8/11)*(A(4)+5*B(4))*(1-cx.*cy.*cz);

D12=D12+(8/11)*(A(4)-B(4))*sx.*sy.*cz;
D13=D13+(8/11)*(A(4)-B(4))*sx.*sz.*cy;
D23=D23+(8/11)*(A(4)-B(4))*sy.*sz.*cx;

%% -------- 5th neighbours (6) --------------------------------
D11=D11+2*( A(5)*(1-cos(2*qh*pi)) + B(5)*(2-cos(2*qk*pi)-cos(2*ql*pi)) );
D22=D22+2*( A(5)*(1-cos(2*qk*pi)) + B(5)*(2-cos(2*qh*pi)-cos(2*ql*pi)) );
D33=D33+2*( A(5)*(1-cos(2*ql*pi)) + B(5)*(2-cos(2*qh*pi)-cos(2*qk*pi)) );
end