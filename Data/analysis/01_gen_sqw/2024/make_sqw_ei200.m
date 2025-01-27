function make_sqw_ei200
% Create sqw file for the Ei=200meV Horace angle scan

root_dir = fileparts(fileparts(fileparts(fileparts(mfilename("fullpath")))));

spe_dir=fullfile(root_dir,'sources','reduction','Mantid_nxspe_2024','cycle10_02','ei200') ; 
sqw_dir=fullfile(root_dir,'sqw','sqw2024'); 

spename='MAP*_ei200meV.nxspe';    % template for spe file names
sqwname='Fe_ei200.sqw';
%parname='4to1_065.par';

% Create the spe file names and psi array (exclude runs contaminated by ice)
spefile_template=fullfile(spe_dir,spename);
[spe_file,psi]=build_spefilenames(spefile_template, 15835:15880, 0, 2, 90);
[spe_file,psi]=build_spefilenames(spefile_template, 15881:15925, 1, 2, 89, spe_file,psi);
[spe_file,psi]=build_spefilenames(spefile_template, 15926:15948,-2,-2,-46, spe_file,psi);

% Give locations of input files
sqw_file=fullfile(sqw_dir,sqwname);        % output sqw file
%par_file=fullfile(par_dir,parname);       % input par file

% Set incident energy, lattice parameters etc.
efix=200;
emode=1;
%alatt=[2.87,2.87,2.87];
alatt = [2.844,2.844,2.844]; % from separate measurements and average values over all measurements
angdeg=[90,90,90];
u=[1,0,0];
v=[0,1,0];
omega=0;dpsi=0;gl=0;gs=0;
%omega=0;dpsi=-0.1104;gl=-0.2324;gs=0.7476;  % alignment parameters from optimal lattice search
   

% Create sqw file
gen_sqw (spe_file,'',sqw_file, efix, emode, alatt, angdeg,...
         u, v, psi, omega, dpsi, gl, gs);
