%%=============================================================================
%       Realign the crystal: Ei=200 meV
% =============================================================================

data_dir = [pwd,'/sqw/'];
data_source =[pwd, '/sqw/Fe_ei200.sqw'];

proj.u=[1,0,0];
proj.v=[0,1,0];


% Check crystal orientation
% -----------------------------------------------------------------
% Plane in horizontal: 
w2el=cut_sqw(data_source,proj,0.05,0.05,[-0.1,0.1],[-15,15],'-nopix');
plot(w2el)

% Looks as if we have Bragg peaks...


% Get first estimate of correct alignment
% ---------------------------------------
% Get true Bragg peak positions for two or three in-plane Bragg peaks
% Use peaks at large twotheta, so get sensitivity to out-of-plane alignment
rlu=[4,0,0; 0,4,0];

% Get positions of Bragg peaks:
radial_cut_length=0.1; radial_bin_width=0.002; radial_thickness=0.05;
trans_cut_length=8; trans_bin_width=0.25; trans_thickness=3;
energy_window=30;
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

% Get z=2.846 Ang c.f. 2.87 as the input value; this is consistent with
% looking at the radial scans through the Bragg peaks with
% bragg_positions_view above. Also, the misorientation angle is 0.88 deg


% Now do a bunch of Bragg peaks to get alignment
% ----------------------------------------------
% Do this to see if the realignment is consistent across all Bragg peaks
% We find that it is: a is systematically too large for all the Bragg peaks
rlu=[4,0,0; 0,4,0; 2,2,0; 3,3,0; 1,3,0; 3,1,0];
    
radial_cut_length=0.1; radial_bin_width=0.002; radial_thickness=0.05;
trans_cut_length=10; trans_bin_width=0.25; trans_thickness=3;
energy_window=30;

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

% Get a=2.844 ANg, and rotangle=0.78 deg

% Now apply to the main data source
change_crystal_horace(data_source,rlu_corr)

% Can go back and check the realignment by repeating the Bragg peak search
% on the newly adjusted sqw file.
% *** NB: CAN ALWAYS RECOVER FROM THE CHANGE : use inverse of rlu_corr:
change_crystal_horace(data_source,inv(rlu_corr))


