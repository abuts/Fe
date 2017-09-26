function fitpar_array =get_all_fitpar(fitpar,dir)

all_keys = fitpar.bind_map.keys;
dir_key = direction_id(dir);
use_keys = cellfun(@(key)(contains(key,dir_key)),all_keys);
all_keys = all_keys(use_keys);
en = cellfun(@get_en,all_keys);
en = sort(en);
if numel(dir)<3
    tmp = dir;
    dir = zeros(4,1);
    dir(1) = round(tmp/100);
    tmp = tmp-dir(1)*100;
    dir(2) = round(tmp/10);
    tmp = tmp-dir(2)*10;
    dir(3) = round(tmp);
end

n_contributed_cuts = 0;
for i=1:numel(all_keys)
    key = all_keys{i};
    n_contributed_cuts = n_contributed_cuts+numel(fitpar.bind_map(key));
end
n_fitpar = numel(fitpar.fp_arr1.p{1});
n_bg_par = numel(fitpar.fp_arr1.bp{1});
fitpar_array = zeros(n_fitpar+n_bg_par+2,n_contributed_cuts);

ic = 1;
fn = fitpar.file_list{1};
file_key = strrep(dir_key,'<','!');
file_key = strrep(file_key,'>','!');
for i=1:numel(en)
    
    cut_fname = ['EnCuts_',fn,'_dE',num2str(en(i)),'_dir_',file_key];
    disp(['** processing dir_cut: ',cut_fname]);
    cl = load(cut_fname);
    n_cuts = numel(cl.cut_list);
    
    key = [num2str(en(i)),dir_key];
    cuts_ids = fitpar.bind_map(key);
    if n_cuts ~= numel(cuts_ids)
        error('get_all_fitpar:runtime_error',...
            ' different cuts descriptors and cuts file');
    end
    
    cuts = cl.cut_list;
    p=cl.fp_arr1.p;
    bp=cl.fp_arr1.bp;
    for j=1:n_cuts
        fitpar_array(1,ic)=en(i);
        dir_vec = abs(cuts(j).data.u_to_rlu*dir);
        dir_id = find(dir_vec-1>-0.001);
        bragg = cuts(j).data.uoffset(1:3)';
        fitpar_array(2,ic) = cut_id.get_id(bragg(1),bragg(2),bragg(3),dir_id);
        fitpar_array(3:12,ic)=p{j};
        fitpar_array(13:14,ic)=bp{j};
        ic = ic + 1;
    end
end


function en= get_en(key)
all_comp=strsplit(key,'<');
en = str2double(all_comp{1});
