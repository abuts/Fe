disp(HN_FFCutsFits) %[output:12eca82b]
d = struct2cell(HN_FFCutsFits);
fn = fieldnames(HN_FFCutsFits);
%%
fn{1}='Ei400_offH1H0_HNmaxFF';
fn{2}='Ei400_off1H1H0_HNminFF';
fn{3}='Ei400_offH2H0_HNminFF';
fn{5}='Ei800_offH1H0_HNminFF';
fn{6}='Ei800_off1H1H0_HNminFF';
fn{7}='Ei800_offH2H0_HNminFF';
fn{8}='Ei800_offH2H0_HNminFF_all_fit_par';
fn{9}='Ei800_off1H1H0_HNminFF_all_fit_par';

disp(fn) %[output:1e201047]
%%
HNS = cell2struct(d,fn) %[output:8f629d9a]
HN_FFCutsFits = HNS %[output:4a2b9278]

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright"}
%---
%[output:12eca82b]
%   data: {"dataType":"text","outputData":{"text":"                 Ei400HN_offH1H0maxFF: [1×1 sqw]\n                Ei400HN_off1H1H0minFF: [1×1 sqw]\n                 Ei400HN_offH2H0minFF: [1×1 sqw]\n                            data_name: 'HN_FFCutsFits'\n                 Ei800HN_offH1H0maxFF: {[1×1 sqw]}\n                Ei800HN_off1H1H0minFF: [1×1 sqw]\n                 Ei800HN_offH2H0minFF: [1×1 sqw]\n     Ei800HN_offH2H0minFF_all_fit_par: [1×19 struct]\n    Ei800HN_off1H1H0minFF_all_fit_par: [1×15 struct]\n\n","truncated":false}}
%---
%[output:1e201047]
%   data: {"dataType":"text","outputData":{"text":"    {'Ei400_offH1H0_HNmaxFF'             }\n    {'Ei400_off1H1H0_HNminFF'            }\n    {'Ei400_offH2H0_HNminFF'             }\n    {'data_name'                         }\n    {'Ei800_offH1H0_HNminFF'             }\n    {'Ei800_off1H1H0_HNminFF'            }\n    {'Ei800_offH2H0_HNminFF'             }\n    {'Ei800_offH2H0_HNminFF_all_fit_par' }\n    {'Ei800_off1H1H0_HNminFF_all_fit_par'}\n\n","truncated":false}}
%---
%[output:8f629d9a]
%   data: {"dataType":"textualVariable","outputData":{"header":"struct with fields:","name":"HNS","value":"                 Ei400_offH1H0_HNmaxFF: [1×1 sqw]\n                Ei400_off1H1H0_HNminFF: [1×1 sqw]\n                 Ei400_offH2H0_HNminFF: [1×1 sqw]\n                             data_name: 'HN_FFCutsFits'\n                 Ei800_offH1H0_HNminFF: {[1×1 sqw]}\n                Ei800_off1H1H0_HNminFF: [1×1 sqw]\n                 Ei800_offH2H0_HNminFF: [1×1 sqw]\n     Ei800_offH2H0_HNminFF_all_fit_par: [1×19 struct]\n    Ei800_off1H1H0_HNminFF_all_fit_par: [1×15 struct]\n"}}
%---
%[output:4a2b9278]
%   data: {"dataType":"textualVariable","outputData":{"header":"struct with fields:","name":"HN_FFCutsFits","value":"                 Ei400_offH1H0_HNmaxFF: [1×1 sqw]\n                Ei400_off1H1H0_HNminFF: [1×1 sqw]\n                 Ei400_offH2H0_HNminFF: [1×1 sqw]\n                             data_name: 'HN_FFCutsFits'\n                 Ei800_offH1H0_HNminFF: {[1×1 sqw]}\n                Ei800_off1H1H0_HNminFF: [1×1 sqw]\n                 Ei800_offH2H0_HNminFF: [1×1 sqw]\n     Ei800_offH2H0_HNminFF_all_fit_par: [1×19 struct]\n    Ei800_off1H1H0_HNminFF_all_fit_par: [1×15 struct]\n"}}
%---
