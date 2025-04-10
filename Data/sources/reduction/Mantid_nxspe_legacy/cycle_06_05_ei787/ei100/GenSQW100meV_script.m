function hor100meV_script
%==================================================================================================
% Script to create sqw file
%==================================================================================================
% Give locations of input files
indir=pwd;     % source directory of spe files
par_file=parse_path([indir '/../../map_4to1_jul09.par']);     % detector parameter file
sqw_file=fullfile(indir,'fe_E100_8K.sqw');        % output sqw file
data_source =sqw_file;

% Set incident energy, lattice parameters etc.
efix=86.6072;
emode=1;
alatt=[2.87,2.87,2.87];
angdeg=[90,90,90];
u=[1,0,0];
v=[0,1,0];
omega=0;dpsi=0;gl=0;gs=0;

% Create the list of file names and orientation angles% 
% Time channel boundaries are not good for these two
% % G1
% [spe_file,psi]=build_fnames(indir,11014:11060,0,-0.5,-23);
% % G2
% [spe_file,psi]=build_fnames(indir,11063:11070,-23.5,-0.5,-27,spe_file,psi);
% G3
[spe_file,psi]=build_fnames(indir,11071:11083,-27.5,-0.5,-33.5);
% G4
[spe_file,psi]=build_fnames(indir,11084:11201,-34,-0.5,-92.5,spe_file,psi);


% Create sqw file
gen_sqw (spe_file, par_file, sqw_file, efix, emode, alatt, angdeg,...
         u, v, psi, omega, dpsi, gl, gs);

