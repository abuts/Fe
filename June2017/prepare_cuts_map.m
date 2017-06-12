function cuts_areas = prepare_cuts_map(data_source,cuts)
% calculate or read range of cuts, defined by cuts map and
% return map of cuts arranged as function of the energy transfer
% Inputs:
% data_source -- name of the sqw file with data
% cuts        -- the map of the parWithCorrection classes as function of
%                bragg id
% Output:
% data_source  -- the map of cuts as function of cut's energy tansfer.
%
%

br_list = cuts.keys;


cuts_areas = containers.Map();
for i=1:numel(br_list)
    br_par = cuts(br_list{i});
    for j=1:numel(br_par)
        br_cut_par = br_par{j};
        [~,fname] = fileparts(data_source);
        rez_file = rez_name(fname,br_cut_par.bragg,br_cut_par.cut_direction,'SC_');
        
        if exist([rez_file,'.mat'],'file') == 2
            ld = load(rez_file);
            if ~isfield(ld,'fits')
                delete(rez_file)
                [cuts_1,fits,fg_par1,bg_par1,en_cuts] = make_and_fit_cuts(data_source,br_cut_par);
                save(rez_file,'en_cuts','cuts_1','fits','fg_par1','bg_par1');
            else
                cuts_1= ld.cuts_1;
                fits = ld.fits;
                fg_par1= ld.fg_par1;
                bg_par1 = ld.bg_par1;
                en_cuts = ld.en_cuts;
            end
            
        else
            [cuts_1,fits,fg_par1,bg_par1,en_cuts] = make_and_fit_cuts(data_source,br_cut_par);
            save(rez_file,'en_cuts','cuts_1','fits','fg_par1','bg_par1');
        end
        for k1=1:numel(en_cuts)
            the_cut = cuts_1(k1);
            en_i = 0.5*(the_cut.data.iint(1,3)+the_cut.data.iint(2,3));
            en_key = num2str(en_i);
            if cuts_areas.isKey(en_key)
                val = cuts_areas(en_key);
                val{end+1} = rez_wrapper(en_i,the_cut,fits(k1),fg_par1{k1},bg_par1{k1});
                cuts_areas(en_key) = val;
            else
                cuts_areas(en_key) = {rez_wrapper(en_i,the_cut,fits(k1),fg_par1{k1},bg_par1{k1})};
            end
        end
    end
end
