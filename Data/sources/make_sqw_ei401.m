function make_sqw_ei401
% Create sqw file for the Ei=401meV Horace angle scan

par_dir=pwd;
spe_dir=[pwd,'/EI400']; 
sqw_dir=[pwd,'/EI400']; 

spename='MAP*_4to1_095.spe';    % template for spe file names
sqwname='Fe_ei401.sqw';
parname='4to1_095.par';

% Create the spe file names and psi array
spefile_template=fullfile(spe_dir,spename);
[spe_file,psi]=build_spefilenames(spefile_template, 15052:15097, 0, 2, 90);
[spe_file,psi]=build_spefilenames(spefile_template, 15098:15142, 1, 2, 89, spe_file, psi);
[spe_file,psi]=build_spefilenames(spefile_template, 15143:15165,-2,-2,-46, spe_file, psi);
[spe_file,psi]=build_spefilenames(spefile_template, 15166:15178,-1,-2,-25, spe_file, psi);

% Give locations of input files
sqw_file=fullfile(sqw_dir,sqwname);        % output sqw file
par_file=fullfile(par_dir,parname);        % input par file

% Set incident energy, lattice parameters etc.
efix=401.1;
emode=1;
alatt=[2.87,2.87,2.87];
angdeg=[90,90,90];
u=[1,0,0];
v=[0,1,0];
omega=0;dpsi=0;gl=0;gs=0;

% Create sqw file
gen_sqw (spe_file, par_file, sqw_file, efix, emode, alatt, angdeg,...
         u, v, psi, omega, dpsi, gl, gs);
