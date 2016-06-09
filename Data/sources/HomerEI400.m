% March 2010: Ei approx. 400 meV (read correct Ei from the output of Homer to the screen)
for runno=15159:15178
    id = getgpath('inst_data');
    for i=1:numel(id)
        disp(['**************   inst_data for run ',num2str(runno),' before: ',id{i}]);        
    end

    Iliad_095 (runno, 400 , 15182, [], 15181, [-71, 2, 381])
    
    id = getgpath('inst_data');
    for i=1:numel(id)
        disp(['**************   inst_data for run ',num2str(runno),' after: ',id{i}]);        
    end

end
