function make_sqw_ei1400
% Create sqw file for the Ei=1371meV Horace angle scan
root_dir = fileparts(fileparts(fileparts(fileparts(mfilename("fullpath")))));

spe_dir=fullfile(root_dir,'sources','reduction','Mantid_nxspe_2024','cycle10_02','ei1400') ; 
sqw_dir=fullfile(root_dir,'sqw','sqw2024'); 

spename='MAP*_ei1372meV.nxspe';    % template for spe file names
sqwname='Fe_ei1400.sqw';
%parname='4to1_065.par';

% Create the spe file names and psi array

% base temperature only:
spefile_template=fullfile(spe_dir,spename);
[spe_file_base,psi_base]=build_spefilenames(spefile_template, 15654:15664,   35, 1, 45);
[spe_file_base,psi_base]=build_spefilenames(spefile_template, 15665:15710,    0,-1,-45  ,spe_file_base,psi_base);
[spe_file_base,psi_base]=build_spefilenames(spefile_template, 15711:15723,-44.5, 1,-32.5,spe_file_base,psi_base);
[spe_file_base,psi_base]=build_spefilenames(spefile_template, 15740:15800,-15.5, 1, 44.5,spe_file_base,psi_base);
[spe_file_base,psi_base]=build_spefilenames(spefile_template, 15801:15815,-31.5, 1,-17.5,spe_file_base,psi_base);
[spe_file_base,psi_base]=build_spefilenames(spefile_template, 15816:15834,    0, 1, 18  ,spe_file_base,psi_base);
% All (RT, cooling,warming,base)
[spe_file_all,psi_all]=build_spefilenames(spefile_template, 15618:15645,    0, 1, 27);
[spe_file_all,psi_all]=build_spefilenames(spefile_template, 15647:15664,   28, 1, 45  ,spe_file_all,psi_all);
[spe_file_all,psi_all]=build_spefilenames(spefile_template, 15665:15710,    0,-1,-45  ,spe_file_all,psi_all);
[spe_file_all,psi_all]=build_spefilenames(spefile_template, 15711:15800,-44.5, 1, 44.5,spe_file_all,psi_all);
[spe_file_all,psi_all]=build_spefilenames(spefile_template, 15801:15815,-31.5, 1,-17.5,spe_file_all,psi_all);
[spe_file_all,psi_all]=build_spefilenames(spefile_template, 15816:15834,    0, 1, 18  ,spe_file_all,psi_all);

% Give locations of input files
sqw_file_base=fullfile(sqw_dir,sqwname);        % output sqw file


% Set incident energy, lattice parameters etc.
efix=1372;
emode=1;
alatt=[2.87,2.87,2.87];
angdeg=[90,90,90];
u=[1,0,0];
v=[0,1,0];
omega=0;dpsi=0;gl=0;gs=0;

% Create sqw file
% Base temperature only
gen_sqw (spe_file_base, '', sqw_file_base, efix, emode, alatt, angdeg,...
         u, v, psi_base, omega, dpsi, gl, gs);
% All temperatures
%gen_sqw (spe_file_all, par_file, sqw_file_all, efix, emode, alatt, angdeg,...
%         u, v, psi_all, omega, dpsi, gl, gs);
