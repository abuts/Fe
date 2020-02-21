function [qx,qy,qz,En,Sig] = read_add_sim()
filename = 'Fe_add_sim_m.dat';
%filename = 'sim_range.dat';
fh = fopen(filename,'rt');
if fh<0
    error('READ_ADD_SIM:runtime_error',...
        'Can not open input data file %s',filename);
end
clob = onCleanup(@()fclose(fh));
data = textscan(fh,'%f %f %f %f %f');
qx=data{1};
qy = data{2};
qz = data{3};
En = floor(data{4});
if numel(data) == 5
    Sig = data{5};
else
    Sig = zeros(size(data{4}));
end
