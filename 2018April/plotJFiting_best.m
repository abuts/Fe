
[~,Sds200K_100,GamDs200K_100]=get_Jfit('J_CenFit_Fe_ei200_8Braggs_J0-0','<100>');
[~,Sds200K_110,GamDs200K_110]=get_Jfit('J_CenFit_Fe_ei200_8Braggs_J0-0','<110>');
[Jds200K,Sds200K_111,GamDs200K_111]=get_Jfit('J_CenFit_Fe_ei200_8Braggs_J0-0','<111>');

[~,Sds400K_100,GamDs400K_100]=get_Jfit('J_CenFit_Fe_ei401_8Braggs_J0-0 ','<100>');
[~,Sds400K_110,GamDs400K_110]=get_Jfit('J_CenFit_Fe_ei401_8Braggs_J0-0 ','<110>');
[Jds400K,Sds400K_111,GamDs400K_111]=get_Jfit('J_CenFit_Fe_ei401_8Braggs_J0-0 ','<111>');

[~,Sds800K_100,GamDs800K_100]= get_Jfit('J_CenFit_Fe_ei787_3Braggs_J0-0','<100>');
[~,Sds800K_110,GamDs800K_110]= get_Jfit('J_CenFit_Fe_ei787_3Braggs_J0-0','<110>');
[Jds800K,Sds800K_111,GamDs800K_111]= get_Jfit('J_CenFit_Fe_ei787_3Braggs_J0-0','<111>');
save('J_fit_AllEi_Jtotal','Jds200K','Jds400K','Jds800K',...
    'Sds200K_100','Sds200K_110','Sds200K_111','GamDs200K_100','GamDs200K_110','GamDs200K_111',...
    'Sds400K_100','Sds400K_110','Sds400K_111','GamDs400K_100','GamDs400K_110','GamDs400K_111',...    
    'Sds800K_100','Sds800K_110','Sds800K_111','GamDs800K_100','GamDs800K_110','GamDs800K_111');


acolor('r'); aline('-')
Jds200K.title = 'J0 vs En; directions <100> <110> and <111> + 3 different input datasets';
dd(Jds2_1);  aline('--')
pd(Jds2_3);  aline(':')
pd(Jds2_8);
acolor('r'); aline('-')
pd(Jds4_1);  aline('--')
pd(Jds4_3);  aline(':')
pd(Jds4_8)
acolor('g'); aline('-')
pd(Jds2_11);  aline('--')
pd(Jds2_31);  aline(':')
pd(Jds2_81);
acolor('g'); aline('-')
pd(Jds2_12);  aline('--')
pd(Jds2_32);  aline(':')
pd(Jds2_82);
acolor('b'); aline('-')
pd(Jds4_11);  aline('--')
pd(Jds4_31);  aline(':')
pd(Jds4_81);
acolor('b'); aline('-')
pd(Jds4_12);  aline('--')
pd(Jds4_32);  aline(':')
pd(Jds4_82);
ly 20 40
keep_figure;

Sds2.title = 'Amplitude vs En; directions <100> <110> and <111>';
acolor('r');  aline('-')
dd(Sds2_1);   aline('--')
pd(Sds2_3);   aline(':')
pd(Sds2_8);
acolor('r');  aline('-')
pd(Sds4_1);   aline('--')
pd(Sds4_3);   aline(':')
pd(Sds4_8);

acolor('g');   aline('-')
pd(Sds2_11);   aline('--')
pd(Sds2_31);   aline(':')
pd(Sds2_81);
acolor('g');   aline('-')
pd(Sds4_11);   aline('--')
pd(Sds4_31);   aline(':')
pd(Sds4_81);

acolor('b');   aline('-')
pd(Sds2_12);   aline('--')
pd(Sds2_32);   aline(':')
pd(Sds2_82);
acolor('b');   aline('-')
pd(Sds4_12);   aline('--')
pd(Sds4_32);   aline(':')
pd(Sds4_82);
ly 0 4
keep_figure;


GamDs2_1.title = '\gamma vs En; directions <100> <110> and <111>';
acolor('r');  aline('-')
dd(GamDs2_1); aline('--')
pd(GamDs2_3); aline(':')
pd(GamDs2_8);
acolor('r');  aline('-')
pd(GamDs4_1); aline('--')
pd(GamDs4_3); aline(':')
pd(GamDs4_8);

acolor('g');  aline('-')
pd(GamDs2_11); aline('--')
pd(GamDs2_31); aline(':')
pd(GamDs2_81);
acolor('g');  aline('-')
pd(GamDs4_11); aline('--')
pd(GamDs4_31); aline(':')
pd(GamDs4_81);

acolor('b');  aline('-')
pd(GamDs2_12); aline('--')
pd(GamDs2_32); aline(':')
pd(GamDs2_82);
acolor('b');  aline('-')
pd(GamDs4_12); aline('--')
pd(GamDs4_32); aline(':')
pd(GamDs4_82);

ly 0 200
keep_figure;

% summary plots:
Jds2_8.title = 'J0 vs energy for all energy cuts';
acolor('r');  aline('-')
[~,~,l1]=dd(Jds2_8);
acolor('b');
[~,~,l2]=pd(Jds4_8);
ly 20 40
legend([l1(1),l2(1)],'J0 for Ei=200','J0 for Ei=400');
keep_figure;

Sds2_8.title = 'Amplitude vs En; directions <100> <110> and <111>';
acolor('r');  aline('-.')
[~,~,l1]=dd(Sds2_8);
aline('-');pd(Sds4_8);
acolor('g');  aline('-.')
[~,~,l2]=pd(Sds2_81);
aline('-');pd(Sds4_81);
acolor('b'); aline('-.')
[~,~,l3]=pd(Sds2_82);
aline('-');pd(Sds4_82);
ly 0 4
legend([l1(1),l2(1),l3(1)],'<100>','<110>','<111>');
keep_figure;

GamDs2_8.title = '\gamma vs En; directions <100> <110> and <111>';
acolor('r');  aline('-.')
[~,~,l1]=dd(GamDs2_8);
aline('-');pd(GamDs4_8);
acolor('g'); aline('-.')
[~,~,l2]=pd(GamDs2_81);
aline('-');pd(GamDs4_81);
acolor('b'); aline('-.')
[~,~,l3]=pd(GamDs2_82);
aline('-');pd(GamDs4_82);
ly 0 200
legend([l1(1),l2(1),l3(1)],'<100>','<110>','<111>');
keep_figure;
