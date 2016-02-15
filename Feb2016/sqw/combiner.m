n_zones = 6;

files = cell(n_zones,1);
dir = fullfile(pwd,'Data');
filename_f = @(nzone,nsubsone)(fullfile(dir,sprintf('HoracePartialZoneN%d_file_partN%d.tmp',nzone,nsubsone)));

for i=1:n_zones
    files{i}=filename_f(i,0);
	if exist(files{i},'file')~=2
		ip=1;
		subfiles = {};
		subfile = filename_f(i,ip);
		while exist(subfile,'file')==2
			subfiles{ip} = subfile;
			ip = ip+1;
			subfile = filename_f(i,ip);
		end
		files{i} = subfiles;
		
	end
end
files = flatten_cell_array(files);
outfile = fullfile(dir,'combinedsqw.sqw');
an_sqw = sqw();
write_nsqw_to_sqw (an_sqw, files, outfile,'allow_equal_headers');
