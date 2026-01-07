%% ============================================================
%  BCC 5NN General Force Constant Phonon Model
%  Ready-to-run MATLAB code
% =============================================================

%clear; clc; close all;

%% ------------------ Lattice & mass --------------------------
a  = 2.87;            % lattice constant (Å) – value irrelevant for shape
M  = 55.845;          % atomic mass (Fe) – arbitrary units OK

%% ------------------ Force constants --------------------------
% Units: arbitrary but consistent (e.g. N/m)
% Example values (replace with fitted / literature ones)
A1 = 30;   B1 = 15;
A2 = 10;   B2 =  5;
A3 =  5;   B3 =  3;
A4 =  2;   B4 =  1;
A5 =  1;   B5 = 0.5;

A = [A1 A2 A3 A4 A5];
B = [B1 B2 B3 B4 B5];

%% ------------------ High-symmetry path -----------------------
% BCC reciprocal lattice (2pi/a units)
G = [0 0 0];
H = [1 0 0];
N = [1/2 1/2 0];
P = [1/2 1/2 1/2];

path = {G,H,N,P,G};
labels = {'\Gamma','H','N','P','\Gamma'};
nq = 50;

[qpts, xticks] = make_kpath(path,nq);

%% ------------------ Phonon calculation ----------------------
nqtot = size(qpts,1);
omega = zeros(nqtot,3);

for iq = 1:nqtot
    q = qpts(iq,:);
    D = dynamical_bcc_5nn(q(1),q(2),q(3),M,A,B);
    w2 = eig(D);
    omega(iq,:) = sqrt(abs(w2));
end

%% ------------------ Plot ------------------------------------
figure; hold on; box on;
plot(omega,'k','LineWidth',1.5)

set(gca,'XTick',xticks,'XTickLabel',labels)
ylabel('\omega (arb. units)')
title('BCC phonon dispersion – 5NN general force constants')
xlim([1 nqtot])
grid on

%% ============================================================
%                    FUNCTIONS
% ============================================================

function D = dynamical_bcc_5nn(qh,qk,ql,M,A,B)
% Full 3x3 dynamical matrix for BCC, 5NN GFC model


cx=cos(qh*pi); cy=cos(qk*pi); cz=cos(ql*pi);
sx=sin(qh*pi); sy=sin(qk*pi); sz=sin(ql*pi);

D = zeros(3,3);

%% -------- 1st neighbours (8) --------------------------------
D(1,1)=D(1,1)+(8/(3*M))*(A(1)+2*B(1))*(1-cx.*cy.*cz);
D(2,2)=D(2,2)+(8/(3*M))*(A(1)+2*B(1))*(1-cx.*cy.*cz);
D(3,3)=D(3,3)+(8/(3*M))*(A(1)+2*B(1))*(1-cx.*cy.*cz);

D(1,2)=D(1,2)+(8/(3*M))*(A(1)-B(1))*sx.*sy.*cz;
D(1,3)=D(1,3)+(8/(3*M))*(A(1)-B(1))*sx.*sz.*cy;
D(2,3)=D(2,3)+(8/(3*M))*(A(1)-B(1))*sy.*sz.*cx;

%% -------- 2nd neighbours (6) --------------------------------
D(1,1)=D(1,1)+(4/M)*( A(2)*(1-cx) + B(2)*(2-cy-cz) );
D(2,2)=D(2,2)+(4/M)*( A(2)*(1-cy) + B(2)*(2-cx-cz) );
D(3,3)=D(3,3)+(4/M)*( A(2)*(1-cz) + B(2)*(2-cx-cy) );

%% -------- 3rd neighbours (12) -------------------------------
D(1,1)=D(1,1)+(4/M)*( A(3)*(2-cx.*cy-cx.*cz) + B(3)*(4-cy.*cz-cx.*cy-cx.*cz) );
D(2,2)=D(2,2)+(4/M)*( A(3)*(2-cx.*cy-cy.*cz) + B(3)*(4-cx.*cz-cx.*cy-cy.*cz) );
D(3,3)=D(3,3)+(4/M)*( A(3)*(2-cx.*cz-cy.*cz) + B(3)*(4-cx.*cy-cx.*cz-cy.*cz) );

D(1,2)=D(1,2)+(4/M)*(A(3)-B(3))*sx.*sy;
D(1,3)=D(1,3)+(4/M)*(A(3)-B(3))*sx.*sz;
D(2,3)=D(2,3)+(4/M)*(A(3)-B(3))*sy.*sz;

%% -------- 4th neighbours (24) -------------------------------
D(1,1)=D(1,1)+(8/(11*M))*(A(4)+5*B(4))*(1-cx.*cy.*cz);
D(2,2)=D(2,2)+(8/(11*M))*(A(4)+5*B(4))*(1-cx.*cy.*cz);
D(3,3)=D(3,3)+(8/(11*M))*(A(4)+5*B(4))*(1-cx.*cy.*cz);

D(1,2)=D(1,2)+(8/(11*M))*(A(4)-B(4))*sx.*sy.*cz;
D(1,3)=D(1,3)+(8/(11*M))*(A(4)-B(4))*sx.*sz.*cy;
D(2,3)=D(2,3)+(8/(11*M))*(A(4)-B(4))*sy.*sz.*cx;

%% -------- 5th neighbours (6) --------------------------------
D(1,1)=D(1,1)+(2/M)*( A(5)*(1-cos(2*qh*pi)) + B(5)*(2-cos(2*qk*pi)-cos(2*ql*pi)) );
D(2,2)=D(2,2)+(2/M)*( A(5)*(1-cos(2*qk*pi)) + B(5)*(2-cos(2*qh*pi)-cos(2*ql*pi)) );
D(3,3)=D(3,3)+(2/M)*( A(5)*(1-cos(2*ql*pi)) + B(5)*(2-cos(2*qh*pi)-cos(2*qk*pi)) );

%% -------- Symmetrize ----------------------------------------
D = (D + D.')/2;

end

function [kpath,xticks] = make_kpath(points,nq)
kpath=[];
xticks=1;
for i=1:length(points)-1
    for j=0:nq-1
        kpath=[kpath;
            points{i}+(points{i+1}-points{i})*(j/(nq-1))];
    end
    xticks=[xticks size(kpath,1)];
end
end
