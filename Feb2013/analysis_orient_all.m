%%=========================================================================
%      Orient crystal for all runs
%==========================================================================
% This performs the realignment of the crystal in the sqw files for the Fe
% expeiments. It does not do the realignment for the ei=196 run that came
% for 'free' with the EI=787 run, because we have a better Ei=200 run taken
% later on.

data_dir = '/home/tgp98/Toby/experiments/iron/sqw/';

proj.u=[1,0,0];
proj.v=[0,1,0];

radial_cut_length=0.1; radial_bin_width=0.002; radial_thickness=0.05;
trans_cut_length=10; trans_bin_width=0.25; trans_thickness=3;

opt='gaussian';


%% Ei=787 and 87 meV
%  -----------------
data_source=fullfile(data_dir,'Fe_ei787.sqw');
rlu=[-4,2,0; -4,6,0; -6,4,0; 0,6,0; 0,8,0; 2,8,0];

energy_window=100;

[rlu0,width,wcut,wpeak]=bragg_positions(data_source, rlu,...
    radial_cut_length, radial_bin_width, radial_thickness,...
    trans_cut_length, trans_bin_width, trans_thickness, energy_window, opt);

h=head_horace(data_source);     % Get header information
alatt0=h.alatt;
angdeg0=h.angdeg;
[rlu_corr,alatt,angdeg,rotmat,dist,rotangle] =...
    refine_crystal(rlu0,alatt0,angdeg0,rlu,'fix_alatt_ratio','fix_ang');

change_crystal_horace(data_source,rlu_corr)

% Use same reorientation for Ei=87meV as data accumulated in same runs
data_source=fullfile(data_dir,'Fe_ei87.sqw');
change_crystal_horace(data_source,rlu_corr)


%% Ei=1371 meV
%  -----------------
data_source=fullfile(data_dir,'Fe_ei1371_all.sqw');
rlu=[-2,10,0; 1,11,0; 7,5,0; 8,4,0];

energy_window=200;

[rlu0,width,wcut,wpeak]=bragg_positions(data_source, rlu,...
    radial_cut_length, radial_bin_width, radial_thickness,...
    trans_cut_length, trans_bin_width, trans_thickness, energy_window, opt);

h=head_horace(data_source);     % Get header information
alatt0=h.alatt;
angdeg0=h.angdeg;
[rlu_corr,alatt,angdeg,rotmat,dist,rotangle] =...
    refine_crystal(rlu0,alatt0,angdeg0,rlu,'fix_alatt_ratio','fix_ang');

change_crystal_horace(data_source,rlu_corr)


%% Ei=200 meV
%  -----------------
data_source=fullfile(data_dir,'Fe_ei200.sqw');
rlu=[4,0,0; 0,4,0; 2,2,0; 3,3,0; 1,3,0; 3,1,0];

energy_window=30;

[rlu0,width,wcut,wpeak]=bragg_positions(data_source, rlu,...
    radial_cut_length, radial_bin_width, radial_thickness,...
    trans_cut_length, trans_bin_width, trans_thickness, energy_window, opt);

h=head_horace(data_source);     % Get header information
alatt0=h.alatt;
angdeg0=h.angdeg;
[rlu_corr,alatt,angdeg,rotmat,dist,rotangle] =...
    refine_crystal(rlu0,alatt0,angdeg0,rlu,'fix_alatt_ratio','fix_ang');

change_crystal_horace(data_source,rlu_corr)


%% Ei=401 meV
%  -----------------
data_source=fullfile(data_dir,'Fe_ei401.sqw');
rlu=[6,0,0; 0,6,0; 4,0,0; 0,4,0; 4,4,0; 4,2,0; 2,4,0];

energy_window=50;

[rlu0,width,wcut,wpeak]=bragg_positions(data_source, rlu,...
    radial_cut_length, radial_bin_width, radial_thickness,...
    trans_cut_length, trans_bin_width, trans_thickness, energy_window, opt);

h=head_horace(data_source);     % Get header information
alatt0=h.alatt;
angdeg0=h.angdeg;
[rlu_corr,alatt,angdeg,rotmat,dist,rotangle] =...
    refine_crystal(rlu0,alatt0,angdeg0,rlu,'fix_alatt_ratio','fix_ang');

change_crystal_horace(data_source,rlu_corr)
