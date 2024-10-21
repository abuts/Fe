function fin_cut = get_finalNP()

data = fullfile(fileparts(fileparts(mfilename('fullpath'))),'Data','sqw','Fe_ei787.sqw');
Emax = 500;
dE   = 5;

Dqk = [-0.1,0.1];
Dql = [-0.1,0.1];

keep_only_last_plot = false;
alpha2 = 2*atand(1/5); % the rotation angle between two points at [2.5,0.5,0.5]
%                         and [2.5,0.5,-0.5] and similar

sym_op  = {symop([0,0,1],90),symop([0,0,1],alpha2),symop([0,0,1],90+alpha2 ),...
    symop([1,0,0],-90),[symop([0,0,1],90),symop([0,1,0], 90)],[symop([0,0,1],alpha2),symop([1,0,0],-90)],[symop([0,0,1],90+alpha2),symop([0,1,0],-90)],...
    symop([1,0,0], 90),[symop([0,0,1],90),symop([0,1,0],-90)],[symop([0,0,1],alpha2),symop([1,0,0], 90)],[symop([0,0,1],90+alpha2),symop([0,1,0], 90)]...
    };
%{symop([0,0,1],90),[symop([1,0,0],90),symop([0,0,1],90)]};
sym_axis = {[1,0,0];[0,-1,0]; [2.5,-0.5,0]};
proj = projection([0,0,1],[0,1,0],'uoffset',[2.5,-0.5,-0.5]);
fin_cut = cut_symop(data,proj,[-2,0.05,3],Dqk ,Dql ,[0,dE,Emax],[],[2.5,3],...
    sym_op,sym_axis,keep_only_last_plot );
fp = d2d(fin_cut);
fps = smooth(fp);
plot(fps);
lz 0 0.5
keep_figure;
