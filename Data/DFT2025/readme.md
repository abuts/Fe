Mon 23 Jun 15:50:05 BST 2025

LDA, conventional cell, (x0+- + x0-+)

25x25x25 q in FBZ


adc854fcc3cb3d7f3eb6bdf7dc83d0c2  chipm.h5
8d9b34c7e621e467ff09041af9129eca  chipm_rsa.fe2
1b741edae19416e3a3ecb30b0ee95a08  ctrl.fe2
1453186d08ffe4847355afb6f01243a7  log.fe2
cae8b2cb56570e450132547b55fded75  lx0pm
6dd462c70f1ce153f876870a62b951b3  rsj_x0inv.fe2
bec3baac5118999a6d522c7cb6c94e03  rsj_x0lfv.fe2
949c5fa0f2f8c6da1e50a717bcd1bcfb  syml.fe2




total 19G
-rw-------. 1 jerome jerome 105M Jun 23 08:08 chipm.h5
-rw-------. 1 jerome jerome  376 Jun 23 08:11 ctrl.fe2
-rw-------. 1 jerome jerome 2.4K Jun 23 08:11 lx0pm
-rw-------. 1 jerome jerome  807 Jun 23 09:50 syml.fe2
-rw-------. 1 jerome jerome  19G Jun 23 14:09 chipm_rsa.fe2
-rw-------. 1 jerome jerome 3.0M Jun 23 14:09 rsj_x0lfv.fe2
-rw-------. 1 jerome jerome 3.0M Jun 23 14:09 rsj_x0inv.fe2
-rw-------. 1 jerome jerome 1.1K Jun 23 14:09 log.fe2
-rw-------. 1 jerome jerome  355 Jun 23 15:47 readme.md





bz nkabc=25
gw nkabc=25 delre=0.001 ecutchi0=6.0
ham xcfun='lm_lda_ca' nspin=2 autobas[mto=14 eh=-0.25] gmax=8.0
iter convc=1e-7 mix[b7,b=0.9] nit=20
str rmaxs=18.0 env[mode=1 nel=2 el=-0.25 -0.25]
spec atom=Fe z=26 r/a={sqrt(3/4)/2} lmx=3 lmxa=5 pz=0 0 4.3 mmom=0 0 2
site
 atom=Fe pos=0 0 0
 atom=Fe pos=1/2 1/2 1/2
struc nbas=2 alat={2.867/0.529174} plat=1 0 0 0 1 0 0 0 1
