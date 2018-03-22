function fitpar_array =get_fitpar_vs_e(fitpar)

all_keys = fitpar.bind_map.keys;
en = cellfun(@get_en,all_keys);
en = unique(en);
dir_ids = [100,110,111];
fitpar_array  = zeros(11,numel(en));

for i=1:numel(en)
    for j=1:numel(dir_ids)
        key = sprintf('%d<%d>',en(i),dir_ids(j));
        if fitpar.bind_map.isKey(key)
            binds = fitpar.bind_map(key);
            
            fitpar_array(1,i) = en(i);
            fitpar_array(2:11,i) = fitpar.fp_arr1.p{binds{1}};
            break;
        end
    end
end


function en= get_en(key)
all_comp=strsplit(key,'<');
en = str2double(all_comp{1});
