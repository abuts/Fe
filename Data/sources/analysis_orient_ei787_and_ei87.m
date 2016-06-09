%%=============================================================================
%       Realign the crystal: Ei=787 meV and Ei=87 meV runs
% =============================================================================

data_dir = [pwd,'/sqw/'];
data_source =[pwd, '/sqw/Fe_ei787.sqw'];
data_source2 = [pwd, '/sqw/Fe_ei87.sqw'];


proj.u=[1,0,0];
proj.v=[0,1,0];



% Check crystal orientation
% -----------------------------------------------------------------
% Plane in horizontal: 
w2el=cut_sqw(data_source,proj,0.05,0.05,[-0.1,0.1],[-50,50],'-nopix');
plot(w2el)

% Looks as if we have Bragg peaks...


% Get first estimate of correct alignment
% ---------------------------------------
% Get true Bragg peak positions for two or three in-plane Bragg peaks
% Use peaks at large twotheta, so get sensitivity to out-of-plane alignment
rlu=[-6,4,0; 0,6,0];

% Get positions of Bragg peaks:
radial_cut_length=0.1; radial_bin_width=0.002; radial_thickness=0.05;
trans_cut_length=8; trans_bin_width=0.25; trans_thickness=3;
energy_window=100;
opt='gaussian';
[rlu0,width,wcut,wpeak]=bragg_positions(data_source, rlu,...
    radial_cut_length, radial_bin_width, radial_thickness,...
    trans_cut_length, trans_bin_width, trans_thickness, energy_window, opt);
% View the results of the peak search           
bragg_positions_view(wcut,wpeak)

% Get first estimate of correct alignment
% Choose to fix lattice angles, and retain all lattice parameters as equal,
% but allow the value of a to vary.
h=head_horace(data_source);     % Get header information
alatt0=h.alatt;
angdeg0=h.angdeg;
[rlu_corr,alatt,angdeg,rotmat,dist,rotangle] =...
    refine_crystal(rlu0,alatt0,angdeg0,rlu,'fix_alatt_ratio','fix_angdeg');

% Get z=2.844 Ang c.f. 2.87 as the input value; this is consistent with
% looking at the radial scans through the Bragg peaks with
% bragg_positions_view above. Also, the misorientation angle is 0.32 deg


% Now do a bunch of Bragg peaks to get alignment
% ----------------------------------------------
% Do this to see if the realignment is consistent across all Bragg peaks
% We find that it is: a is systematically too large for all the Bragg peaks
rlu=[-4,2,0; -4,6,0; -6,4,0; 0,6,0; 0,8,0; 2,8,0];
    
radial_cut_length=0.1; radial_bin_width=0.002; radial_thickness=0.05;
trans_cut_length=10; trans_bin_width=0.25; trans_thickness=3;
energy_window=100;

opt='gaussian';
[rlu0,width,wcut,wpeak]=bragg_positions(data_source, rlu,...
    radial_cut_length, radial_bin_width, radial_thickness,...
    trans_cut_length, trans_bin_width, trans_thickness, energy_window, opt);
bragg_positions_view(wcut,wpeak)


% Get realignment
h=head_horace(data_source);     % Get header information
alatt0=h.alatt;
angdeg0=h.angdeg;
[rlu_corr,alatt,angdeg,rotmat,dist,rotangle] =...
    refine_crystal(rlu0,alatt0,angdeg0,rlu,'fix_alatt_ratio','fix_ang');

% Get a=2.848 ANg, and rotangle=0.37 deg

% Now apply to the data source for Ei=787
change_crystal_horace(data_source,rlu_corr)

% Can go back and check the realignment by repeating the Bragg peak search
% on the newly adjusted sqw file.
%
% *** NB: CAN ALWAYS RECOVER FROM THE CHANGE : use inverse of rlu_corr:
%  change_crystal_horace(data_source,inv(rlu_corr))

% Apply the same change to the Ei=87 meV dataset: it comes from the same
% spe files, but there are not enough Bragg peaks in te sqw file to enable
% the orientation to be corrected.

change_crystal_horace(data_source2,rlu_corr)
