[Jd_200K,Sds2_8,GamDs2_8]=get_Jfit('J_CenFit_Fe_ei200_8Braggs_J0-0','<100>');
[Jds4_8,Sds4_8,GamDs4_8]=get_Jfit('J_CenFit_Fe_ei401_8Braggs_J0-0 ','<100>');
[Jds8_3,Sds8_3,GamDs8_3]= get_Jfit('J_CenFit_Fe_ei787_3Braggs_J0-0','<100>');

[Jds2_81,Sds2_81,GamDs2_81]=get_Jfit('J_CenFit_Fe_ei200_8Braggs_J0-0','<110>');
[Jds4_81,Sds4_81,GamDs4_81]=get_Jfit('J_CenFit_Fe_ei401_8Braggs_J0-0 ','<110>');
[Jds8_31,Sds8_31,GamDs8_31]= get_Jfit('J_CenFit_Fe_ei787_3Braggs_J0-0','<110>');

[Jds2_82,Sds2_82,GamDs2_82]=get_Jfit('J_CenFit_Fe_ei200_8Braggs_J0-0','<111>');
[Jds4_82,Sds4_82,GamDs4_82]=get_Jfit('J_CenFit_Fe_ei401_8Braggs_J0-0 ','<111>');
[Jds8_32,Sds8_32,GamDs8_32]= get_Jfit('J_CenFit_Fe_ei787_3Braggs_J0-0','<111>');



% summary plots:
Jds2_8.title = 'J0 vs energy for all energy cuts';
acolor('r');  aline('-')
[~,~,l1]=dd(Jds2_8);
acolor('g');
[~,~,l2]=pd(Jds4_8);
acolor('b');
[~,~,l3]=pd(Jds8_3);

ly 20 60
legend([l1(1),l2(1),l3(1)],'J0 for Ei=200','J0 for Ei=400','J0 for Ei=800');
keep_figure;

Sds2_8.title = 'Amplitude vs En; directions <100> <110> and <111>';
acolor('r');  aline('-.')
[~,~,l1]=dd(Sds2_8);
aline('-');pd(Sds4_8);
aline('--');pd(Sds8_3);
acolor('g');  aline('-.')
[~,~,l2]=pd(Sds2_81);
aline('-');pd(Sds4_81);
aline('--');pd(Sds8_31);
acolor('b'); aline('-.')
[~,~,l3]=pd(Sds2_82);
aline('-');pd(Sds4_82);
aline('--');pd(Sds8_32);
ly 0 4
legend([l1(1),l2(1),l3(1)],'<100>','<110>','<111>');
keep_figure;

GamDs2_8.title = '\gamma vs En; directions <100> <110> and <111>';
acolor('r');  aline('-.')
[~,~,l1]=dd(GamDs2_8);
aline('-');pd(GamDs4_8);
aline('--');pd(GamDs8_3);
acolor('g'); aline('-.')
[~,~,l2]=pd(GamDs2_81);
aline('-');pd(GamDs4_81);
aline('--');pd(GamDs8_31);
acolor('b'); aline('-.')
[~,~,l3]=pd(GamDs2_82);
aline('-');pd(GamDs4_82);
aline('--');pd(GamDs8_32);
ly 0 200
legend([l1(1),l2(1),l3(1)],'<100>','<110>','<111>');
keep_figure;
