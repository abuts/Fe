

% Toby's sniffing about the data  (20 Sep 2013)
% -------------------------------------------------

E0=35:10:125;
dE=5;
clear w1 fw1 par
for i=1:numel(E0)
    [w1(i),fw1(i),par(i)]=toby_twogauss(E0(i),dE);
end

a1=zeros(1,numel(E0));
da1=zeros(1,numel(E0));
a2=zeros(1,numel(E0));
da2=zeros(1,numel(E0));
for i=1:numel(E0)
    a1(i)=par(i).p(1);
    da1(i)=par(i).sig(1);
    a2(i)=par(i).p(4);
    da2(i)=par(i).sig(4);
end
wa1=IX_dataset_1d(E0,a1,da1,'Area','Energy (meV)','Peak area (arb. units');
wa2=IX_dataset_1d(E0,a2,da2,'Area','Energy (meV)','Peak area (arb. units');

