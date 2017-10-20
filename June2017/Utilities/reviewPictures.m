function fh=reviewPictures(fh)
% interactively review set of images


p = prompt(fh);
while p ~= 'q'
    switch p
        case 'h'
            fh = fh.hide_n_fig();
        case 's'
            fh = fh.show_n_fig();
        case 'r'
            fh = fh.replot_figs();
        case 'q'
            break
        otherwise
            disp('invalid input')
    end
    p = prompt(fh);
end


function res = prompt(fh)
fprintf('Nfig: %d, hidden %d; Select: h - hide screen; s - show screen; r - replot; q - quit\n',...
    fh.fig_count,fh.n_hidden_fig);
res = input('?: ','s');
res = lower(res);
