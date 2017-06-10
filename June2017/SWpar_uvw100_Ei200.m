function SWpar_uvw100_Ei200()
% Calculate SW parameters from range of specific cuts.
%-------------------------------------------------
% Parameters :
%
data_source= fullfile(pwd,'sqw','Data','Fe_ei200.sqw');
cuts = containers.Map;


bragg = [1,1,0];  % selected bragg
dE = 5;
dK = 0.05;
repPoints1 = [-0.2625,-0.1125,0,0.1375,0.3625;
    95,19,0,19,123];

repPoints2= [-0.2875,-0.0875,0,0.1375,0.3375;
    95,15,0,19,121];
repPoints3 = [-0.3125,-0.1125,0,0.1375,0.25;
    109,21,0,19,84];

cuts('[110]')= {parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK),...
    parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK),...
    parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK)};

bragg = [1,-1,0];  % selected bragg
dE = 5;
dK = 0.05;
repPoints1 = [-0.2625,-0.0875,0,0.2875,0.3375;
    95,17,0,67,121];
repPoints2= [-0.3375,-0.2625,0,0.0875,0.3125;
    123,73,0,13,97];
repPoints3 = [-0.3375,-0.1125,0,0.0875,0.3125;
    109,13,0,13,109];

cuts('[1-10]')= {parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK),...
    parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK),...
    parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK)};

bragg = [2,0,0];  % selected bragg
dE = 5;
dK = 0.05;
repPoints1 = [-0.275,-0.075,0,0.175,0.375;
    123,15,0,19,153];

repPoints2=[-0.3375,-0.1875,0,0.1875,0.3375;
    123,31,0,27,137];
repPoints3=[-0.31,-0.12,0,0.12,0.35;
    140,20,0,20,140];

cuts('[200]')= {parWithCorrections(repPoints1,bragg,[1,0,0],dE,dK),...
    parWithCorrections(repPoints2,bragg,[0,1,0],dE,dK),...
    parWithCorrections(repPoints3,bragg,[0,0,1],dE,dK)};


cuts_blocks = prepare_cuts_map(data_source,cuts);
en_list = cuts_blocks.keys;
en_list_num = cellfun(@str2num,en_list);
en_list_num = sort(en_list_num);
en_list  = arrayfun(@num2str,en_list_num,'UniformOutput',false);

n_en = numel(en_list);

en_sw = zeros(n_en,1);
S_sw  = zeros(n_en,1);
S_sw_err = zeros(n_en,1);
Gamma   = zeros(n_en,1);
Gamma_err = zeros(n_en,1);
for i=1:n_en
    en_key = en_list{i};
    cuts_group = cuts_blocks(en_key);
    n_cuts = numel(cuts_group);
    
    cut_info1 = cuts_group{1};
    en_sw(i) = cut_info1.en;
    disp('****************************************************')
    fprintf('**** Processing dE=%d, nCuts = %d\n',en_sw(i),n_cuts)
    
    
    %cuts_list = cellfun(@(dat)(dat.cut),cuts_group);
    cuts_list = repmat(cut_info1.cut,n_cuts,1);
    for j=1:n_cuts
        cuts_list(j) = cuts_group{j}.cut;
    end
    
    
    fg_par_list = cellfun(@(dat)(dat.fg_par),cuts_group,'UniformOutput',false);
    bg_par_list = cellfun(@(dat)(dat.bg_par),cuts_group,'UniformOutput',false);
    fitpar = reshape([fg_par_list{:}],10,n_cuts)';
    fitpar  = sum(fitpar,1)/n_cuts;
    disp('Fit guess:')
    disp(fitpar)
    
    %fitpar = [ff, T, gamma, Seff, gap, J1, 0 0 0 0];
    
    kk = tobyfit2(cuts_list);
    kk = kk.set_fun(@sqw_iron,fitpar,[0,0,1,1,0,0,0,0,0,0]);
    kk = kk.set_bfun(@(x,par)(par(1)+x*par(2)),bg_par_list);
    
    kk = kk.set_mc_points(10);
    %profile on;
    kk = kk.set_options('listing',0,'fit_control_parameters',[1.e-3;60;1.e-6]);
    [w1D_arr1_tf,fp_arr1]=kk.fit;
    %[w1D_arr1_tf,fp_arr1]=kk.simulate;
    S_sw(i) = fp_arr1.p(4);
    S_sw_err(i) = fp_arr1.sig(4);
    Gamma(i) = fp_arr1.p(3);
    Gamma_err(i) = fp_arr1.sig(3);
    disp('Fit params:')
    disp(fp_arr1.p)
    disp('Fit errors:')
    disp(fp_arr1.sig)
    disp('****************************************************')
    
    for j=1:numel(w1D_arr1_tf)
        acolor('k');
        plot(cuts_list(j));
        acolor('r');
        pd(w1D_arr1_tf(j));
        pause(1)
    end
    disp('****************************************************')
end
figure('Name','Spin wave amplitude along <100> direction');
errorbar(en_sw,S_sw,S_sw_err);
ly(0, 2.5)
figure('Name','Spin wave lifetime along <100> direction');
errorbar(en_sw,Gamma,Gamma_err);
ly(0,80);




function cuts_areas = prepare_cuts_map(data_source,cuts)

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
            cuts_1= ld.cuts_1;
            fits = ld.fits;
            fg_par1= ld.fg_par1;
            bg_par1 = ld.bg_par1;
            en_cuts = ld.en_cuts;
            
        else
            [cuts_1,fits,fg_par1,bg_par1,en_cuts] = make_and_fit_cuts(data_source,br_cut_par);
            save(rez_file,'en_cuts','cuts_1','fits','fg_par1','bg_par1');
        end
        for k1=1:numel(en_cuts)
            en_key = num2str(en_cuts(k1));
            if cuts_areas.isKey(en_key)
                val = cuts_areas(en_key);
                val{end+1} = rez_wrapper(en_cuts(k1),cuts_1(k1),fits(k1),fg_par1{k1},bg_par1{k1});
                cuts_areas(en_key) = val;
            else
                cuts_areas(en_key) = {rez_wrapper(en_cuts(k1),cuts_1(k1),fits(k1),fg_par1{k1},bg_par1{k1})};
            end
        end
    end
end
