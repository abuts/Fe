function inst_full=inst_name_full(inst_abrv)
% Facility dependent function to convert abbreviated instrumnet name to full instrumnet name
% Returns blank string if there is no instrumnet, or ambiguous

inst_list_full={'maps','merlin','mari','het','let','prisma','alf'};
inst_list_abrv={'map', 'mer',   'mar', 'het','let','prs',   'alf'};

i=string_find(inst_abrv,inst_list_abrv);
if i>0
    inst_full=inst_list_full{i};
else
    inst_full='';
end
