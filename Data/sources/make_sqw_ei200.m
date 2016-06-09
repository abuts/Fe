function make_sqw_ei200
% Create sqw file for the Ei=200meV Horace angle scan

par_dir=pwd;
spe_dir=[pwd,'/EI200']; 
sqw_dir=[pwd,'/EI200']; 

spename='MAP*_4to1_102.spe';    % template for spe file names
sqwname='Fe_ei200.sqw';
parname='4to1_102.par';

% Create the spe file names and psi array (exclude runs contaminated by ice)
spefile_template=fullfile(spe_dir,spename);
[spe_file,psi]=build_spefilenames(spefile_template, 15835:15880, 0, 2, 90);
[spe_file,psi]=build_spefilenames(spefile_template, 15881:15925, 1, 2, 89, spe_file,psi);
[spe_file,psi]=build_spefilenames(spefile_template, 15926:15948,-2,-2,-46, spe_file,psi);

% Give locations of input files
sqw_file=fullfile(sqw_dir,sqwname);        % output sqw file
par_file=fullfile(par_dir,parname);        % input par file

% Set incident energy, lattice parameters etc.
efix=200;
emode=1;
alatt=[2.87,2.87,2.87];
angdeg=[90,90,90];
u=[1,0,0];
v=[0,1,0];
omega=0;dpsi=0;gl=0;gs=0;

% Create sqw file
gen_sqw (spe_file, par_file, sqw_file, efix, emode, alatt, angdeg,...
         u, v, psi, omega, dpsi, gl, gs);
