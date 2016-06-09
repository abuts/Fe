% Script file to Homer data for iron experiment
%



%% =========================================================================================================
% For the data from 2006 - this has a different spectra.dat mapping in the raw file
% for monochromatic vanadium, hence the larger number of argument calls to Iliad
%
% Note that the monochromatic vanadium run 11270 has time channels that are
% really only suitable for EI=800. However, the vanadium integral is not
% really affected much by this - have explicitly testsed by running Iliad
% on the monovan run uteself, and get an integral that is c. 400 mBarn/sr

% Location of output spe files
spe_dir='/home/tgp98/Toby/experiments/iron/spe/065';
delete(fullfile(spe_dir,'*.*'))

% Ei=400meV 600Hz single shot scan (for comparison with July 2006 data)
Iliad_065 (11012, 400, 11277, [], 11271, [-71, 2, 381], 11276, [])
movefile(fullfile(spe_dir,'MAP11012_4to1_065.spe'),fullfile(spe_dir,'MAP11012_4to1_065_ei400.spe'))

% Horace scans:
% Nov. 2006: Ei approx. 800 meV (read correct Ei from the output of Homer to the screen)
for runno=11142:11201
    Iliad_065 (runno, 800 , 11277, [], 11270, [-102, 4, 752], 11276, [])
    movefile(fullfile(spe_dir,['MAP',num2str(runno),'_4to1_065.spe']),fullfile(spe_dir,['MAP',num2str(runno),'_4to1_065_ei787.spe']))
end
delete(fullfile(spe_dir,'MAP11270.sum'))      % MUST DELETE SUM FILE SO IT IS RECALCULATED FOR EI=196

% Nov. 2006: Ei approx. 200 meV second chopper peak
for runno=11071:11201
    Iliad_065 (runno, 195 , 11277, [], 11270, [-10.5,1,180.5], 11276, [])
    movefile(fullfile(spe_dir,['MAP',num2str(runno),'_4to1_065.spe']),fullfile(spe_dir,['MAP',num2str(runno),'_4to1_065_ei196.spe']))
end
delete(fullfile(spe_dir,'MAP11270.sum'))      % MUST DELETE SUM FILE SO IT IS RECALCULATED FOR EI=87

% Nov. 2006: Ei approx. 90 meV third chopper peak
for runno=11071:11201
    Iliad_065 (runno, 90 , 11277, [], 11270, [-10.25,0.5,80.25], 11276, [])
    movefile(fullfile(spe_dir,['MAP',num2str(runno),'_4to1_065.spe']),fullfile(spe_dir,['MAP',num2str(runno),'_4to1_065_ei87.spe']))
end
delete(fullfile(spe_dir,'MAP11270.sum'))



%% =========================================================================================================
% For all other runs the monochromatic vanadium runs have the same number of spectra
% as the sample runs, so the shorter argument list is needed

% March 2010: Ei approx. 400 meV (read correct Ei from the output of Homer to the screen)
for runno=15052:15178
    Iliad_095 (runno, 400 , 15182, [], 15181, [-71, 2, 381])
end

% July 2010: Ei approx. 1400 meV (read correct Ei from the output of Homer to the screen)
for runno=15796:15834
%for runno=15618:15834
    Iliad_102 (runno, 1400 , 16154, [], 16153, [-202.5, 5, 1352.5])
end

% July 2010: Ei approx. 200 meV (read correct Ei from the output of Homer to the screen)
for runno=15835:15965
    Iliad_102 (runno, 200 , 15527, [], 15532, [-30.5, 1, 190.5])
end

