data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

bragg = [1,-1,0];
dE =5;
dK =0.05;


pefP1 = [-0.33,-0.08,0,0.08,0.33;
    110,10,0,10,110];
pefP2 = [-0.3,-0.07,0,0.09,0.33;
    110,10,0,10,110];
pefP3 = [-0.28,-0.04,0,0.3,0.34;
    90,10,0,75,120];
pefP4 = [-0.28,-0.06,0,0.27,0.34;
    90,10,0,70,120];
    

rp1 = parWithCorrections(pefP1,bragg,[1,1,1],dE,dK);
rp2 = parWithCorrections(pefP2,bragg,[1,1,-1],dE,dK);
rp3 = parWithCorrections(pefP3,bragg,[1,-1,-1],dE,dK);
rp4 = parWithCorrections(pefP4,bragg,[1,-1,1],dE,dK);

repP={rp1,rp2,rp3,rp4};

do_fits(data_source,bragg,'<1,1,1>',repP)
