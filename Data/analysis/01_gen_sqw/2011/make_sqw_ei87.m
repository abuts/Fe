function make_sqw_ei87
% Create sqw file for the Ei=87meV Horace angle scan

par_dir=pwd;
spe_dir=[pwd,'/EI800']; 
sqw_dir=[pwd,'/EI800']; 

spename='MAP*_4to1_065_ei87.spe';    % template for spe file names
sqwname='Fe_ei87.sqw';
parname='4to1_065.par';

% Create the spe file names and psi array
spefile_template=fullfile(spe_dir,spename);
[spe_file,psi]=build_spefilenames(spefile_template, 11071:11083,-27.5, -0.5, -33.5);
[spe_file,psi]=build_spefilenames(spefile_template, 11084:11201,  -34, -0.5, -92.5, spe_file, psi);

% Give locations of input files
sqw_file=fullfile(sqw_dir,sqwname);        % output sqw file
par_file=fullfile(par_dir,parname);        % input par file

% Set incident energy, lattice parameters etc.
efix=86.7;
emode=1;
alatt=[2.87,2.87,2.87];
angdeg=[90,90,90];
u=[1,0,0];
v=[0,1,0];
omega=0;dpsi=0;gl=0;gs=0;

% Create sqw file
gen_sqw (spe_file, par_file, sqw_file, efix, emode, alatt, angdeg,...
         u, v, psi, omega, dpsi, gl, gs);
