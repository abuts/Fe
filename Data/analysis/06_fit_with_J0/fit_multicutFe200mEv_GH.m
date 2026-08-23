root_path = fileparts(mfilename("fullpath"));
data_path = fullfile(root_path,'sym4D_cutsAndFits');


if ~exist('cuts2fit200','var')
    ld = load(fullfile(data_path,'multicuts_fit_dataGH_ei200meV.mat'));
    cuts2fit200 = ld.cuts2fit200;
end
%cuts_list = cuts2fit200.cutsS_list();
%cuts_list = {cuts2fit200.cut200_200sel};
%cuts_list = {cuts2fit200.cut110_sel};
%cuts_list = {cut(cuts2fit200.cut200_sel,[0,0.02,1],[])};
cuts_list  = cuts2fit200.cuts_dir001FFfit(1);
mi = maps_instrument(200,600,'S');
sample=IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.04,0.03,0.02]);
for i=1:numel(cuts_list)
    cuts_list{i} = cuts_list{i}.set_instrument(mi);
    cuts_list{i} = cuts_list{i}.set_sample(sample);
end


dir_name  = "GH";

dE_step = 2; %original energy transfer step data were binned to. No point in going finer
half_dE = 10; % half width of data binning
%cut_en = 30:10:120;
%cut_en = 40:10:150;
%cut_en = 145;
cut_en = 30:10:110; % cuts2fit200.cuts_dir001FFfit{1}

%cl= {cuts_list{3}};
%cl = {w2_test_cut};
if isfield(cuts2fit200,'bg_par_010off000')
    if numel(cuts_list) == 3
        bg_par = {cuts2fit200.bg_par_010off000.p,cuts2fit200.bg_par_010off100.p,cuts2fit200.bg_par_010off200.p};
    else
        %bg_par = {cuts2fit200.bg_par_010off100.p};
        bg_par = {cuts2fit200.bg_par_010off200.p};        
    end
    cuts_list{end+1} = bg_par;

end
[fit_res_200fix_bg,res_name] = fit_multicuts_along_direction(...
    cuts_list,'EnFit_Ei200ref001off110_2D_constFFCut',dir_name,cut_en,dE_step,half_dE);
    %cl,'En_cuts800',dir_name,cut_en,dE_step,half_dE);
beep
beep
beep
%fit_resEi200 = fit_res_200fix_bg;
save(res_name,"fit_resEi200")

