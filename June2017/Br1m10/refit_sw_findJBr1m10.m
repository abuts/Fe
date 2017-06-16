function refit_sw_findJBr1m10(varargin)
%
%
if nargin>0
    e_min = varargin{1};
    e_max = varargin{2};
else
    e_min  = -inf;
    e_max  = inf;
end
cuts_list = containers.Map();
%bragg_list = {[1,1,0],[1,-1,0],[2,0,0],[0,-1,-1],[0,1,-1],[0,-1,1]};
bragg_list = {[1,-1,0]};
file_list = {'Fe_ei200'};

%cuts_list('[1-10]') = {[1,0,0],[0,1,0],[0,0,1]};

cuts_list('[0-11]') = {[1,0,0],[0,1,0],[0,0,1]};
cuts_list('[110]') = {[1,0,0],[0,1,0],[0,0,1],...
    [1,1,0],[1,-1,0],[1,0,1],[1,0,-1],[0,1,1],[0,1,-1],...
    [1,1,1],[1,1,-1],[1,-1,-1],[1,-1,1]};
cuts_list('[1-10]') = {[1,0,0],[0,1,0],[0,0,1],...
    [1,1,0],[1,-1,0],[1,0,1],[1,0,-1],[0,1,1],[0,1,-1],...
    [1,1,1],[1,1,-1],[1,-1,-1],[1,-1,1]};
cuts_list('[200]') = {[1,0,0],[0,1,0],[0,0,1],...
    [1,1,0],[1,-1,0],[1,0,1],[1,0,-1],[0,1,1],[0,1,-1],...
    [1,1,1],[1,1,-1],[1,-1,-1],[1,-1,1]};
cuts_list('[0-1-1]') = {[1,0,0],[0,1,0],[0,0,1],...
    [1,1,0],[1,-1,0],[1,0,1],[1,0,-1],[0,1,1],[0,1,-1],...
    [1,1,1],[1,1,-1],[1,-1,-1],[1,-1,1]};
cuts_list('[01-1]') = {[1,0,0],[0,1,0],[0,0,1],...
    [1,1,0],[1,-1,0],[1,0,1],[1,0,-1],[0,1,1],[0,1,-1],...
    [1,1,1],[1,1,-1],[1,-1,-1],[1,-1,1]};
cuts_list('[0-11]') = {[1,0,0],[0,1,0],[0,0,1],...
    [1,1,0],[1,-1,0],[1,0,1],[1,0,-1],[0,1,1],[0,1,-1],...
    [1,1,1],[1,1,-1],[1,-1,-1],[1,-1,1]};


% build the list of input filenames and verifuy if the files are present.
[filenames,file_directions] = check_input_files_present(bragg_list,cuts_list,file_list);

bind_map = containers.Map();

n_files = numel(filenames);
cut_list = {};
bg_params = {};
fg_params = {};
fitpar_av = zeros(1,10);
cut_count = 0;
av_count = 0;
      
J0 = 8.0092;
J1 = 39.8558;
J2 = 3.2676 ;
J3 =-4.3366;
J4 = 2.5852;
par_pattern = [1,8,80,2.5,0,J0,J1,J2,J3,J4];
cut_en_f = @(x)(0.5*(x.data.iint(1,3)+x.data.iint(2,3)));
for i=1:n_files
    data_file = filenames{i};
    
    [~,fname] = fileparts(data_file);
    fprintf('reloading cut file: %s %d#%d\n',fname,i,n_files);
    ld = load(data_file);
    cuts_en = arrayfun(cut_en_f,ld.cut_list);
    cuts_2_use = cuts_en>=e_min &cuts_en<=e_max;
    n_cuts= sum(cuts_2_use);
    if n_cuts == 0
        continue
    end
    
    % Build binds between equivalent cuts:
    used_cuts = ld.cut_list(cuts_2_use);
    %     former_fits = ld.w1D_arr1_tf(cuts_2_use);
    %     for ii=1:numel(former_fits)
    %         acolor('k');
    %         plot(used_cuts(ii));
    %         acolor('r');
    %         pd(former_fits(ii));
    %         pause(1)
    %     end
    
    
    direction = file_directions{i};
    cut_dir_id = direction_id(direction);
    for j=1:n_cuts
        en = cut_en_f(used_cuts(j));
        bind_id = [num2str(en),cut_dir_id];
        if bind_map.isKey(bind_id)
            val = bind_map(bind_id);
            val{end+1} = cut_count+j;
            bind_map(bind_id)= val;
        else
            bind_map(bind_id) = {cut_count+j};
        end
    end
    cut_count = cut_count + n_cuts;
    
    
    cut_list = [cut_list(:);used_cuts(:)];
    
    
    cut_fiterr = reshape([ld.fp_arr1.sig{cuts_2_use}],10,n_cuts)';
    cut_fitpar = reshape([ld.fp_arr1.p{cuts_2_use}],10,n_cuts)';
    cut_fitpar(:,3) = abs(cut_fitpar(:,3));
    cut_fitpar(:,6) = J0;
    cut_fitpar(:,7) = J1;
    cut_fitpar(:,8) = J2;
    cut_fitpar(:,9) = J3;
    cut_fitpar(:,10) = J4;
    
    
    
    
    not_valid = cut_fiterr>10 |cut_fitpar> par_pattern | isnan(cut_fiterr) | isnan(cut_fitpar) ;
    if any(reshape(not_valid,1,numel(not_valid)))
        if av_count>0
            ffa = fitpar_av/av_count;
        else
            ffa  = par_pattern;
        end
        cor = repmat(ffa,n_cuts,1);
        cut_fitpar(not_valid) = cor(not_valid);
        %ld.fp_arr1.p{not_valid} = ffa;
    else
        fitpar_av  = fitpar_av+sum(cut_fitpar,1);
        av_count   = av_count + n_cuts;
    end
    
    p = arrayfun(@(ind)(cut_fitpar(ind,:)),1:n_cuts,'UniformOutput',false);
    
    bg_params = {bg_params{:},ld.fp_arr1.bp{cuts_2_use}};
    fg_params  = {fg_params{:},p{:}};
    
