function fh=reviewPictures(fh)
% interactively review set of images


p = prompt();
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
    p = prompt();
end


function res = prompt()
fprintf('Select option: h - hide screen; s - show screen; r - replot; q - quit\n');
res = input('?: ','s');
res = lower(res);
