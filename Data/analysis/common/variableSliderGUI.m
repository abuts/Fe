function variableSliderGUI()

    %--------------------------------------------------------------
    % Parameters
    %--------------------------------------------------------------
    delta = 1.0;       % Slider half-width around each value

    %--------------------------------------------------------------
    % Main figure
    %--------------------------------------------------------------
    fig = uifigure( ...
        'Name', 'Variable Slider GUI', ...
        'Position', [100 100 600 500]);

    % Text explaining the edit box
    uilabel(fig, ...
        'Position', [30 450 540 22], ...
        'Text', 'Enter values separated by spaces or commas:');

    % Edit box containing initial values
    editBox = uieditfield(fig, 'text', ...
        'Position', [30 415 400 30], ...
        'Value', '1 3 5');

    % OK button
    uibutton(fig, ...
        'Position', [450 415 100 30], ...
        'Text', 'OK', ...
        'ButtonPushedFcn', @okPressed);

    % Panel in which the sliders will be created
    sliderPanel = uipanel(fig, ...
        'Position', [20 20 560 370], ...
        'Title', 'Sliders');

    % Store slider handles
    sliders = gobjects(0);

    % Create initial sliders
    createSliders();

    %--------------------------------------------------------------
    % Callback for OK button
    %--------------------------------------------------------------
    function okPressed(~, ~)

        createSliders();

    end

    %--------------------------------------------------------------
    % Create sliders according to values in editBox
    %--------------------------------------------------------------
    function createSliders()

        % Read values from edit box
        str = editBox.Value;

        % Allow both spaces and commas as separators
        str = strrep(str, ',', ' ');

        values = str2num(str); %#ok<ST2NM>

        % Check input
        if isempty(values)
            uialert(fig, ...
                'Please enter at least one numeric value.', ...
                'Invalid input');
            return;
        end

        values = values(:);   % Make column vector

        % Delete old sliders
        delete(sliders);

        % Preallocate slider handles
        sliders = gobjects(numel(values), 1);

        % Slider dimensions
        sliderX = 150;
        sliderWidth = 350;
        sliderHeight = 3;

        % Vertical spacing
        spacing = 50;

        for k = 1:numel(values)

            y = 310 - (k-1)*spacing;

            value = values(k);

            % Slider limits
            sliderMin = value - delta;
            sliderMax = value + delta;

            % Label showing slider number
            uilabel(sliderPanel, ...
                'Position', [10 y-8 100 22], ...
                'Text', sprintf('Value %d', k));

            % Slider
            sliders(k) = uislider(sliderPanel, ...
                'Position', [sliderX y sliderWidth 3], ...
                'Limits', [sliderMin sliderMax], ...
                'Value', value);

            % Value displayed next to slider
            valueLabel = uilabel(sliderPanel, ...
                'Position', [505 y-8 45 22], ...
                'Text', sprintf('%.3g', value));

            % Store label with slider callback
            sliders(k).UserData = valueLabel;

            % Callback when slider is moved
            sliders(k).ValueChangedFcn = @sliderChanged;
        end
    end

    %--------------------------------------------------------------
    % Slider callback
    %--------------------------------------------------------------
    function sliderChanged(src, ~)

        label = src.UserData;

        label.Text = sprintf('%.3g', src.Value);

    end

end


function values = getSliderValues()

    values = arrayfun(@(s) s.Value, sliders);

end