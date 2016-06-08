% Script file to Homer data for iron experiment
%
% =========================================================================================================
% For the data from 2006 - this has a differnet spectra.dat mappin in the raw file
% for monochromatic vanadium, hence the larger number of argument calls to Iliad

% Nov. 2006: Ei approx. 800 meV (correct Ei from the output of Homer goes to spe_hdf5 files)
for runno=11063:11201
    Iliad (runno, 800 , 11277, [], 11270, [-102, 4, 752], 11276, [])
end
%Nov. 2006: Ei approx. 800 meV second chopper peak at Ei~200 should calculate correct Ei from the guess and Homer output
%for runno=11071:11201
%    Iliad (runno, 195 , 11277, [], 11270, [-10,1,150], 11276, [])
%end
%Nov. 2006: Ei approx. 800 meV third chopper peak at Ei~100 should calculate correct Ei from the guess and Homer output
%for runno=11071:11201
%    Iliad (runno, 95 , 11277, [], 11270, [-10,0.5,80], 11276, [])
%end


%% =========================================================================================================
% For all other runs the monochromatic vanadium runs have the same number of spectra
% as the sample runs, so the shorter argument list is needed

% March 2010: Ei approx. 400 meV (correct Ei from the output of Homer goes to spe_hdf5 files)
%for runno=15052:15178
%    Iliad (runno, 400 , 15182, [], 15181, [-71, 2, 381])
%end

% July 2010: Ei approx. 1400 meV (correct Ei from the output of Homer goes to spe_hdf5 files)
%for runno=15618:15834
%    Iliad (runno, 1400 , 16154, [], 16153, [-202.5, 5, 1352.5])
%end

% % % July 2010: Ei approx. 200 meV (correct Ei from the output of Homer goes to spe_hdf5 files)
%for runno=15835:15965
%    Iliad (runno, 200 , 15527, [], 15532, [-30.5, 1, 190.5])
%end

