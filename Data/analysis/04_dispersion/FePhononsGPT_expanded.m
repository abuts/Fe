%clear; clc;

%% =======================
%  Physical constants
%% =======================
a = 2.844e-10;                  % lattice parameter (m)
M = 55.845 * 1.66054e-27;       % Fe atomic mass (kg)

%% =======================
%  Force constants (SI)
%  (scaled to match experiment)
%% =======================
A = [ ...
    250;    % A1
    60;    % A2
    -10;    % A3
    1;    % A4
    4];   % A5   (N/m)

B = [ ...
    -30;    % B1
    -6;    % B2
    1;    % B3
    -0.2;  % B4
    -0.1]; % B5   (N/m)


A1 = 16.88;    B1 = 15;
A2 = 14.63;    B2 = 0.55;
A3 =  0.92;    B3 = -0.57;
A4 = -0.12;    B4 = 0.03;
A5 = -0.29;    B5 = 0.32;
A = 1*[A1 A2 A3 A4 A5];
B = 1*[B1 B2 B3 B4 B5];%
C2 = 0.69; %25;   % angular force constant (2NN) (N/m)
lambda_T = 0.52; %-12;   % magnetic transverse softening (N/m)
lambda_L = 0.007; % +6;   % magnetic longitudinal stiffening (N/m)
%C2 = 25;   % angular force constant (2NN) (N/m)
%lambda_T = -12;   % magnetic transverse softening (N/m)
%lambda_L = +6;   % magnetic longitudinal stiffening (N/m)

%% =======================
%  High-symmetry path Γ–P–N–H
%% =======================


G = [0 0 0];
H = [1 0 0];
N = [1/2 1/2 0];
P = [1/2 1/2 1/2];

path = {G,H,N,G,P,N};
labels = {'\Gamma','H','N','\Gamma','P','N'};
nq = 50;

[qpts, xticks] = make_kpath(path,nq);
path = [ ...
    linspace_path(G,P,40);
    linspace_path(P,N,40);
    linspace_path(N,H,40)];

%% =======================
%  Compute dispersion
%% =======================
freq = zeros(size(path,1),3);

for iq = 1:size(path,1)
    q = 2*pi/a * path(iq,:);
    D = dynmat_bcc(q,A,B,C2,lambda_T,lambda_L,a,M);
    w2 = sort(real(eig(D)));
    freq(iq,:) = sqrt(max(w2,0))/(2*pi*1e12); % THz
end

%% =======================
%  Plot
%% =======================
fh = figure; hold on; box on;
theme(fh,'light');
plot(freq,'k','LineWidth',1.4);
ylabel('Frequency (THz)');
labels = {'\Gamma','P','N','H'};
set(gca,'XTick',xticks,'XTickLabel',labels)
xlim([1 nqtot])
title('bcc \alpha-Fe phonon dispersion (BvK + angular + magnetic)');
grid on


function D = dynmat_bcc(q,A,B,C2,lambda_T,lambda_L,a,M)

D = zeros(3,3);

Rlist = bcc_neighbors(a);

for n = 1:length(Rlist)
    Rset = Rlist{n};
    for i = 1:size(Rset,1)
        R = Rset(i,:);
        Rhat = R/norm(R);
        phase = exp(1i*q.*R);

        % ---------- central ----------
        Phi = A(n)*(Rhat'*Rhat) ...
            + B(n)*(eye(3) - Rhat'*Rhat);

        % ---------- angular (2NN only) ----------
        if n == 2
            Q = (Rhat'*Rhat - eye(3)/3);
            Phi = Phi + C2*Q;
        end

        D = D + Phi.*(1 - phase);
    end
end

% ---------- magnetic renormalization (2NN) ----------
qhat = q/norm(q + 1e-12);
PL = qhat'*qhat;
PT = eye(3) - PL;

fmag = 1 - cos(q*(a*[1 1 0]'/2));
D = D + lambda_L*fmag*PL + lambda_T*fmag*PT;

% ---------- ASR ----------
D = (D + D')/(2*M);

end

function R = bcc_neighbors(a)

R = cell(5,1);

% 1NN
v = a/2 * [ ...
    1  1  1;
    1  1 -1;
    1 -1  1;
    -1  1  1;
    -1 -1  1;
    -1  1 -1;
    1 -1 -1;
    -1 -1 -1];
R{1} = v;

% 2NN
v = a * [ ...
    1 0 0;
    -1 0 0;
    0 1 0;
    0 -1 0;
    0 0 1;
    0 0 -1];
R{2} = v;

% 3NN
v = a * [ ...
    1 1 0;
    -1 1 0;
    1 -1 0;
    -1 -1 0;
    1 0 1;
    -1 0 1;
    1 0 -1;
    -1 0 -1;
    0 1 1;
    0 -1 1;
    0 1 -1;
    0 -1 -1];
R{3} = v;

% 4NN
v = a * [ ...
    2 0 0;
    -2 0 0;
    0 2 0;
    0 -2 0;
    0 0 2;
    0 0 -2];
R{4} = v;

% 5NN
v = a/2 * [ ...
    3 1 1;
    3 1 -1;
    3 -1 1;
    3 -1 -1;
    -3 1 1;
    -3 1 -1;
    -3 -1 1;
    -3 -1 -1];
R{5} = v;

end

function p = linspace_path(a,b,n)
p = [linspace(a(1),b(1),n)', ...
    linspace(a(2),b(2),n)', ...
    linspace(a(3),b(3),n)'];
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
