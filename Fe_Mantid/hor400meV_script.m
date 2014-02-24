function hor400meV_script
%This is a Matlab script file to demonstrate some of the basic features of
%Horace. For a description of what each function is doing, and pictures of
%what the various plots should look like, visit
%http://horace.isis.rl.ac.uk/Getting_started

%In order to run this demo you may need to change some of the directory and
%file names in order to match up to your own operating system and file
%structure. It has been assumed that Horace has been installed and your
%initialised in your startup.m so that it is ready to run

%==================================================================================================
% Give folder where you want to want to install the demo
% *** This folder MUST already exist
%==================================================================================================
%demo_dir='c:\temp\horace_demo';
demo_dir=pwd;
%demo_dir=fileparts(which('demo_script'));

%==================================================================================================
% Unzip the data contained in the demo folder, and copy demo
%==================================================================================================
%==================================================================================================
% Script to create sqw file
%==================================================================================================
% Give locations of input files
indir=pwd;     % source directory of spe files
par_file=parse_path([indir '/map_4to1_jul09.par']);     % detector parameter file
sqw_file=fullfile(indir,'fe_E400_8K.sqw');        % output sqw file


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
[spe_file,psi]=build_fnames(indir,15052:15097,0,2,90);
% G2
[spe_file,psi]=build_fnames(indir,15098:15142,1,2,89,spe_file,psi);
% G3
[spe_file,psi]=build_fnames(indir,15143:15165,-2,-2,-46,spe_file,psi);
% G4
[spe_file,psi]=build_fnames(indir,15166:15178,-1,-2,-25,spe_file,psi);


% Create sqw file
gen_sqw (spe_file, par_file, sqw_file, efix, emode, alatt, angdeg,...
         u, v, psi, omega, dpsi, gl, gs);

% % ---------------------------------------     
% % If the intermediate files (extensions .tmp) are all created, but the sqw
% % file is not created (will sometimes happen if you have many spe files):
% 
% % tmp_file=cell(1,nfiles);    % create list of tmp file names
% % for i=1:length(psi)
% %     tmp_file{i}=[indir,'MAP',num2str(11012+(2*i)),'.tmp'];
% % end
% % write_nsqw_to_sqw(tmp_file,sqw_file);
% % ---------------------------------------     
% 
% 
