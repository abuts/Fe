% =====================================================================================================================
% Script to create sqw file
% =====================================================================================================================
indir   =pwd;                           % source directory of spe files
outdir  =pwd;                            % source directory of tmp files
par_file=fullfile(indir,'4to1_102.par'); % detector parameter file


efix=200;
psi=[0:2:90,1:2:89,-2:-2:-46];
nfiles=numel(psi);
spe_file=cell(1,nfiles);

rd = loader_ascii();
rd.par_file_name = par_file;

for i=11:nfiles
    spe_file=fullfile(indir,['MAP',num2str(15834+i),'_4to1_102.spe']);
    fprintf(' Processing file: %s  #%d/%d\n',spe_file,i,nfiles);
    nxspe_file=fullfile(outdir,['MAP',num2str(15834+i),'_4to1_102.nxspe']);
    rd.file_name = spe_file;
    rd.saveNXSPE(nxspe_file,efix,psi(i));
end

