%%=============================================================================
%       Realign the crystal: Ei=200 meV
% =============================================================================
% Get access to sqw file for the Ei=200meV Horace angular scan
root_dir = fileparts(fileparts(fileparts(fileparts(mfilename("fullpath")))));
sqw_dir=fullfile(root_dir,'sqw','sqw2024');

data_source =fullfile(sqw_dir,'Fe_ei200.sqw');

proj = line_proj([1,0,0],[0,1,0],'type','aaa');

% dealign crystal if aligned and set lattice to the average expected value
dealign_crystal_if_aligned(data_source);

% Check crystal orientation
% -----------------------------------------------------------------
% Plane in horizontal:
w2el=cut_sqw(data_source,proj,0.05,0.05,[-0.1,0.1],[-5,5],'-nopix');
plot(w2el);lz 0 15;grid on;keep_figure
w2tr=cut_sqw(data_source,proj,0.05,[-0.1,0.1],0.05,[-5,5],'-nopix');
plot(w2tr);lz 0 15;grid on;keep_figure


% Looks as if we have Bragg peaks...


% Get first estimate of correct alignment
% ---------------------------------------
% Get true Bragg peak positions for two or three in-plane Bragg peaks
% Use peaks at large twotheta, so get sensitivity to out-of-plane alignment
rlu=[4,0,0; 0,4,0; 2,2,0; 3,3,0; 1,3,0; 3,1,0];

% Get positions of Bragg peaks:
radial_cut_length=1; radial_bin_width=0.02; radial_thickness=0.1;
trans_cut_length =1.5; trans_bin_width=0.02; trans_thickness=0.1;
energy_window=10;
opt={'gaussian'};
[rlu0,width,wcut,wpeak]=bragg_positions(data_source, rlu,...
    radial_cut_length, radial_bin_width, radial_thickness,...
    trans_cut_length, trans_bin_width, trans_thickness, energy_window, opt{:});
% View the results of the peak search
bragg_positions_view(wcut,wpeak)

% Get first estimate of correct alignment
% Choose to fix lattice angles, and retain all lattice parameters as equal,
% but allow the value of a to vary.
h=read_dnd(data_source);     % Get header information
alatt0=h.alatt;
angdeg0=h.angdeg;
rlu_corr =...
    refine_crystal(rlu0,alatt0,angdeg0,rlu,'fix_alatt','fix_angdeg');

change_crystal(data_source,rlu_corr);

proj1 = line_proj([1,0,0],[0,1,0]);
w2el=cut_sqw(data_source,proj1,0.05,0.05,[-0.1,0.1],[-5,5],'-nopix');
plot(w2el)
lz 0 15
grid on
keep_figure
w2tr=cut_sqw(data_source,proj1,0.05,[-0.1,0.1],0.05,[-5,5],'-nopix');
plot(w2tr)
lz 0 15
grid on
keep_figure

[~, ~, dpsi_deg, gl_deg, gs_deg] = crystal_pars_correct(proj.u, proj.v, alatt0, angdeg0, 0, 0, 0, 0, rlu_corr);
