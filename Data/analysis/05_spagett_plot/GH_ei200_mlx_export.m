if ~exist('src200','var')
    src200 = sqw('e:\SHARE\Fe\Data\sqw\sqw2024\Fe_ei200_align.sqw');
    src200sym = sqw('e:\SHARE\Fe\Data\sqw\sqw2024\Fe_ei200_align_sym3.sqw');    
end
hc = hor_config;
ll = hc.log_level;
hc.log_level = -2;

w2_000a = cut(src200,line_proj('offset',[0,0,1]),[-0.1,0.1],0.04,0.04,[25,35]);
plot(w2_000a);lz 0 4;keep_figure;
w2_000b = cut(src200,line_proj('offset',[0,0,1]),[-0.1,0.1],0.04,0.04,[45,55]);
plot(w2_000);lz 0 4; keep_figure;

hc.log_level = ll;
%%
hc = hor_config;
ll = hc.log_level;
hc.log_level = -2;

w2_001 = cut(src200sym,line_proj('offset',[0,0,1]),0.04,0.04,[-0.1,0.1],[95,105]);
plot(w2_001);lz 0 1; keep_figure;

w2_00 = cut(src200,line_proj(),0.04,0.04,[-0.1,0.1],[95,105]);
plot(w2_00);lz 0 1; 
keep_figure;

hc.log_level = ll;

%%
hc = hor_config;
ll = hc.log_level;
hc.log_level = -2;
liny
w2_200main = cut(src200sym,line_proj([0,1,0],[-1,0,0],'offset',[2,0,0]),0.04,[-0.1,0.1],[-0.1,0.1],[0,2,250]);
plot(w2_200main); lz 0 0.5;keep_figure;
%w22 = cut(src1400,line_proj([-1,1,0],[1,1,0],'offset',[1,-1,0]),[0.04],[-0.1,0.1],[-0.1,0.1],[0,5,500]);
%plot(w22); lz 0 1;keep_figure;

hc.log_level = ll;

%%
hc = hor_config;
ll = hc.log_level;
hc.log_level = -2;

liny
w2_200add1 = cut(src200sym,line_proj([0,1,0],[-1,0,0],'offset',[1,0,0]),0.04,[-0.1,0.1],[-0.1,0.1],[0,2,180]);
plot(w2_200add1); lz 0 0.5;keep_figure;
w2_200add2 = cut(src200sym,line_proj([1,0,0],[0,1,0],'offset',[1,1,0]),0.04,[-0.1,0.1],[-0.1,0.1],[0,2,180]);
plot(w2_200add2); lz 0 0.5;keep_figure;


hc.log_level = ll;
%%
liny
bg2_200 = cut(src200sym,line_proj([0,1,0],[-1,0,0],'offset',[2,2,0]),[0,0.02,1],[-0.1,0.1],[-0.1,0.1],[0,2,200]);
plot(bg2_200);lz 0 1; keep_figure
%bg2a_200 = cut(src200sym,line_proj([0,1,0],[-1,0,0],'offset',[1,3,0]),[0,0.02,1],[-0.1,0.1],[-0.1,0.1],[0,2,200]);
%plot(bg2a_200);lz 0 1;keep_figure;
%%
fg = cut(src200sym,line_proj([0,1,0],[-1,0,0],'offset',[2,0,0]),[0,0.02,1],[-0.1,0.1],[-0.1,0.1],[0,2,200]);
plot(fg);liny; lz 0 1; keep_figure;
w2nbg = fg - bg2_200.data;
plot(w2nbg);lz 0 1; keep_figure;
%%

bg1_200 = cut(bg2_200,[0,1],[]);
w2nbg1 = fg - replicate(bg1_200,fg);
plot(w2nbg1);lz 0 1; keep_figure;
%%
if ~exist('magi','var')
    magi = MagneticIons();
end
w2nbgc = magi.correct_mag_ff(w2nbg);
plot(w2nbgc); lz 0 1;keep_figure;

w2nbgc1 = magi.correct_mag_ff(w2nbg1);
plot(w2nbgc1); lz 0 1;keep_figure;