end
n_cuts = cut_count;
fitpar_av = fitpar_av/av_count   ;

% build bind map
keys = bind_map.keys;
add_binds = {};
for i=1:numel(keys)
    theKey = keys{i};
    binding = bind_map(theKey);
    if numel(binding) > 1
        [ok,mess] = check_correct_binding(cut_list,bind_map,theKey);
        if ~ok
            error('REFIT_SW:runtime_error',mess);
        end
        loc_binds = cell(2*(numel(binding)-1),1);
        n_func = binding{1};
        for j=1:numel(binding)-1
            loc_binds{2*j-1} = {[3,binding{j+1}],[3,n_func],1};
            loc_binds{2*j} = {[4,binding{j+1}],[4,n_func],1};
        end
        add_binds = {add_binds{:},loc_binds{:}};
        
    end
end



% S(Q,w) model
ff = 1; % 1
T = 8;  % 2
%gamma = 10; % 3
gamma = fitpar_av(3);
gap = 0;    % 5
%Seff = 2;   % 4
Seff = fitpar_av(4);
%J1 = 40;    % 6
J0 = fitpar_av(6);
par = [ff, T, gamma, Seff, gap, J0, J1, J2, 0, 0];


%
kk = tobyfit2(cut_list);
%ff_calc = mff.getFF_calculator(cut_list(1));
kk = kk.set_local_foreground(true);
kk = kk.set_fun(@sqw_iron,fg_params,[0,0,1,1,0,1,1,1,1,1]);
%kk = kk.set_fun(@(h,k,l,e,par)sw_disp(proj,ff_calc,h,k,l,e,par),[parR(1),parR(2),parR(3),ampl_avrg,fwhh_avrg],[1,1,1,1,1]);
%kk = kk.set_bind({1,[1,2],1},{2,[2,2],1},{3,[3,2],1});
global_binds = {{6,[6,2],1},{7,[7,2],1},{8,[8,2],1},{9,[9,2],1},{10,[10,2],1}};
all_binds = {global_binds{:},add_binds{:}};
kk = kk.set_bind(all_binds{:});

% set up its own initial background value for each background function
kk = kk.set_bfun(@lin_bg,bg_params);

kk = kk.set_mc_points(10);
%profile on;
kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-2;60;1.e-6]);
%kk = kk.set_options('listing',1,'fit_control_parameters',[1.e-4;20;1.e-4]);
%profile on;
[w1D_arr1_tf,fp_arr1]=kk.fit;
%[w1D_arr1_tf,fp_arr1]=kk.simulate;
%profile off
%profile viewer

if iscell(fp_arr1.p)
    fitpar = reshape([fp_arr1.p{:}],10,numel(fp_arr1.p))';
    fiterr = reshape([fp_arr1.sig{:}],10,numel(fp_arr1.sig))';
else
    fitpar = fp_arr1.p;
    fiterr = fp_arr1.sig;
end
J0 = fitpar(1,6);
J1 = fitpar(1,7);
J2 = fitpar(1,8);
J3 = fitpar(1,9);
J4 = fitpar(1,10);

J0_err = fiterr(1,6);
J1_err = fiterr(1,7);
J2_err = fiterr(1,8);
J3_err = fiterr(1,9);
J4_err = fiterr(1,10);

fprintf([' J over number of cuts:\n J0: %6.3f +/-%6.3f; J1: %6.3f +/-%6.3f;',...
    ' J2: %6.3f +/-%6.3f  J3: %6.3f +/-%6.3f  J4: %6.3f +/-%6.3f\n'],...
    J0,J0_err,J1,J1_err,J2,J2_err,J3,J3_err,J4,J4_err);

