files = cell(9,1);
dir = fullfile(pwd,'Data');

for i=1:9
    files{i}=fullfile(dir,sprintf('HoracePartialZoneN%d_file_partN0.tmp',i));
end
outfile = fullfile(dir,'combinedsqw.sqw');
an_sqw = sqw();
write_nsqw_to_sqw (an_sqw, files, outfile,'allow_equal_headers');
