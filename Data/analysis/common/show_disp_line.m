function show_disp_line
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Create the main window
ui_fig = uifigure('Name', 'Plot Dispersion', ...
    'Position', [500 500 400 180]);

uilabel(ui_fig, ...
    'Text', 'gamma,Seff, gap, J0,  J1, J2,   J3, J4, J5', ...
    'Position', [50 125 300 22]);
% Textbox
if isfile('show_disp_line_settings.mat')
    ld = load('show_disp_line_settings.mat');
    init_settings = ld.textValue;
else
    init_settings = '10,     1,   0, 25, 10, -5, 10, 1, 10';
end
editBox = uieditfield(ui_fig, 'Text', ...
    'Value',init_settings,...
    'Position', [50 90 300 30]);

% OK button
okButton = uibutton(ui_fig, 'push', ...
    'Text', 'OK', ...
    'Position', [160 30 80 30], ...
    'ButtonPushedFcn', @(src,event)okPressed(editBox));
%
% React to keyboard events
ui_fig.WindowKeyPressFcn = @(src,event) keyPressed(event, editBox);
focus(editBox);
end

function keyPressed(event, editBox)

if strcmp(event.Key, 'return')
    okPressed(editBox);
end

end

function okPressed(editBox)
% Callback executed when OK is pressed

[fg,pl_pannels]  = build_or_show_spaghetty();
% Read contents of textbox
textValue = editBox.Value;
param = str2double(strsplit(textValue, ','));
ax = fg.CurrentAxes;
ax.Title.String = textValue;
save('show_disp_line_settings.mat',"textValue");
%
build_and_show_dispersion_model(fg,pl_pannels,param)

end