% %fback = kk.simulate(w110arr1_tf,'back');
% %pl(fback)
% Amp    = fitpar(:,4);
% Amp_err= fiterr(:,4);
% fhhw   = fitpar(:,3);
% fhhw_err=fiterr(:,3);
f_en =@(x)(0.5*(x.data.iint(2,3)+x.data.iint(1,3)));
for i=1:numel(keys)
    theKey = keys{i};
    binding = bind_map(theKey);
    ind = [binding{:}];
    stor = struct();
    cuts_fitpar=struct();
    stor.cut_list = cut_list(ind);
    stor.w1D_arr1_tf = w1D_arr1_tf(ind);
    cuts_fitpar.p = fp_arr1.p(ind);
    cuts_fitpar.sig = fp_arr1.sig(ind);
    cuts_fitpar.bp  = fp_arr1.bp(ind);
    cuts_fitpar.bsig =fp_arr1.bsig(ind);
    stor.fp_arr1 = cuts_fitpar;
    stor.es_valid = arrayfun(f_en,stor.cut_list);
    dir_ind = regexp(theKey,'[<>]');
    dir_id = theKey(dir_ind(1)+1:dir_ind(2)-1);
    fn = sprintf('EnCuts_%s_dE%d_dir_!%s!',file_list{1},stor.es_valid(1),dir_id);
    
    fld_names = fieldnames(stor);
    save(fn,'-struct','stor',fld_names{:});
    for j=1:numel(ind)
        acolor('k');
        plot(stor.cut_list(j));
        acolor('r');
        pd(stor.w1D_arr1_tf(j));
        fprintf(' cut E=%d; Key N:%d/%d EnN%d/%d; Ncuts: %d\n',stor.es_valid(j),i,numel(keys),j,numel(ind),n_cuts);
        fprintf(' par: %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f\n',cuts_fitpar.p{j}(3:10));
        fprintf(' err: %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f\n',cuts_fitpar.sig{j}(3:10));
        pause(1)
    end
    
end
% for i=1:numel(w1D_arr1_tf)
%     acolor('k');
%     plot(cut_list(i));
%     acolor('r');
%     pd(w1D_arr1_tf(i));
%     fprintf(' cut N: %d/%d\n',i,n_cuts);
%     fprintf(' par: %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f \n',fitpar(i,3:8));
%     fprintf(' err: %7.4f %7.4f %7.4f %7.4f %7.4f %7.4f \n',fiterr(i,3:8));
%     pause(1)
% end
%bg_params = fp_arr1.bp;
[en100,S100,S100_err,G100,G100_err] = extract_fitpar(10:5:180,[1,0,0],bind_map,fp_arr1);
[en110,S110,S110_err,G110,G110_err] = extract_fitpar(10:5:180,[1,1,0],bind_map,fp_arr1);
[en111,S111,S111_err,G111,G111_err] = extract_fitpar(10:5:180,[1,1,1],bind_map,fp_arr1);
%-------------------------------------------------------------
brn = cellfun(@(br)(['[',num2str(br(1)),num2str(br(2)),num2str(br(3)),'];']),bragg_list,'UniformOutput',false);
name = [brn{:}];
figure('Name',['Intensity scale for peaks: ',name]);
li1=errorbar(en100,S100,S100_err,'r');
hold on
li2=errorbar(en110,S110,S110_err,'g');
li3=errorbar(en111,S111,S111_err,'b');
%
plots = [li1, li2, li3];
ly 0 2.5
legend(plots,'<100>','<110>','<111>');
%-------------------------------------------------------------
figure('Name',['Inverse lifetime (meV) for peaks: ',name]);
li1=errorbar(en100,G100,G100_err,'r');
hold on
li2=errorbar(en110,G110,G110_err,'g');
li3=errorbar(en111,G111,G111_err,'b');
%
plots = [li1, li2, li3];
ly 0 80
legend(plots,'<100>','<110>','<111>');


save('J_fit_E200_All_J0-4','fitpar','bg_params','bragg_list',...
    'file_list','bind_map','fp_arr1');


function bg = lin_bg(x,par)
%
bg  = par(1)+x*par(2);



function in = ind_name(ind)
if ind<0
    in = ['m',num2str(abs(ind))];
else
    in = num2str(ind);
end
%

function [filenames,file_directions] = check_input_files_present(bragg_list,cuts_list,file_list)
% build input files names and check if the files with appropriate names are present
%
%Return:
% list of existign files to read data from.
% list of 3D vectors, defining the direction of a cut.

br_name = @(bragg)(['[' num2str(bragg(1)) num2str(bragg(2))  num2str(bragg(3)) ']']);
br_folder = @(bragg)(['Br',ind_name(bragg(1)),ind_name(bragg(2)),ind_name(bragg(3))]);


filenames = {};
file_directions = {};
for i=1:numel(bragg_list)
    bragg = bragg_list{i};
    cut_name  = br_name(bragg);
    cuts = cuts_list(cut_name);
    for j=1:numel(file_list)
        file = file_list{j};
        for k1=1:numel(cuts)
            direction = cuts{k1};
            data_file = rez_name(file,bragg,direction);
            %fn = br_folder(bragg);
            scr_folder = fileparts(mfilename('fullpath'));
            data_file = fullfile(scr_folder,[data_file,'.mat']);
            if exist(data_file,'file') == 2
                filenames = [filenames(:);{data_file}];
                file_directions = [file_directions(:);direction];
            else
                error('file %s does not exist',data_file);
            end
        end
        
    end
end
