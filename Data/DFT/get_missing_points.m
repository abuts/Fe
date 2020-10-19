function get_missing_points(filename)
% the function generates missing energy points to use in DFT calculations
% and saves these points into file with the name specified

if ~exist('filename','var')
    filename = 'missingEn_points.dat';
end


% existing data:
[qx,qy,qz,En,Sig] = read_add_sim();
% convert volume data into the form, suitable for applying symmetry
% operations in Q-space, i.e convert energy points int cellarray, of size(qx)
% with cells containing {[energy trafer,signal]} blocks.
[qx,qy,qz,es] = compact3D(En,qx,qy,qz,Sig);
%
% Identify overlapping points, coinciding from volume 
% and high symmetry calculations 
%
%[px,py,pz,Es] = read_allLin_Kun();
%q_c = round([px,py,pz],3);
% 
%r_c = round([qx,qy,qz],3);
% same_x = ismember(r_c(:,1),q_c(:,1));
% same_y = ismember(r_c(:,2),q_c(:,2));
% same_z = ismember(r_c(:,3),q_c(:,3));
% same = same_x & same_y & same_z;
% if any(same) %only 0.5,0.5,0.5 coinsides
%     same_s = ismember(q_c(:,1),r_c(:,1))&ismember(q_c(:,2),r_c(:,2))&ismember(q_c(:,2),r_c(:,2));
%     es(same) = Es(same_s); % 
% end
E_range = 8:8:800;
Es_missing = cellfun(@(se)gen_missing(se,E_range),es,'UniformOutput',false);

fh = fopen(filename,'w');
for i=1:numel(qx)
   en = Es_missing{i};    
    for j=1:numel(en)
        if isempty(en)
            break;
        end
        fprintf(fh,'%6.4f  %6.4f  %6.4f  %6.4f\n',qx(i),qy(i),qz(i),en(j));
    end
    fprintf(fh,'\n');
end
fclose(fh);

function misp = gen_missing(sigerr,E_range)

en = round(sigerr(:,1));
present = ismember(E_range,en);
misp  = E_range(~present);
