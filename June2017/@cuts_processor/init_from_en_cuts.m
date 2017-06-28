function obj = init_from_en_cuts(obj,fit_summary_file)
%
ld = load(fit_summary_file);
obj.fitpar = ld.fp_arr1;
obj.source_file_ = fit_summary_file;
obj = obj.setup_j();
obj.bragg_list = ld.bragg_list;
obj.file_list = ld.file_list;
obj.cuts_list_ = [];
obj.fits_list = [];
bind_map = ld.bind_map;
keys = bind_map.keys;
en_list = cellfun(@(x)(str2double(x(1:end-5))),keys);
en_list = unique(sort(en_list));
if iscell(ld.fp_arr1.sig)
    sig = ld.fp_arr1.sig{1};
else
    sig = ld.fp_arr1.sig;
end
obj.fit_par_range = double(sig~=0);
obj.e_range = [min(en_list),max(en_list)];
dir_list = {'100','110','111'};
FileSourceID = [obj.file_list{:}];
ncuts = 0;
p = {};
bp ={};
sig={};
bsig={};
fp_arr1 = struct('p',[],'sig',[],'bp',[],'bsig',[],...
    'chisq',ld.fp_arr1.chisq,'converged',ld.fp_arr1.converged);
%
for i=1:numel(en_list)
    en = en_list(i);
    for j=1:numel(dir_list)
        fn = sprintf('EnCuts_%s_dE%d_dir_!%s!',FileSourceID,en,dir_list{j});
        if ~(exist([fn,'.mat'],'file')==2)
            continue;
        end
        fprintf('loading cuts file : %s #%d/%d',fn,3*(i-1)+j,3*numel(en_list));
        ld = load(fn);
        fprintf(' containing %d cuts\n',numel(ld.cut_list(:)));
        obj.cuts_list_ = [obj.cuts_list_(:);ld.cut_list(:)];
        obj.fits_list = [obj.fits_list(:);ld.w1D_arr1_tf(:)];
        cuts_block = numel(ld.cut_list);
        p = {p{:},ld.fp_arr1.p{:}};
        bp = {bp{:},ld.fp_arr1.bp{:}};
        sig = {sig{:},ld.fp_arr1.sig{:}};
        bsig = {bsig{:},ld.fp_arr1.bsig{:}};
        theKey = [num2str(en),'<',dir_list{j},'>'];
        cuts_ids = arrayfun(@(x)(x),ncuts+1:ncuts+cuts_block,'UniformOutput',false);
        obj.equal_cuts_map(theKey) = cuts_ids;
        ncuts = ncuts+cuts_block;
        
        
        %     stor.cut_list = obj.cuts_list(ind);
        %     stor.w1D_arr1_tf = obj.fits_list(ind);
        %     cuts_fitpar.p = obj.fitpar.p(ind);
        %     cuts_fitpar.sig =obj.fitpar.sig(ind);
        %     cuts_fitpar.bp  = obj.fitpar.bp(ind);
        %     cuts_fitpar.bsig =obj.fitpar.bsig(ind);
        %     stor.fp_arr1 = cuts_fitpar;
        
    end
end

if numel(p) == 1
    fp_arr1.p = p{1};
    fp_arr1.bp = bp{1};
    fp_arr1.sig = sig{1};
    fp_arr1.bsig = bsig{1};
else
    fp_arr1.p = p;
    fp_arr1.bp = bp;
    fp_arr1.sig = sig;
    fp_arr1.bsig = bsig;
end
obj.fitpar = fp_arr1;

