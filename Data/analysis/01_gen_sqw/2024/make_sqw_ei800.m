function make_sqw_ei800
% Create sqw file for the Ei=196meV Horace angle scan
root_dir = fileparts(fileparts(fileparts(fileparts(mfilename("fullpath")))));

spe_dir=fullfile(root_dir,'sources','reduction','Mantid_nxspe_2024','cycle06_05','ei800') ; 
sqw_dir=fullfile(root_dir,'sqw','sqw2024'); 

spename='MAP*_ei787meV.nxspe';    % template for spe file names
sqwname='Fe_ei800_align_hr.sqw';
%parname='4to1_065.par';

% Create the spe file names and psi array
spefile_template=fullfile(spe_dir,spename);
[spe_file,psi]=build_spefilenames(spefile_template, 11014:11060,  0.0, -0.5, -23.0);
[spe_file,psi]=build_spefilenames(spefile_template, 11063:11070,-23.5, -0.5, -27.0, spe_file, psi);
[spe_file,psi]=build_spefilenames(spefile_template, 11071:11083,-27.5, -0.5, -33.5, spe_file, psi);
[spe_file,psi]=build_spefilenames(spefile_template, 11084:11201,-34.0, -0.5, -92.5, spe_file, psi);

% Give locations of input files
sqw_file=fullfile(sqw_dir,sqwname);        % output sqw file


% Set incident energy, lattice parameters etc.
efix=787;
emode=1;
%alatt=[2.87,2.87,2.87];
alatt = [2.844,2.844,2.844]; % from separate measurements and average values over all measurements
angdeg=[90,90,90];
u=[1,0,0];
v=[0,1,0];
%omega=0;dpsi=0;gl=0;gs=0;
%omega=0;dpsi=-0.1210;gl=0.1931;gs=0.3658; % alignment parameters from optimal lattice search
omega=0;dpsi= 0.0673;gl=0.0820;gs=0.3740;  % alignment parameters with lattice defined
gen_sqw (spe_file,'',sqw_file, efix, emode, alatt, angdeg,...
         u, v, psi, omega, dpsi, gl, gs,[100,100,100,100]);
