function show_disp_line_with_sliders()
%--------------------------------------------------------------
% Main figure
%--------------------------------------------------------------
%--------------------------------------------------------------
% Layout parameters
%--------------------------------------------------------------
figWidth = 600;         % Main window width
minFigHeight = 250;     % Minimum main window height

panelMargin = 20;       % Margin around slider panel
sliderSpacing = 50;     % Vertical distance between sliders
sliderWidth = 350;      % Slider length
sliderX = 150;          % Slider horizontal position

topAreaHeight = 100;    % Textbox + OK button area
bottomMargin = 20;

%--------------------------------------------------------------
% Main figure
%--------------------------------------------------------------
fig = uifigure( ...
    'Name', 'Variable Slider GUI', ...
    'Position', [100 100 figWidth minFigHeight]);
% Text explaining the edit box
uilabel(fig, ...
    'Position', [30 minFigHeight-50 540 22], ...
    'Text', 'Enter set of values in the form Name1:min1,max;Name2:min2,max2;... separated by semicolon');

if isfile('show_disp_line_wit_sliders_settings.mat')
    ld = load('show_disp_line_wit_sliders_settings.mat');
    init_settings = ld.textValue;
else
    init_settings   = ['gamma:10,20,100;' ...
        ' Seff:0.1,2; gap:0,0,10; J0:10,30,50; J1:-30,10,30;' ...
        'J2:-10,-5,30; J3:-20,10,30; J4:-10,10,10; J5:-5,1,5'];
end
% Edit box containing initial values
editBox = uieditfield(fig, 'text', ...
    'Position', [30 minFigHeight-85 400 30], ...
    'Value', init_settings );

% generate sliders button
uibutton(fig, ...
    'Position', [450 minFigHeight-85 100 30], ...
    'Text', 'Generate', ...
    'ButtonPushedFcn', @(src,event)GenerateSliders(editBox));

% Panel in which the sliders will be created
sliderPanel = uipanel(fig, ...
    'Position', [panelMargin bottomMargin ...
    figWidth-2*panelMargin 100], ...
    'Title', 'Sliders');

% Store slider handles
sliders = gobjects(0);

% Create initial sliders
GenerateSliders(editBox);
%--------------------------------------------------------------
% Callback for OK button
%--------------------------------------------------------------
    function GenerateSliders(editBox)
        [names,values] = parse_text_input(editBox);
        createSliders(names,values);
        [fg,pl_pannels]  = build_or_show_spaghetty();
        param = values(2,:);
        build_and_show_dispersion_model(fg,pl_pannels,param);
    end

