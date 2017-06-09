data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');

bragg = [1,1,0];
BraggName = parWithCorrections.getTextFromVector(bragg);

peP1 = parWithCorrections([-0.325,-0.075,0,0.125,0.425;
    137,15,0,15,155]);
peP1.cut_direction=[1,1,1];
peP1.dE =5;
peP1.dk =0.05;

peP2 = parWithCorrections([-0.3125,-0.0875,0,0.1375,0.3875;
    131,15,0,15,153]);
peP2.cut_direction=[1,1,-1];
peP2.dE =5;
peP2.dk =0.05;

peP3 = parWithCorrections([-0.3375,-0.1125,0,0.1375,0.4125;
    131,15,0,13,151]);
peP3.cut_direction=[1,-1,-1];
peP3.dE =5;
peP3.dk =0.05;

peP4 = parWithCorrections([-0.3635,-0.1375,0,0.1125,0.3375;
    151,15,0,11,131]);
peP4.cut_direction=[1,-1,1];
peP4.dE =5;
peP4.dk =0.05;



repP={peP1,peP2,peP3,peP4};

do_fits(data_source,bragg,'<1,1,1>',repP)
