%source_dir = 'd:\Users\abuts\Data\Fe\2018April\EnCutsCombined_fitJ0_eachDirectionSeparate';
source_dir = 'd:\Users\abuts\Data\Fe\2018April\';
ei = [50,70,90,110,130,150,160,170];

fh = fig_spread();
for i=1:numel(ei)
    fname = sprintf('EnCuts_Fe_ei200_dE%d_dir_!100!.mat ',ei(i));
    file = fullfile(source_dir,fname);
    cb = EnCutBlock(file);
    cb.save_as_IXd();
    fg=cb.plot('-noextracted');
    fh=fh.place_fig(fg);
    Tobys_fig_prettify(fg);
end
