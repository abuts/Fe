function make_sqw_ei196ei200
% Create sqw file for the Ei=196meV and Ei200meV Horace angle scan
% needs to know alignment for run 1 and run 2 first.
root_dir = fileparts(fileparts(fileparts(fileparts(mfilename("fullpath")))));

spe_dir1=fullfile(root_dir,'sources','reduction','Mantid_nxspe_2024','cycle06_05','ei200') ; 
spe_dir2=fullfile(root_dir,'sources','reduction','Mantid_nxspe_2024','cycle10_02','ei200') ; 

sqw_dir=fullfile(root_dir,'sqw','sqw2024'); 

spename1='MAP*_ei195meV.nxspe';    % template for spe file names
spename2='MAP*_ei200meV.nxspe';    % template for spe file names
sqwname='Fe_ei200all.sqw';
%parname='4to1_065.par';

% Create the spe file names and psi array for runs in cycle 0605
spefile_template=fullfile(spe_dir1,spename1);
[spe_file,psi]=build_spefilenames(spefile_template, 11014:11060,  0.0, -0.5, -23.0);
[spe_file,psi]=build_spefilenames(spefile_template, 11063:11070,-23.5, -0.5, -27.0,spe_file, psi);
[spe_file,psi]=build_spefilenames(spefile_template, 11071:11083,-27.5, -0.5, -33.5, spe_file, psi);
[spe_file,psi]=build_spefilenames(spefile_template, 11084:11201,-34.0, -0.5, -92.5, spe_file, psi);
n_spe1 = numel(spe_file);

% Add the spe file names and psi array for runs in cycle 1002
spefile_template=fullfile(spe_dir2,spename2);
[spe_file,psi]=build_spefilenames(spefile_template, 15835:15880, 0, 2, 90,spe_file,psi);
[spe_file,psi]=build_spefilenames(spefile_template, 15881:15925, 1, 2, 89, spe_file,psi);
[spe_file,psi]=build_spefilenames(spefile_template, 15926:15948,-2,-2,-46, spe_file,psi);
n_spe2 = numel(spe_file)-n_spe1;


% Give locations of input files
sqw_file=fullfile(sqw_dir,sqwname);        % output sqw file


% Set incident energy, lattice parameters etc.
efix=[195*ones(n_spe1,1);200*ones(n_spe2,1)];
emode=1;
alatt=[2.87,2.87,2.87];
angdeg=[90,90,90];
u=[1,0,0];
v=[0,1,0];
omega=0;dpsi=0;gl=0;gs=0;

% Create sqw file
gen_sqw (spe_file,'',sqw_file, efix, emode, alatt, angdeg,...
         u, v, psi, omega, dpsi, gl, gs);
