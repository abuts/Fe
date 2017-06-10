data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

bragg = [1,1,0];
dE = 5;
dK = 0.05;

peP1 = parWithCorrections([-0.325,-0.075,0,0.125,0.425;
    137,15,0,15,155],bragg,[1,1,1],dE,dK);

peP2 = parWithCorrections([-0.3125,-0.0875,0,0.1375,0.3875;
    131,15,0,15,153],bragg,[1,1,-1],dE,dK);

peP3 = parWithCorrections([-0.3375,-0.1125,0,0.1375,0.4125;
    131,15,0,13,151],bragg,[1,-1,-1],dE,dK);

peP4 = parWithCorrections([-0.3635,-0.1375,0,0.1125,0.3375;
    151,15,0,11,131],bragg,[1,-1,1],dE,dK);


repP={peP1,peP2,peP3,peP4};

do_fits(data_source,bragg,'<1,1,1>',repP)
