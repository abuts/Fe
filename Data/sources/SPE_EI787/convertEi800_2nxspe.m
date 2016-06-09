% =====================================================================================================================
% =====================================================================================================================
indir   =pwd;                           % source directory of spe files
outdir  =pwd;                            % source directory of tmp files
par_file=fullfile(indir,'4to1_065.par'); % detector parameter file
data_dir = fullfile(indir,'SPE_EI800');

efix=787;
psi=[0:-0.5:-23,-23.5:-0.5:-27,-27.5:-0.5:-33.5,-34:-0.5:-92.5];
runno=[11014:11060,11063:11201];
misrun = 11187;

missing = runno==misrun;
psi = psi(~missing);
runno = runno(~missing);

nfiles=numel(psi);
spe_file=cell(1,nfiles);

rd = loader_ascii();
rd.par_file_name = par_file;

parfor i=1:nfiles
    spe_file=fullfile(data_dir,['MAP',num2str(runno(i)),'_4to1_065_ei787.spe']);
    nxspe_file=fullfile(data_dir,['MAP',num2str(runno(i)),'_4to1_065_ei787.nxspe']);
    if ~exist(nxspe_file,'file')
        fprintf(' Processing file: %s  #%d/%d\n',spe_file,i,nfiles);
        rd = loader_ascii(spe_file,par_file);
        %rd.file_name = spe_file;
        rd.saveNXSPE(nxspe_file,efix,psi(i));
    end
end

