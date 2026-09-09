fpath = 'e:\SHARE\Fe\Data\analysis\06_fit_with_J0';
if ~exist('fit_reEi800GP','var')
    res_name = 'FitEn_Ei800ff_1D_dirGP_dE10_constCutBg.mat';
    if isfile(res_name)
        ld = load(fullfile(fpath,res_name));
        fit_reEi800GP = ld.fit_reEi800GP;
    else
        error('Can not find fit data')
    end
end
projst.off110min = line_proj([-1,1,1],[-1,-1,0],'offset',[1,1,0],'alatt',2.8440,'angdeg',90);
projst.off110max = line_proj([1,1,1],[-1,1,0],'offset',[1,1,0],'alatt',2.8440,'angdeg',90);
projst.off200min = line_proj([-1,1,1],[-1,-1,0],'offset',[2,0,0],'alatt',2.8440,'angdeg',90);
projst.off200max = line_proj([1,1,1],[-1,1,0],'offset',[2,0,0],'alatt',2.8440,'angdeg',90);

[S110min,J110min,GS110min,projst.off110min_S] =...
    extract_fit_par(fit_reEi800GP.Ei800_off110minFFGP.all_fit_par);
[S110max,J110max,GS110max,projst.off110max_S] =...
    extract_fit_par(fit_reEi800GP.Ei800_off110maxFFGP.all_fit_par);

[S200min,J200min,GS200min,projst.off200min_S] =...
    extract_fit_par(fit_reEi800GP.Ei800_off200minFFGP.all_fit_par);
[S200max,J200max,GS200max,projst.off200max_S] = ...
    extract_fit_par(fit_reEi800GP.Ei800_off200maxFFGP.all_fit_par);

SS = [S110min, S110max, S200min,S200max];
JS = [J110min, J110max, J200min,  J200max];
GS = [GS110min, GS110max,GS200min, GS200max];


plot_block(SS); ly 0 3;liny; legend({'<110> min CFF','<110> max CFF','<200> min CFF','<200> max CFF'})
plot_block(JS); ly 20 60; legend({'<110> min CFF','<110> max CFF','<200> min CFF','<200> max CFF'})
plot_block(GS); ly 0 200; legend({'<110> min CFF','<110> max CFF','<200> min CFF','<200> max CFF'})

bg_par110min = extract_bg_par(fit_reEi800GP.Ei800_off110minFFGP.all_fit_par,1);
bg_par110max = extract_bg_par(fit_reEi800GP.Ei800_off110maxFFGP.all_fit_par,1);
bg_par200min = extract_bg_par(fit_reEi800GP.Ei800_off200minFFGP.all_fit_par,1);
bg_par200max = extract_bg_par(fit_reEi800GP.Ei800_off200maxFFGP.all_fit_par,1);
%
acolor k;
pd(bg_par110min);
acolor r;
pd(bg_par110max);
acolor g;
pd(bg_par200min);
acolor b;
pd(bg_par200max);logy; keep_figure;
legend({'<110> min CFF','<110> max CFF','<200> min CFF','<200> max CFF'})

flnm = fieldnames(projst);
is_base = cellfun(@(x)~contains(x,'_S'),flnm);
SQ      = repmat(IX_dataset_1d,1,4);
flnm = flnm(is_base);
xAx = IX_axis('q^2 A^-2');
yAx = IX_axis('Scattering amplitude','mbarn/(Sr*fmu*meV)');
for i=1:numel(flnm)
    dirProj = projst.(flnm{i});
    ds  = projst.([flnm{i},'_S']);
    img_cr = [1;0;0]*ds.x;
    q    = dirProj.transform_img_to_pix(img_cr);
    q_sq = sum(q.^2,1);
    [q_sq,idx] = sort(q_sq);
    sigS = ds.signal(idx);
    errS  = ds.error(idx);
    SQ(i) = IX_dataset_1d(q_sq,sigS,errS);
    SQ(i).x_axis = xAx;
    SQ(i).s_axis = yAx;
end
plot_block(SQ);liny; ly 0 2.5; legend({'<110> min CFF','<110> max CFF','<200> min CFF','<200> max CFF'})

function plot_block(BN)
gi = genieplot.instance();
gi.line_widths = 2;
gi.colors = {'r'};
gi.marker_types= {'x'};
pd(BN(1));
gi.line_widths = 3;
gi.marker_types= {'o'};
pd(BN(2));

%----------------------
gi.line_widths = 2;
gi.colors = {'g'};
gi.marker_types= {'x'};
pd(BN(3));
gi.line_widths = 3;
gi.marker_types= {'o'};
pd(BN(4));

keep_figure;
end