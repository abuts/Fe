function hor200meV_script_test_reduced
%==================================================================================================
% Script to create sqw file
%==================================================================================================
% Give locations of input files
indir=pwd;     % source directory of spe files
par_file=parse_path([indir '/../map_4to1_jul09.par']);     % detector parameter file
sqw_file=fullfile(indir,'fe_E200_8K_reduced4.sqw');        % output sqw file
data_source =sqw_file;

% Set incident energy, lattice parameters etc.
efix=200;
emode=1;
alatt=[2.87,2.87,2.87];
angdeg=[90,90,90];
u=[1,0,0];
v=[0,1,0];
omega=0;dpsi=0;gl=0;gs=0;

% Create the list of file names and orientation angles
% G1
[spe_file,psi]=build_fnames(indir,15835:2:15880,0,4,86);
% G2
%[spe_file,psi]=build_fnames(indir,15881:2:15925,1,4,89,spe_file,psi);
% G3
%[spe_file,psi]=build_fnames(indir,15926:2:15948,-2,-4,-46,spe_file,psi);
% G4
%[spe_file,psi]=build_fnames(indir,15949:15965,-1,-2,-33,spe_file,psi);


% Create sqw file
gen_sqw (spe_file, par_file, sqw_file, efix, emode, alatt, angdeg,...
         u, v, psi, omega, dpsi, gl, gs);

