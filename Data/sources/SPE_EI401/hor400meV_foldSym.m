function hor400meV_foldSym
%==================================================================================================
% Script to create sqw file and do 3-D folding
%==================================================================================================
% Give locations of input files
indir=pwd;     % source directory of spe files
par_file=''; %parse_path([indir '/../map_4to1_jul09.par']);     % detector parameter file
sqw_file=fullfile(indir,'fe_E400_symallFold.sqw');        % output sqw file
data_source =fullfile(indir,'Data','sources','SPE_EI401');% 

% Set incident energy, lattice parameters etc.
efix=400;
emode=1;
alatt=[2.87,2.87,2.87];
angdeg=[90,90,90];
u=[1,0,0];
v=[0,1,0];
omega=0;dpsi=0;gl=0;gs=0;

% Create the list of file names and orientation angles
% G1
[spe_file,psi]=build_spefilenames([data_source,filesep,'MAP*_ei400meV.nxspe'],15052:15097,0,2,90);
%% G2
[spe_file,psi]=build_spefilenames([data_source,filesep,'MAP*_ei400meV.nxspe'],15098:15142,1,2,89,spe_file,psi);
%% G3
[spe_file,psi]=build_spefilenames([data_source,filesep,'MAP*_ei400meV.nxspe'],15143:15165,-2,-2,-46,spe_file,psi);
%% G4
[spe_file,psi]=build_spefilenames([data_source,filesep,'MAP*_ei400meV.nxspe'],15166:15178,-1,-2,-25,spe_file,psi);


% Create sqw file
%gen_sqw (spe_file, par_file, sqw_file, efix, emode, alatt, angdeg,...
%         u, v, psi, omega, dpsi, gl, gs);
gen_sqw (spe_file, par_file, sqw_file, efix, emode, alatt, angdeg,...
         u, v, psi, omega, dpsi, gl, gs,...
         'transform_sqw',@(x)(symmetrisation_fe(x)));


function win = symmetrisation_fe(win)

wout=symmetrise_sqw(win,[1,0,0],[0,0,1],[0,0,0]);
wout=symmetrise_sqw(wout,[0,1,0],[0,0,-1],[0,0,0]);
win=symmetrise_sqw(wout,[1,0,0],[0,-1,0],[0,0,0]);
         