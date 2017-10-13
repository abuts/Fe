function dat = convert_dft_dat()

fid = fopen('Volume.dat');

clOb = onCleanup(@()fclose(fid));

tline = fgetl(fid);
ic = 0;
dat = zeros(101,101,101,501,'single');
ik_prev=1;
%profile on
while ischar(tline)
    [ih,ik,il,ie] = count_ind(ic);
    if ik ~= ik_prev
        fprintf(' step h%d k%d l%d e%d\n',ih,ik,il,ie);
        ik_prev = ik;
    end
    %C = strsplit(tline);
    C = textscan(tline,'%4s %4s %4s %4s %14.5f');
    %dat(ih,ik,il,ie) = str2double(C(6));
    dat(ih,ik,il,ie) = C{5};
    ic = ic+1;
    
    tline = fgetl(fid);
    
end


save('Volume.mat','dat','-v7.3');

function [ih,ik,il,ie] = count_ind(ic)
ie = rem(ic,501)+1;
ic = round((ic-ie)/501);
il = rem(ic,101)+1;
ic = round((ic-il)/101);
ik = rem(ic,101)+1;
ic = round((ic-ik)/101);
ih = rem(ic,101)+1;
