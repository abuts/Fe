function [Jds,Sds,GamDs]=get_Jfit(filename,dirId)

ld = load(filename);
keys = ld.bind_map.keys;
en = cellfun(@get_en,keys,'UniformOutput',true);
en = sort(en);
nEn = numel(en);
JofEn = NaN*zeros(nEn,1);
JofEnS = NaN*zeros(nEn,1);

SofEn = NaN*zeros(nEn,1);
SofEnS = NaN*zeros(nEn,1);

GofEn = NaN*zeros(nEn,1);
GofEnS = NaN*zeros(nEn,1);
for i=1:numel(en)
    key =[ num2str(en(i)),dirId];
    if ~ld.bind_map.isKey(key)
        continue;
    end
    binding = ld.bind_map(key);
    ind = [binding{:}];
    if ~isempty(ld.fitpar)
        par = ld.fitpar.p(ind);
        err = ld.fitpar.sig(ind);
    else
        par = ld.fp_arr1.p(ind);
        err = ld.fp_arr1.sig(ind);
        
    end
    
    par1 = par{1};
    sig1 = err{1};
    JofEn(i) = par1(6);
    SofEn(i) = par1(4);
    GofEn(i) = par1(3);
    JofEnS(i) = sig1(6);
    SofEnS(i) = sig1(4);
    GofEnS(i) = sig1(3);
    
end

valid = ~isnan(JofEn);
en = en(valid);
JofEn = JofEn(valid);
SofEn = SofEn(valid);
GofEn = GofEn(valid);
JofEnS = JofEnS(valid);
SofEnS = SofEnS(valid);
GofEnS = GofEnS(valid);
Jds = IX_dataset_1d (en,JofEn,JofEnS);
Jds.title = ['J0 vs En; direction: ',dirId];
Jds.x_axis = 'En (mEv)';
Jds.s_axis = 'J0 (mEv)';

Sds = IX_dataset_1d (en,SofEn,SofEnS);
Sds.title = ['Sw Ampliture vs En; direction: ',dirId];
Sds.x_axis = 'En (mEv)';
Sds.s_axis = 'S';


GamDs = IX_dataset_1d (en,GofEn,GofEnS);
GamDs.title = ['Decay vs En; direction: ',dirId];
GamDs.x_axis = 'En (mEv)';
GamDs.s_axis = '\gamma (mEv)';






function en = get_en(key)
car = strsplit(key,'<');

en = str2double(car{1});
