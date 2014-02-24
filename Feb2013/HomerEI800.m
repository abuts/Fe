spe_dir = [pwd,'/EI800'];
%Iliad_065 (11012, 400, 11277, [], 11271, [-71, 2, 381], 11276, [])
%movefile(fullfile(spe_dir,'MAP11012_4to1_065.spe'),fullfile(spe_dir,'MAP11012_4to1_065_ei400.spe'))

% Horace scans:
% Nov. 2006: Ei approx. 800 meV (read correct Ei from the output of Homer to the screen)
% for runno=11142:11201
repeat = 0;
for runno=11142:11201
    while repeat<10
     try    
         Iliad_065 (runno, 800 , 11277, [], 11270, [-102, 4, 752], 11276, [])
         %Iliad_065 (runno, 195 , 11277, [], 11270, [-10.5,1,180.5], 11276, [])  
         repeat = 11;
     catch exc
         fh=fopen('homer1.log','a');        
         fprintf(fh,'Error %s; Retrying run N %d\n',exc.message,runno);
         fclose(fh);
         repeat = repeat+1;
     end
    end
    movefile(fullfile(spe_dir,['MAP',num2str(runno),'_4to1_065.spe']),fullfile(spe_dir,['MAP',num2str(runno),'_4to1_065_ei787.spe']))
    repeat=0; 
end
delete(fullfile(spe_dir,'MAP11270.sum'))      % MUST DELETE SUM FILE SO IT IS RECALCULATED FOR EI=196

% Nov. 2006: Ei approx. 200 meV second chopper peak
%for runno=11071:11201
%     Iliad_065 (runno, 195 , 11277, [], 11270, [-10.5,1,180.5], 11276, [])
%     movefile(fullfile(spe_dir,['MAP',num2str(runno),'_4to1_065.spe']),fullfile(spe_dir,['MAP',num2str(runno),'_4to1_065_ei196.spe']))
% end
% delete(fullfile(spe_dir,'MAP11270.sum'))      % MUST DELETE SUM FILE SO IT IS RECALCULATED FOR EI=87

% Nov. 2006: Ei approx. 90 meV third chopper peak
%for runno=11071:11201
repeat = 0;
for runno=11071:11201    
    while repeat<10
        try
            Iliad_065 (runno, 90 , 11277, [], 11270, [-10.25,0.5,80.25], 11276, [])
            repeat = 11;
        catch exc
             fh=fopen('homer1.log','a');
             fprintf(fh,'Error %s; Retrying run N %d\n',exc.message,runno);
             fclose(fh);            
            repeat = repeat+1;
        end
    end
    movefile(fullfile(spe_dir,['MAP',num2str(runno),'_4to1_065.spe']),fullfile(spe_dir,['MAP',num2str(runno),'_4to1_065_ei87.spe']))
    repeat = 0;
end
delete(fullfile(spe_dir,'MAP11270.sum'))
