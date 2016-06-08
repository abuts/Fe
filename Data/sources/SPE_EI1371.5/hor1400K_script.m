function hor1400K_script
%==================================================================================================
% Script to create sqw file
%==================================================================================================
% Give locations of input files
indir=pwd;     % source directory of spe files
par_file=parse_path([indir '/../map_4to1_jul09.par']);     % detector parameter file
sqw_file=fullfile(indir,'fe_E1400_8K.sqw');        % output sqw file
data_source =sqw_file;

% Set incident energy, lattice parameters etc.
efix=1371.5;
emode=1;
alatt=[2.87,2.87,2.87];
angdeg=[90,90,90];
u=[1,0,0];
v=[0,1,0];
omega=0;dpsi=0;gl=0;gs=0;

% Create the list of file names and orientation angles
% G1
[spe_file,psi]=build_fnames(indir,15654:15664,35,1,45);
% G2
[spe_file,psi]=build_fnames(indir,15665:15710,0,-1,-45,spe_file,psi);
% G3
[spe_file,psi]=build_fnames(indir,15711:15723,-44.5,1,-32.5,spe_file,psi);
% G4
[spe_file,psi]=build_fnames(indir,15733:15739,-22.5,1,-16.5,spe_file,psi);
% G5
[spe_file,psi]=build_fnames(indir,15740:15800,-15.5,1,44.5,spe_file,psi);
% G6
[spe_file,psi]=build_fnames(indir,15801:15815,-31.5,1,-17.5,spe_file,psi);
% G7
[spe_file,psi]=build_fnames(indir,15816:15834,0,1,18,spe_file,psi);


% Create sqw file
gen_sqw (spe_file, par_file, sqw_file, efix, emode, alatt, angdeg,...
         u, v, psi, omega, dpsi, gl, gs);

