% Set up locations of data sources
%data800='d:\data\Fe\sqw_Toby\Fe_ei787.sqw';
data800 = fullfile(pwd,'sqw','Data','Fe_ei787.sqw');
% Sample description
sample = IX_sample(true,[1,0,0],[0,1,0],'cuboid',[0.03,0.03,0.04]);

%% Try to set instrument information: fails:
set_instrument_horace (data800, @maps_instrument, '-efix', 600, 'S')

% Produces the following error
%         Error using copy_contents_>open_obj_file (line 53)
%         Can not open file  in rb mode
% 
%         Error in copy_contents_ (line 28)
%                 obj = open_obj_file(obj,file,'rb');
% 
%         Error in faccess_sqw_v3/copy_contents (line 125)
%                     [obj,missinig_fields] = copy_contents_(obj,other_obj,keep_internals);
% 
%         Error in upgrade_file_format_ (line 17)
%         [new_obj,missing] = new_obj.copy_contents(obj);
% 
%         Error in faccess_sqw_v2/upgrade_file_format (line 132)
%                     new_obj = upgrade_file_format_(obj);
% 
%         Error in set_instrument_horace (line 61)
%                     ldr = ldr.upgrade_file_format();
 

            
%% Set sample information, this works; then issue the same set instrumnet 
%  command as above; now it works! All information seems to be correct.
set_sample_horace (data800, sample)

set_instrument_horace (data800, @maps_instrument, '-efix', 600, 'S')







