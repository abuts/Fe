%%=============================================================================
%       Build reference dataset on Ei=400 meV sqw object
% =============================================================================
% Get access to sqw file for the Ei=400meV Horace angular scan
root_dir = fileparts(fileparts(fileparts(mfilename("fullpath"))));
sqw_dir=fullfile(root_dir,'sqw','sqw2024');

data_src400 =fullfile(sqw_dir,'Fe_ei401_align.sqw');
if ~isa('src400','var') || ~isa(src400,'sqw')
    src400 = sqw(data_src400);
end

ref_file = 'w4_400meV_model.sqw';
ref_file = fullfile(sqw_dir,ref_file);
if ~isfile(ref_file)
    %Seff=par(1);SJ=par(2); gap=par(3);gamma=par(4);bkconst=par(5);
    mddws = sqw_eval(data_src400,@sqw_bcc_hfm_testfunc,[100,50,0.5,40,1], ...
        'outfile',ref_file);
else
    mddws = sqw(ref_file );
end

w1md400_dEbg = cut(mddws ,2.209*[0,2],2.209*[0,2],2.209*[0,2],[]);
%%{
w2md400_100fg = cut(mddws,0.1,0.1,2.209*[-0.1,0.1],[100-5,100+5]);
plot(w2md400_100fg);
lz 0. 0.002
keep_figure;


plot(w1md400_dEbg);
keep_figure;
%}

