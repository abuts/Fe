function [x3,S3,ERR3]=test_error_calc(varargin)
% script to test various ways to calculate errors at rebinning
% data

X1 = 0;
X2=100;
dX = X2-X1;
nBins=10;
if nargin> 0
    npAvrg=varargin{1};
else
    npAvrg=100;
end

nPoints = npAvrg*(nBins+2);
ddX = dX/nBins;
dX = dX+2*ddX;

numbers = X1+rand(nPoints,1).*dX;



L1=ddX;
L2=100+ddX;
[x_coarse,dx_coarse,S1]=hist(numbers,L1,L2,nBins);
[x_fine,dx_fine,S2]=hist(numbers,L1,L2,nBins*10);

%figure;
%plot(x_coarse,S1'./dx_coarse,x_fine,S2'./dx_fine);
figure
errorbar(x_coarse,S1'./dx_coarse,sqrt(S1)'./dx_coarse);
hold on
errorbar(x_fine,S2'./dx_fine,sqrt(S2)'./dx_fine,'Color','g')


[S_avrg1,ERRsq_avrg1,dX1]=ansAv(S1,dx_coarse);
[S_avrg2,ERRsq_avrg2,dX2]=ansAv(S2,dx_fine);

fprintf('Avrg of %d bins is %f, error: %d, theor err: %d\n',nBins,S_avrg1/dX1,sqrt(ERRsq_avrg1)/dX1,sqrt(S_avrg1)/dX1);
fprintf('Avrg of %d bins is %f, error: %d, theor err: %d\n',10*nBins,S_avrg2/dX2,sqrt(ERRsq_avrg2)/dX2,sqrt(S_avrg2)/dX2);



ERR2 = ones(numel(S2),1).*(ERRsq_avrg2);
% rebinning fine grid to coarce grid
[x3,dx3,S3,ERR3]=hist2(x_fine,S2,ERR2,L1,L2,nBins);

errorbar(x3,S3'/dx_fine(1),ERR3'/dx_fine(1),'Color','r')






function [S_ans,ERR_ans,dX]=ansAv(S,dx)
% ansamble average,
dX = sum(dx)/numel(dx);
S_ans   = sum(S)/numel(S);
dS      = (S-S_ans).^2;
ERR_ans = sum(dS)/numel(dS);


function [x1,dx1,S]=hist(numbers,L1,L2,nBins)
% histogram, arithmetic binning and average of the signals
dL = (L2-L1)/nBins;
range1=L1:dL:L2;

ind1  = floor((numbers-L1)/dL)+1;
indMax = floor((L2-L1)/dL)+1;
valid = ind1>=1 & ind1<indMax;
%
ind1= ind1(valid);
numbers=numbers(valid);
nPoints = numel(numbers);
acc     = ones(nPoints,1);
S=accumarray(ind1,acc,[indMax-1,1]);

x1  = (range1(2:end)+range1(1:end-1)).*0.5;
dx1 = (range1(2:end)-range1(1:end-1));


function [x2,dx2,S,ERR]=hist2(xI,Si,ERRiSq,L1,L2,nBins)
% rebin existing signal and error arrays to larger bin
%
%
dL = (L2-L1)/nBins;
range1=L1:dL:L2;

ind1  = floor((xI-L1)/dL)+1;
indMax = floor((L2-L1)/dL)+1;
valid = ind1>=1 & ind1<indMax;
%
ind1= ind1(valid);
Si  = Si(valid);
ERRiSq= ERRiSq(valid);

nBins=accumarray(ind1',ones(numel(ind1),1));
S   =accumarray(ind1',Si,[indMax-1,1])./nBins;
ERRsq =accumarray(ind1',ERRiSq,[indMax-1,1]);
ERR = sqrt(ERRsq)./nBins;


x2  = (range1(2:end)+range1(1:end-1)).*0.5;
dx2 = (range1(2:end)-range1(1:end-1));