%--------------------------------------------------------------
% Create sliders according to values in editBox
%--------------------------------------------------------------
    function createSliders(names,values)

        % Delete old sliders
        for i=1:numel(sliders)
            if isa(sliders(i),'matlab.ui.control.Slider') && isstruct(sliders(i).UserData)
                delete(sliders(i).UserData.nameLabel);
                delete(sliders(i).UserData.valLabel);                
            end
        end
        delete(sliders);

        % Preallocate slider handles
        n_sliders = size(values,2);
        panelHeight = max( ...
            100, ...
            n_sliders * sliderSpacing + 30);
        %----------------------------------------------------------
        % Calculate required figure height
        %----------------------------------------------------------
        figHeight = topAreaHeight + ...
            panelHeight + ...
            bottomMargin;
        figHeight = max(figHeight, minFigHeight);

        %----------------------------------------------------------
        % Resize main figure
        %----------------------------------------------------------
        fig.Position(4) = figHeight;
        %----------------------------------------------------------
        % Move controls at the top of the window
        %----------------------------------------------------------
        uilabels = findall(fig, 'Type', 'uilabel');

        % First label is the instruction label.
        % Put it near the top.
        for k = 1:numel(uilabels)
            % Do not modify labels belonging to sliderPanel
            if ~isvalid(uilabels(k).Parent) || ...
                    uilabels(k).Parent ~= fig
                continue;
            end

            pos = uilabels(k).Position;

            % Instruction label
            if contains(uilabels(k).Text, 'Enter set')
                pos(2) = figHeight - 50;
                uilabels(k).Position = pos;
                break
            end
        end

        % Move edit box
        editBox.Position(2) = figHeight - 85;
        % Move Generate button
        okButton = findall(fig, 'Type', 'uibutton');

        if ~isempty(okButton)
            okButton(1).Position(2) = figHeight - 85;
        end

        %----------------------------------------------------------
        % Resize slider panel
        %----------------------------------------------------------
        sliderPanel.Position = [ ...
            panelMargin, ...
            bottomMargin, ...
            figWidth - 2*panelMargin, ...
            panelHeight];

        sliders = gobjects(n_sliders, 1);

        for k = 1:n_sliders
            % Position from top of panel
            y = panelHeight - 40 - (k-1)*sliderSpacing;

            value = values(2,k);
            % Slider limits
            sliderMin = values(1,k);
            sliderMax = values(3,k);

            % Label showing slider number
            nameLabel = uilabel(sliderPanel, ...
                'Position', [10 y-8 100 22], ...
                'Text', sprintf('%s', names{k}));

            % Slider
            sliders(k) = uislider(sliderPanel, ...
                'Position', [sliderX y sliderWidth 3], ...
                'Limits', [sliderMin sliderMax], ...
                'Value', value);

            % Value displayed next to slider
            valueLabel = uilabel(sliderPanel, ...
                'Position', ...
                [sliderX + sliderWidth + 10 y-8 60 22], ...
                'Text', sprintf('%.3g', value));

            % Store label and additional information about slider with slider callback
            sl_indo.number = k;
            sl_indo.nameLabel  = nameLabel;
            sl_indo.valLabel   = valueLabel;
            sliders(k).UserData = sl_indo;

            % Callback when slider is moved
            sliders(k).ValueChangedFcn = @(src,event)sliderChanged(src,event,editBox);
            sliders(k).ValueChangingFcn = @(src,event)sliderChanging(src,event,editBox);
        end
    end

    function [names,values]=parse_text_input(editBox)
        text = editBox.Value;
        blocks = strsplit(text,';');
        n_sliders = numel(blocks);
        if n_sliders == 1 && isempty(blocks{1})
            uialert(fig, ...
                'Please enter at least one numeric value.', ...
                'Invalid input');
            return;
        end
        names = cell(1,n_sliders);
        values = zeros(3,n_sliders);
        for i=1:numel(blocks)
            block_info = strsplit(blocks{i},':');
            names{i} = block_info{1};
            val_s = strsplit(block_info{2},{',',' '});
            val_d = str2double(val_s);
            min_val = val_d(1);
            max_val = val_d(end);
            if numel(val_d) == 2
                mid_val = 0.5*(min_val+max_val);
            elseif numel(val_d) == 3
                mid_val = val_d(2);
            else
                uialert(fig, ...
                    'Initial slider values must be two or three numbers separated by spaces or commas', ...
                    'Invalid input');
                return;
            end
            if min_val>=max_val
                uialert(fig, ...
                    sprintf('Max slider value %d shoule be larger than min slider value %d', ...
                    max_val, min_val),...
                    'Invalid input');
                return;

            end
            values(1,i) = min_val;
            values(2,i) = mid_val;
            values(3,i) = max_val;
        end
        result.names = names;
        result.values = values;
        editBox.UserData = result;
    end
%--------------------------------------------------------------
% Slider callback
%--------------------------------------------------------------
    function sliderChanging(src,new_value, editBox)
        if ~isnumeric(new_value)
            new_value = new_value.Value;
        end
        label = src.UserData.valLabel;
        n_slider = src.UserData.number;
        label.Text = sprintf('%.3g', new_value);

        [fg,pl_pannels]  = build_or_show_spaghetty();

        values   = editBox.UserData.values;
        values(2,n_slider)      = new_value;
        editBox.UserData.values = values;
        param = values(2,:);
        build_and_show_dispersion_model(fg,pl_pannels,param);

    end

    function sliderChanged(src,~,editBox)
        sliderChanging(src,src.Value,editBox);
        change_and_save_editbox_values(editBox);
    end

    function change_and_save_editbox_values(editBox)
        res = editBox.UserData;
        names  = res.names;
        values = res.values;
        n_boxes = numel(names);
        sub_val = cell(1,n_boxes);
        for i=1:n_boxes
            sub_val{i} = sprintf('%s:%.3g,%.3g,%3g',names{i},values(:,i));
        end
        text = strjoin(sub_val,'; ');
        editBox.Value = text;
    end
end
