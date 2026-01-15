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
A1 = 110;  B1 = 60;
A2 = 10;   B2 = 11;
A3 =  5;   B3 =  3;
A4 =  2;   B4 =  1;
A5 =  1;   B5 = 0.5;

%A1=112.2268; A2=-12.3937; A3=29.2775;A4=331.6717 ;A5=73.9542;
%B1=60.8932; B2=-11.5321;  B3=-10.8261; B4=-6.5851;B5=60.4841;
A1 = 16.88;    B1 = 15;
A2 = 14.63;    B2 = 0.55;
A3 =  0.92;    B3 = -0.57;
A4 = -0.12;    B4 = 0.03;
A5 = -0.29;    B5 = 0.32;
    
AmG = [286.7756 5.5016 9.4858];
%A = [3.7036e+03 141.3027 302.8061 -3.5211e+03   -120.0];
%A = 0.25*[3.7036e+03 141.3027 302.8061 -3.5211e+03   -120.0];
%B = 2.50e+2*[4.6777   -0.1244   -0.1522   -8.5274    0.129];

A = 4*[A1 A2 A3 A4 A5];
B = 4*[B1 B2 B3 B4 B5];

%% ------------------ High-symmetry path -----------------------
% BCC reciprocal lattice (2pi/a units)
G = [0 0 0];
H = [1 0 0];
N = [1/2 1/2 0];
P = [1/2 1/2 1/2];

path = {G,H,N,G,P,N};
labels = {'\Gamma','H','N','\Gamma','P','N'};
nq = 50;

[qpts, xticks] = make_kpath(path,nq);

%% ------------------ Phonon calculation ----------------------
nqtot = size(qpts,1);
% = zeros(nqtot,3);
omega = dynamical_bcc_5nn(qpts(:,1),qpts(:,2),qpts(:,2),[A,B]);

%for iq = 1:nqtot
    %q = qpts(iq,:);
    %D = dynamical_bcc_5nn(q(1),q(2),q(3),M,A,B);
    %w2 = eig(D);
    %omega(iq,:) = sqrt(abs(w2));
%end

%% ------------------ Plot ------------------------------------
fh = figure; hold on; box on;
theme(fh,'light');
plot(omega','k','LineWidth',1.5)

set(gca,'XTick',xticks,'XTickLabel',labels)
ylabel('\omega (arb. units)')
title('BCC phonon dispersion – 5NN general force constants')
xlim([1 nqtot])
grid on




%% ============================================================
%                    FUNCTIONS
% ============================================================


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
