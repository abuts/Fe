function out_sqw = read_jerome_cube(file_name,dataset_name,q_block_size)
%READ_JEROME_CUBE Read DFT data produced by Jerome Jacson and convert these
% data into sqw object sutiable for further analyzis
%
% Inputs:
% file_name file with hdf-5 data to read
% dataset_name -- name of dataset with chi" to read from the file; if not
%                 provided, assumed "chi_rsa/"
% q_block_size -- size of chi" array in q-direction.
if nargin == 1
    dataset_name = "/chi_rsa_im";
end
if nargin<3
    q_block_size = [50,50,50];
end
%
Ry2meV    = 13605.693; % convert from RyDberg energy units (in file) into meV
s_scale   = 1.6997e-3; % mBarn/meV convert Jerome's Chi" units (mu_B^2/Ryd) to mBarn/meV; provides mBarn/meV
alatt = [2.844,2.844,2.844];


plist = 'H5P_DEFAULT';
fid = H5F.open(file_name);
dset_id = H5D.open(fid,dataset_name);
file_space_id = H5D.get_space(dset_id);

clOb = onCleanup(@()close_hdf_data(dset_id,fid));
chi_data = -single(H5D.read(dset_id,'H5ML_DEFAULT','H5S_ALL',file_space_id,plist)*s_scale);
clear clOb

q = single(h5read(file_name,'/q')*(2*pi/alatt(1)));
dE_points = single(h5read(file_name,'/realw')*Ry2meV);
n_dE = numel(dE_points);
dE = min(dE_points(2:end)-dE_points(1:end-1));
dE_step = min(dE);
dEall = repmat(dE_points,size(q,2),1);
qall  = repelem(q,1,n_dE);

run_id = single(ones(1,numel(chi_data)));
det_id = single(repmat(1:q_block_size(1),1,prod(q_block_size(2:3))*n_dE));
[~,~,~,en_id] = ndgrid(1:q_block_size(1),1:q_block_size(2),1:q_block_size(3),1:n_dE);
pix = PixelDataMemory([ ...
    qall(1,:)',qall(2,:)',qall(3,:)',dEall(:), ...
    run_id(:),det_id(:),single(en_id(:)), ...
    chi_data(:),single(ones(numel(qall(1,:)),1))]');
% beta*h*w = E(meV)/k_b*T = E*1.451 T=8K
%scaler = (s_scale./(1-exp(-1.451*e_scale));

out_sqw = sqw();
out_sqw.experiment_info = build_fake_experiment(double(dE_points),alatt,[90,90,90],100);

ab = line_axes('nbins_all_dims',ones(1,4),'img_range',[0,0,0,0;1,1,1,max(dE_points)]);
proj = line_proj('alatt',alatt,'angdeg',90);
out_sqw.data = d0d(ab,proj,1,1,pix.num_pixels); % single cell object
out_sqw.pix = pix;
step = 1./q_block_size;
out_sqw  = cut(out_sqw,proj,[0,step(1) ,1],[0,step(2),1],[0,step(3),1],[0,dE_step,max(dE_points)]);

end

function close_hdf_data(dset_id,fid)
H5D.close(dset_id);
H5F.close(fid);
end

function expinfo= build_fake_experiment(en,alatt,angdeg,efix)
samp = IX_sample(alatt,angdeg);
expdata = struct( ...
    'filename', 'fake', ...
    'filepath', '/fake', ...
    'efix', efix, ...
    'emode', 1, ...
    'cu', [1,0,0], ...
    'cv', [0,1,0], ...
    'psi', 0, ...
    'omega', 0, ...
    'dpsi', 0, ...
    'gl', 0, ...
    'gs', 0, ...
    'en',double(en), ...
    'uoffset', [0 0 0], ...
    'run_id', 1);
% initialise detpar_struct with a value which will not crash its conversion to an
% IX_detector_bank
detpar_struct=IX_detector_array().get_detpar_representation(); % init with default
detpar_struct.filename='fake';
detpar_struct.filepath='/fake';
samples = samp; %out.experiment_info.samples.add(samp);
instruments = IX_null_inst(); %out.experiment_info.instruments.add(IX_null_inst());
detector_arrays = IX_detector_array(detpar_struct);
expdata = IX_experiment(expdata);
expinfo = Experiment(detector_arrays, instruments, samples, expdata);
end

