function Iliad (sample_runno, ei, wbvan_runno, mask_runno, monovan_runno, d_rebin,...
                monovan_wbvan_runno, monovan_mask_runno)
% Simplified interface to data reduction on Merlin, MAPS, MARI and LET
%
%   >> iliad (sample_run, ei, wb_van_run)
%           Sample run can be a single run number or to add several run give an array of
%          run numbers.
%           The output spe file will be named according to the first run number in the list
%
%   >> iliad (sample_run, ei, wb_van_run, mask_run)
%           If mask run number is omitted, or is empty, then the sample_run number is used
%           In this instance, the first sample run number is used to make/retrieve the mask file
%
%   >> iliad (sample_run, ei, wb_van_run, mask_run, mono_van_run)
%           Perform absolute normalisation
% 
%   >> iliad (sample_run, ei, wb_van_run, mask_run, mono_van_run, d_rebin)
%           Specify the energy transfer range and bin size (default is otherwise [-0.15*ei 0.01*ei 0.95*ei])
%           Set monovan run number = [] if absolute normalisation not required
%             e.g.   iliad (1434, 50, 1390, [], [], [-20,0.5,45])
% 
%
% Absolute normalisation of older MAPS data:
% --------------------------------------------
%   Prior to October 2008 it was common to perform the monochromatic vanadium run with a different
%   spectra.dat, together with the accompanying white beam vanadium run. If absolute normalisation
%   is to be performed, then the white beamm run for the different spectra.dat needs to be passed to
%   Iliad. If it is not given then it is assumed that the sample white beam vanadium run applies
%
%   Syntax for older maps data:
%   >> iliad (sample_run, ei, wb_van_run, mask_run, mono_van_run, d_rebin, monovan_wb_van_run)
%           White beam run for monochromatic vanadium run. If the default energy bins are required
%           for output spe file, just put []
%             e.g.   iliad (6603, 80, 6636, [], 6652, [], 6660)
%   >> iliad (sample_run, ei, wb_van_run, mask_run, mono_van_run, d_rebin, monovan_wb_van_run, monovan_mask_runno)
%           Use mask file for monochromatic vanadium from a different run. If omitted or is empty,
%           the monochromatic vanadium run number is used
%             e.g.   iliad (6603, 80, 6636, [], 6652, [-20,0.5,75], 6660 6650)
%
%
% NOTES:
%   If you want to recompute the white beam run or mask file then you must delete these from the output
%   directories.

% T.G.Perring August 2008, Inspired by Rob Bewley's original Iliad
% T.G.Perring March 2010, Incorporate tube 'bleed' masking based on Rob's test routine.
% T.G.Perring June 2010, Extend to include older MAPS data absolute intensity scale calibration
%                        Include various changes made by R.A.Ewings for Melehan
%
% To do:
% (1) 'clean' option - recompute all mask, monovan files
% (2) Write out monochromatic vanadium sum just as as do for mask and white beam files

% =================================================================================================
% =================================================================================================
% User setup:
% =================================================================================================

% ----------------------------
% Set sample map file(s):
% ----------------------------
% (Can comment out entirely - in which case the sample Homering will not be performed. Useful to
% simply create a mask file)

sample_map_file = {...
    '4to1_065.map'...                           % cycle specific mapping for MAPS
%    '4to1.map'...                              % standard mapping for MAPS
%    '4to1_mid_lowang.map'...                   % map middle of tubes to a workspace, for the low angle banks (10 of them)
%    'mid_tubes_mid_lowang.map',...             % map middle of tubes to a workspace, for the low angle banks (14 of them)
                                                % (only for runs with mid_tubes spectra.dat)
    };

% ----------------------------------------------------------------
% Background range for diag, vanadium integration range
% ----------------------------------------------------------------
% (Background: bmin and bmax. If comment out:  default will be bmin=12000 and bmax=18000)

%if ei==60          % 60meV 250Hz
%    bmin=13000; bmax=19000;
%end


% Vanadium integration range: v_int. (If comment out: default will be v_int=[-0.4,0.7]*ei)
%v_int=[-0.4,0.7]*ei;  % vanadium integral range as fraction of ei


% ----------------------------------------------
% Give sample mass and relative molecular mass
% ----------------------------------------------
% (Only needed if absolute units required)

sample_mass = 166;          % the mass of the sample.
sample_rmm  = 53.94;        % Mass per mole of 54Fe atoms

% sample_mass = 30.1;       % Mass of MAPS vanadium standard
% sample_rmm  = 50.9415;    % vanadium RMM


% ----------------------
% Hard mask file name
% ----------------------
% Put in your user_input area defined below if want to look there prior to instrument default locations
% (Can be commented out if no hard mask file needed, or equivalently set hard_mask = '')

hard_mask = '4to1_065.msk'; % appropriate for MAPS 4to1 mapping


% -------------------------------
% Correct for Bragg 'bleed'
% -------------------------------
% (Note that, as of April 2010, bleed correction is only available for Merlin)

%correct_bleed = true;       % set to false if you do not wish to perform this correction


% -----------------------------------------
% Override detector information in raw file
% -----------------------------------------
% Put in your user_input area defined below if want to look there prior to instrument default locations
% (Can be commented out or set to empty string '' if want to use the detector data from the raw file)

detector_info_file = 'detector_065.nxs';    % comment out if not required


% ----------------------------------
% Set user-defined file locations
% ----------------------------------

% Folder where user wants to read input map, mask files ahead of looking in any instrument default folder(s):
% -----------------------------------------------------------------------------------------------------------
% (Can be character string or cell array of character strings; comment out or set ='' to omit)

%user_input  = 'c:\data\aaa_raw';  
%user_input  = '/home/tgp98/Toby/instrument_files';  
user_input  ='';
  
% Folder where user wants output to be written (.sum, .msk and .spe files):
% -------------------------------------------------------------------------
% (Can be character string or cell array of character strings; comment out or set ='' to omit)

%user_output = 'T:\experiments\Fe\spe'; %replace this with your own spe directory
user_output = [pwd,'/EI800'];

% Folder where raw data is to be found:
% --------------------------------------
% (Location of raw data files. This MUST be given)

%data_source = {'c:\data\aaa_raw'};
%data_source  = '/archive/ndxmaps/Instrument/data/cycle_06_5';
data_source   = [pwd,'/EI800'];


% =================================================================================================
% =================================================================================================

% =================================================================================================
% Instrument specific setup - alter according to MAPS, MERLIN etc.
% =================================================================================================
% Detector and monitor map files
% ------------------------------
% Defaults with libisis from beginning:
% -------------------------------------
%   4to1.map                                % 1-to-1 mapping of spectra to workspaces
%   4to1_mid_lowang.map                     % 10 workspaces, one per bank, central half of each tube
%   maps_monitors.map
%
% Note that for mid-tubes spectra.dat the map files have incorrect or inconsistent naming
%(implies 1-to-1 mapping or only the 10 low angle banks included, respectively)
%
%   mid_tubes.map                           % for mid-tubes spectra.dat: 14 workspaces, one per bank
%                                           % *** wanted 576 workspaces, one per spectrum!
%   mid_tubes_mid_lowang.map                % for mid-tubes spectra.dat: 14 workspaces, one per bank
%                                           % *** wanted only the 10 low angle banks workspaces!
%   maps_mid_tubes_monitors.map
%
% Calibrated files: (where <cycle> is e.g. '095' for 5th cycle of year 9)
% -----------------------------------------------------------------------
% Map files may contain changes in the order of spectra to account for reveral of tubes, some tubes swapped etc.
% when mapping the correct virtual detector array. The corresponding phx and par files also reflect this
% reordering, so only use the coresponding phx and par files
% The monitors have had the smae psectrum numbers for 4to1 (41473,41474,41475) and mid-tubes (577,578,579) since
% cycle 003. We continue to use the same monitor map files as the original defaults.
%
%   4to1_<cycle>.map                        % 1-to-1 mapping of spectra to workspaces
%   4to1_mid-banks-low-ang_<cycle>.map      % 10 workspaces, one per bank, central half of each tube
%   monitors_4to1.map
%
%   mid-tubes_<cycle>.map                   % for mid-tubes spectra.dat: 1-to-1 mapping of spectra to workspaces 
%   mid-tubes_mid-banks-low-ang_<cycle>.map % for mid-tubes spectra.dat: 10 workspaces, one per low angle bank
%   monitors_mid-tubes.map



% Monitor map for sample runs
% ----------------------------
monitor_map='inst_maps:::maps_monitors.map';


% Monochromatic vanadium map file and monitor map for mono van runs
% -----------------------------------------------------------------
if nargin<7 % monochromatic vanadium assumed to have same white beam vanadium file as sample, assumed to be 4to1
    monovan_map='inst_maps:::4to1_mid_lowang.map';
    monovan_monitor_map='inst_maps:::maps_monitors.map';
else        % different; assumed to be old monochromatic normalisation with mid-tubes spectra.dat
    monovan_map='inst_maps:::mid_tubes_mid_lowang.map';
    monovan_monitor_map='inst_maps:::maps_mid_tubes_monitors.map';
end


% Instrument name:
% ----------------
inst_abrv_name = 'MAP';
inst_full_name = 'MAPS';

% Vanadium standard:
vanadium_mass = 30.1;       % Mass of MAPS vanadium standard
vanadium_rmm  = 50.9415;    % vanadium RMM

% spe file output type
% ---------------------
% The possibilities are 0 -- ASCII, 1 -- hdf, 2 -- both.
spe_output_type = 0;


% =================================================================================================
% Instrument independent - alter with caution
% =================================================================================================
% Set instrument specific paths and constants
% (I think this is the same thing: get(homer_config,'instr_config_folder') )
libisis_root = fileparts(which('libisis_init.m'));     % root directory of libisis instrument files
instrument_files = parse_path([libisis_root,'/../InstrumentFiles/',lower(inst_full_name)]);
instrument_files = [instrument_files,filesep];

if exist('user_input','var')&&~isempty(user_input)
    user_input=cellstr(user_input);
    mapdir= [user_input(:), instrument_files];
    maskdir=[user_input(:), instrument_files];
    nexdir= [user_input(:), instrument_files];
else
    mapdir= instrument_files;
    maskdir=instrument_files;
    nexdir= instrument_files;
end

if exist('user_output','var')&&~isempty(user_output)
    user_output=cellstr(user_output);
    data_source=cellstr(data_source);
    datadir=[user_output(:), data_source(:)];
else
    user_output=cellstr(pwd);
    data_source=cellstr(data_source);
    datadir=[user_output(:), data_source(:)];
end


% =================================================================================================
% Instrument setup - alter with caution
% =================================================================================================
setup_instrument_data_sources(datadir,mapdir,nexdir,maskdir,inst_abrv_name);
feval(['setup_',lower(inst_full_name),'_homer_defaults']);
feval(['setup_',lower(inst_full_name),'_diag_defaults']);
dso=feval(['setup_',lower(inst_full_name),'_data_source']);

% Override the detector calibration in the raw file:
if exist('detector_info_file','var') && ~isempty(detector_info_file)
    dso=add_item(dso,['inst_nxs:::',detector_info_file],'detector','full_reference_detector');
end


% =================================================================================================
% Argument checks - alter with caution
% =================================================================================================
if exist('sample_map_file','var') && ~isempty(sample_map_file)
    if iscell(sample_map_file)
        sample_map=cell(1,numel(sample_map_file));
        for i=1:numel(sample_map_file)
            sample_map{i}=['inst_maps:::',sample_map_file{i}];
        end
    else
        sample_map{1}=['inst_maps:::',sample_map_file];
    end
    n_map_files = numel(sample_map);
else
    disp('WARNING: No map file given - no Homering will be performed')
    n_map_files = 0;
end


% Check incident energy
if ~isnumeric(ei) || ei<1e-4
    error('Incident energy must be positive number')
end

% Get run numbers as a five character string, padded with zeros at front if necessary
if isnumeric(sample_runno)
    [sample_runno_char,ok,mess]=Iliad_get_run_string(sample_runno);
    if ~ok, error(['Sample: ',mess]), end
else
    error('Sample run number must be a number or array of run numbers to be added')
end

if isnumeric(wbvan_runno)
    [dummy_runno_char,ok,mess]=Iliad_get_run_string(wbvan_runno);
    if ~ok, error(['Sample white beam vanadium: ',mess]), end
else
    error('White beam run number must be a number or array of run numbers to be added')
end

if exist('mask_runno','var') && ~isempty(mask_runno)
    if isnumeric(mask_runno)
        [dummy_runno_char,ok,mess]=Iliad_get_run_string(mask_runno);
        if ~ok, error(['Sample masking run given: ',mess]), end
    else
        error('If present, sample masking run number must be a number or array of run numbers to be added')
    end
else
    disp('Using sample run number(s) as sample masking run number(s)')
    mask_runno = sample_runno;
end

if exist('monovan_runno','var') && ~isempty(monovan_runno)
    if isnumeric(monovan_runno)
        [dummy_runno_char,ok,mess]=Iliad_get_run_string(monovan_runno);
        if ~ok, error(['Monochromatic vanadium run given: ',mess]), end
    else
        error('If present, monochromatic vanadium run number must be a number or array of run numbers to be added')
    end
    monovan_runno_present = true;
else
    disp('No absolute normalisation will be performed')
    monovan_runno_present = false;
    if exist('monovan_wbvan_runno','var')
        error('Check arguments: monochromatic vanadium white beam run given, but no monochromatic vanadium run')
    end
    if exist('monovan_mask_runno','var')
        error('Check arguments: monochromatic vanadium mask run given, but no monochromatic vanadium run')
    end
end

if exist('monovan_wbvan_runno','var') && ~isempty(monovan_wbvan_runno)
    if isnumeric(monovan_wbvan_runno)
        [dummy_wbvan_runno_char,ok,mess]=Iliad_get_run_string(monovan_wbvan_runno);
        if ~ok, error(['Monochromatic vanadium white beam run given: ',mess]), end
    else
        error('If present, monochromatic vanadium white beam run number must be a number or array of run numbers to be added')
    end
else
    disp('Using sample white beam vanadium run number(s) as monochromatic vanadium white beam run number(s)')
    monovan_wbvan_runno = wbvan_runno;
end

if exist('monovan_mask_runno','var') && ~isempty(monovan_mask_runno)
    if isnumeric(monovan_mask_runno)
        [dummy_runno_char,ok,mess]=Iliad_get_run_string(monovan_mask_runno);
        if ~ok, error(['Monochromatic vanadium masking run given: ',mess]), end
    else
        error('If present, monochromatic vanadium masking run number must be a number or array of run numbers to be added')
    end
else
    disp('Using monochromatic vanadium run number(s) as monochromatic vanadium mask run number(s)')
    monovan_mask_runno = monovan_runno;
end

% Check energy transfer bins, if they have been provided.
if exist('d_rebin','var')
    if isnumeric(d_rebin) && isvector(d_rebin) && numel(d_rebin)==3
        if d_rebin(1)>=d_rebin(3) || d_rebin(2)<=0
            error('Check energy binning ')
        end
    else
        error('Energy bins must be a vector [eps_lo, d_eps, eps_hi]')
    end
else
    disp('Using default energy bin boundaries: -0.15*Ei : 0.01*Ei : 0.95*Ei')
    d_rebin=[-0.15*ei 0.01*ei 0.95*ei];   % output rebinning in energy transfer
end

% Set defaults for mask background, hard mask files and bleed correction as required
if ~exist('bmin','var'), bmin=12000; end
if ~exist('bmax','var'), bmax=18000; end
if bmax<bmin, error('Check background ranges'), end

if ~exist('hard_mask','var')||isempty(hard_mask), hard_mask=[]; end
monovan_hard_mask = hard_mask;  % for most situations; special case of MAPS mid_tubes looked after in Iliad_get_mask_file

if ~exist('correct_bleed','var')||isempty(correct_bleed), correct_bleed=false; end
monovan_correct_bleed=false;    % should not have any bleed on monovan

if ~exist('v_int','var')
    v_int=[-0.4,0.7]*ei;  % vanadium integral range as fraction of ei
end

chopper='sloppy';   % Presently only need any valid chopper to ensure homer works

%==================================================================================================
% Perform calculations
%==================================================================================================
disp(' ')
disp(' ')
disp('=================================================================================================')
disp('*************************************************************************************************')
disp('=================================================================================================')
disp('==                                                                                             ==')
disp('==                                     Homer data                                              ==')
disp('==                                                                                             ==')
disp('=================================================================================================')
disp('*************************************************************************************************')
disp('=================================================================================================')
disp(' ')

%==================================================================================================
% Sample whitebeam vanadium integrals
% ---------------------------------------
% Create white beam file only if not already performed
disp('=================================================================================================')
disp('Sample whitebeam vanadium integrals')
disp('-----------------------------------')

tic
wbvan_integrals = Iliad_get_wb_integrals (dso, inst_abrv_name, wbvan_runno);
time=toc;

disp('-------------------------------------------------------------------------------------------------')
disp(['   Sample white beam integrals obtained  (elapsed time: ',num2str(time),' sec)'])
disp('-------------------------------------------------------------------------------------------------')
disp(' ')


%==================================================================================================
% Sample mask file creation
% ---------------------------------------
% Create mask file only if not already performed
disp('=================================================================================================')
disp('Sample mask file creation')
disp('-------------------------')

tic
mask_list=Iliad_get_mask_file(dso, inst_abrv_name, mask_runno, wbvan_integrals, [bmin,bmax], hard_mask, correct_bleed);
time=toc;

disp('-------------------------------------------------------------------------------------------------')
disp(['   Sample masked detector list obtained  (elapsed time: ',num2str(time),' sec)'])
disp('-------------------------------------------------------------------------------------------------')
disp(' ')


% =================================================================================================
% Get monochromatic vanadium normalisation
% -----------------------------------------
% There is no need to run diagnose on the monochromatic vanadium run since
% the same wiring has been used for the sample run and the same spectra should be masked

disp('=================================================================================================')
disp('Monochromatic vanadium: absolute units calibration')
disp('--------------------------------------------------')

if monovan_runno_present
    tic
    % Create white beam file only if not already performed; if wbvan run is same as for sample, just copy pointer
    if ~isequal(wbvan_runno,monovan_wbvan_runno)
        monovan_wbvan_integrals = Iliad_get_wb_integrals (dso, inst_abrv_name, monovan_wbvan_runno);
        disp(' ')
    else
        monovan_wbvan_integrals = wbvan_integrals;
    end

    % Create mask file
    if ~isequal(mask_runno,monovan_mask_runno)
        monovan_mask_list = Iliad_get_mask_file(dso, inst_abrv_name, monovan_mask_runno, monovan_wbvan_integrals,...
                                               [bmin,bmax], monovan_hard_mask, monovan_correct_bleed);
        disp(' ')
    else
        monovan_mask_list = mask_list;
    end
    
    % Get absolute normalisation factor
    monovan_integrals_file=['inst_data:::', inst_abrv_name, Iliad_get_run_string(monovan_runno), '.sum'];
    if exist(translate_read(monovan_integrals_file),'file')
        disp(['Reading monovan integrals file ',translate_read(monovan_integrals_file)])
        monovan_integrals=read_nxs(IXTrunfile,monovan_integrals_file);
    else
        disp ('Evaluate monovan integrals...')
        % Note: monovan_integrals is an IXTrunfile object
        monovan_integrals=mono_van(dso,chopper,monovan_runno,'ei',ei,'noback',...
            'det_map',monovan_map,'det_mask',monovan_mask_list,'mon_map',monovan_monitor_map,...
            'solid',monovan_wbvan_integrals,'d_int',v_int,'corr','abs',1,'mass',vanadium_mass,'RMM',vanadium_rmm);
        write_nxs(monovan_integrals,monovan_integrals_file)
        disp(' ')
    end
    abs_norm_factor=monovan_abs(monovan_integrals);
    
    disp(['     Monochromatic vanadium energy integration range = [',num2str(v_int),']'])
    disp(['     Absolute normalisation factor = ',num2str(abs_norm_factor)])
    disp(' ')
    
    time=toc;
    disp('-------------------------------------------------------------------------------------------------')
    disp(['   Absolute normalisation factor obtained  (elapsed time: ',num2str(time),' sec)'])
    disp('-------------------------------------------------------------------------------------------------')
    disp(' ')
end

% =================================================================================================
% Homer, optionally with absolute units
% --------------------------------------

disp('=================================================================================================')
disp('Homering sample runs')
disp('------------------------------')


set(homer_config,'use_hdf',spe_output_type);
    
for i=1:n_map_files
    tic
    disp(['Performing Homer on sample run for map file ',num2str(i), ' of ', num2str(n_map_files),'...'])
    disp(['  Energy bins: ',num2str(d_rebin(1)),'(',num2str(d_rebin(2)),')',num2str(d_rebin(3))])
    
    if monovan_runno_present
        final_output = mono_sample(dso,chopper,sample_runno,'ei',ei,'noback','d_rebin',d_rebin,...
            'det_map',sample_map{i},'det_mask',mask_list,'mon_map',monitor_map,...
            'solid',wbvan_integrals,'corr','abs',abs_norm_factor,'mass',sample_mass,'RMM',sample_rmm);
    else
        final_output = mono_sample(dso,chopper,sample_runno,'ei',ei,'noback','d_rebin',d_rebin,...
            'det_map',sample_map{i},'det_mask',mask_list,'mon_map',monitor_map,...
            'solid',wbvan_integrals,'corr');
    end
    time=toc;

    disp('-------------------------------------------------------------------------------------------------')
    disp(['   Homer run on sample data  (elapsed time: ',num2str(time),' sec)'])
    if n_map_files>1
        disp(['   for map file ',num2str(i), ' of ', num2str(n_map_files)])
    end
    disp('-------------------------------------------------------------------------------------------------')
    disp(' ')

    % Write out the SPE file
    disp('Write out the SPE file...')
    [dummy,map_name]=fileparts(sample_map_file{i});
    spe_out=['inst_data:::', inst_abrv_name, sample_runno_char,'_',map_name, '.spe'];
    runfile2spe(final_output,spe_out);
    
%     rf_out=['inst_data:::', inst_abrv_name, sample_runno_char,'_',map_name, '.nxs'];
%     write_nxs(rf_out,final_output)

end


% ==================================================================================================
% ==================================================================================================
function mask_list=Iliad_get_mask_file(dso,inst_abrv_name,mask_runno,wbvan_runno,bkgd,hard_mask,bleed_correct)
% Return list of bad detectors, reading from file if exists, and write to file if doesn't already exist
%
%   >> mask_list=get_mask_file(dso,inst_abrv_name,mask_runno,bkgd,hard_mask,bleed_correct)
%
% Input:
% ------
%   dso             Data source object
%   inst_abrv_name  Abbreviated instrument name e.g. MAP, MER, MAR
%   mask_runno      Run number (or array of run numbers, if several to be added) to mask
%
% If the mask file does not already exist, the following will be used:
%
%   wbvan_runno     White beam vanadium run number (or array of numbers if several to be added)
%              *OR* IXTrunfile object containing white beam integrals from calling white_beam
%
%   bkgd            Background limits for determining bad detectors e.g. [14000,16000]
%   hard_mask       Hard mask file
%                   - name of hard mask file e.g. '4to1_022.msk' (the file must be uin inst_data:::)
%                   - [] to ignore
%   bleed_correct   Logical flag to indicate if bleed corrections are to be performed
%                   - true or 1  to perform correction (MERLIN only)
%                   - false or [] to ignore
%                   
% Output:
% -------
%   mask_list       Array of spectra to ignore
%                   Results are written to NeXus file, if file does not already exist


% Check input
if isnumeric(mask_runno)
    mask_runno_char=Iliad_get_run_string(mask_runno);
else
    error('Mask run must be a number or array of run numbers')
end

% *** Fixup to catch older MAPS data using mid-tubes mapping
% Need to find case of MAPS mid-tubes mapping, remove bank information, and remove any hard mask
% Just check the first run in a list - if the number of spectra do not match in an array of runs, we'll just let libisis blow up later
rpath = make_path_from_par(mask_runno(1));
rfileobj=IXTraw_file(rpath);
nsp=gget(rfileobj,'nsp1');
if strcmpi(inst_abrv_name,'MAP') && nsp<600
    hard_mask='';   % override any hard mask input
    no_banks=true;  % ensure no banks will be used
else
    no_banks=false;
end
        
% Create mask file only if not already created
mask_file=['inst_data:::', inst_abrv_name, mask_runno_char, '.msk'];
if exist(translate_read(mask_file),'file')
    disp(['Reading mask file ',translate_read(mask_file)])
    mask_list=read_nxs(mask_file,IXTmask);               % mask file will have been written as nxs file
else
    disp(['Creating mask and saving to file ' translate_write(mask_file)]);
    
    % Create list of white beam integrals
    if isa(wbvan_runno,'IXTrunfile')
        wb_integrals=wbvan_runno;
    else
        disp(' ')
        wb_integrals=get_wb_integrals (dso, inst_abrv_name, wbvan_runno);
        disp(' ')
    end
    
    % Get hard masked spectra if required
    if exist('hard_mask','var') && ~isempty(hard_mask)
        hard_mask_file=translate_read(['inst_masks:::', hard_mask]);
        disp(['Reading mask file ',translate_read(hard_mask_file)])
        if exist(hard_mask_file,'file')
            tmp=read_ascii(IXTmask,hard_mask_file);     % hard mask file assumed to be ASCII
            hard_mask_list=double(tmp.mask_array);
        else
            error(['Hard mask file ',hard_mask_file,' does not exist'])
        end
    else
        hard_mask_list=[];
    end
    
    % Perform bleed correction if required
    if exist('bleed_correct','var') && ~isempty(bleed_correct) && logical(bleed_correct)
        disp('Performing detector bleed correction')
        if strcmpi(inst_abrv_name,'MER')
            hard_mask_list=Iliad_mask_tube_bleed_merlin(dso,mask_runno,hard_mask_list);
        else
            error('Bleed correction only implemented for MERLIN')
        end
    end
    
    % Create list of spectra to mask, and write to file

    if no_banks
        if ~isempty(hard_mask_list)
            hard_mask_obj=IXTmask(hard_mask_list);
            mask_list=diagnose(dso,mask_runno,wb_integrals,'hardmask',hard_mask_obj,'nobank',...
                'bmin',bkgd(1),'bmax',bkgd(2),'out_nex',mask_file);
        else
            mask_list=diagnose(dso,mask_runno,wb_integrals,'nohardmask','nobank',...
                'bmin',bkgd(1),'bmax',bkgd(2),'out_nex',mask_file);
        end
    else
        if ~isempty(hard_mask_list)
            hard_mask_obj=IXTmask(hard_mask_list);
            mask_list=diagnose(dso,mask_runno,wb_integrals,'hardmask',hard_mask_obj,...
                'bmin',bkgd(1),'bmax',bkgd(2),'out_nex',mask_file);
        else
            mask_list=diagnose(dso,mask_runno,wb_integrals,'nohardmask',...
                'bmin',bkgd(1),'bmax',bkgd(2),'out_nex',mask_file);
        end
    end
end


% ==================================================================================================
% ==================================================================================================
function [run_str,ok,mess]=Iliad_get_run_string(input)
% Get run number as a five character string, padded with zeros at front if necessary
% If given an array of run numbers, checks that all numbers are valid, and return the
% character string for the first run in the list


% Check that all run numbers are correct
run_str='';
ok=true;
mess='';
if ~isnumeric(input), error(mess), end
if numel(input)<1
    mess='Run number argument is empty';
    if nargout>1
        ok=false;
        return
    else
        error(mess)
    end
end
if any(input<0)||any(input>99999)||any(input-floor(input)~=0)
    mess='Run numbers must be positive integers in the range 0 - 99999';
    if nargout>1
        ok=false;
        return
    else
        error(mess)
    end
end

% Get character string
if input(1) < 10
    run_str=strcat('0000',sprintf('%.0f',round(input(1))));
elseif input(1) < 100
    run_str=strcat('000',sprintf('%.0f',round(input(1))));
elseif input(1) < 1000
    run_str=strcat('00',sprintf('%.0f',round(input(1))));
elseif input(1) < 10000
    run_str=strcat('0',sprintf('%.0f',round(input(1))));
elseif input(1) < 100000
    run_str=sprintf('%.0f',round(input(1)));
end


% ==================================================================================================
% ==================================================================================================
function wb_integrals = Iliad_get_wb_integrals (dso, inst_abrv_name, wbvan_runno)
% Return white beam vanadium integrals, writing to file if not already written.
%
%   >> wb_integrals = get_wb_integrals (dso, inst_abrv_name, wbvan_runno)
%
% Input:
% ------
%   dso             Data source object
%   inst_abrv_name  Abbreviated instrument name e.g. MAP, MER, MAR
%   wbvan_runno     White beam vanadium run number (or array of numbers if several to be added)
%                   
% Output:
% -------
%   wb_integrals    IXTrunfile object containing white beam integrals
%                   Results are written to NeXus file, if file does not already exist

% Check input
if isnumeric(wbvan_runno)
    wbvan_runno_char=Iliad_get_run_string(wbvan_runno);
else
    error('Run number must be a number or array of run numbers')
end

% Create white beam file only if not already performed
wbvan_file=['inst_data:::', inst_abrv_name, wbvan_runno_char, '.sum'];
if exist(translate_read(wbvan_file),'file')
    disp(['Reading white beam vanadium file ',translate_read(wbvan_file)])
    wb_integrals=read_nxs(wbvan_file,IXTrunfile);
else
    disp(['Creating white beam sum and saving to file ' translate_write(wbvan_file)]);
    wb_integrals = white_beam(dso,wbvan_runno);
    write_nxs(wbvan_file,wb_integrals);
end


% ==================================================================================================
% ==================================================================================================
function mask_list_out=Iliad_mask_tube_bleed_merlin(dso,run,mask_list_in)
% Create mask file that removes 'bleed' from Bragg peaks on Merlin
% Assumes that all 9 doors are present
%
%   >> [map_bottom,map_top]=merlin_tube_rate(dso,run,mask)
%
% Input:
% ------
%   dso             Data source object (as taken by homer, for example)
%   run             One or more runs
%   mask_list_in    [Optional] list of masked spectra to which to accumulate the 'bleed' masking
%
% Output:
% -------
%   mask_list_out   List of masked spectra with those masked by bleeding added
%
%
% Assumes the full 4to1 detector <-> spectrum mapping
% Works if multiple runs to be added together
%  e.g. if run=[6589,6599]
%
% based on the original test program of R.I.Bewley
% T.G.Perring   18 March 2010


max_rate=0.01;  % max rate allowed on a tube in counts/us/frame
npix_middle=80; % number of bins in the middle of the tube not to include in tube rate

len_long=2.9;
len_short=1.234;

% Make cell arrays of spectra from which to construct map files
npix_long=round(128-npix_middle/2);
npix_short=min(round(npix_long*(len_long/(2*len_short))),128);
[map_bottom,map_top,map_whole_tube]=make_bleed_masks(npix_long,npix_short);

% Check that the run(s) have the correct number of spectra
rpath = make_path_from_par(run);
for i=1:numel(rpath)
    if gget(IXTraw_file(rpath{i}),'nsp1')<69632
        disp('WARNING - run(s) do not have 4to1 detector-to-spectrum mapping - bleed correction ignored')
        if exist('mask_list_in','var')
            mask_list_out=mask_list_in; % just pass any input mask file straight on unchanged
        end
        return
    end
end

% Read in the signal
rf=spec(dso,run,'det_map',IXTmap(map_bottom));
good_frames=double(rf.total_good_frames);
s_bot=rf.det_data.datasets.signal;
clear rf    % to save space

rf=spec(dso,run,'det_map',IXTmap(map_top));
s_top=rf.det_data.datasets.signal;
clear rf    % to save space

% Find maximum count-rate in each tube in the bottom and top sections
s_max=max(s_bot+s_top)/good_frames;

% Create list of spectra to be masked - the whole tube if 'bleed' is suspected
mask_list_out=cell2mat(map_whole_tube(s_max>max_rate));
if exist('mask_list_in','var')
    mask_list_out=[mask_list_in(:)',mask_list_out];
end
mask_list_out=unique(mask_list_out);    % sort and remove repeated mask entries



%==================================================================================================
function [map_bottom,map_top,map_whole_tube]=make_bleed_masks(npix_long,npix_short)
map_bottom=cell(1,280);
map_top=cell(1,280);
map_whole_tube=cell(1,280);
noff=0;
for i=1:64
    map_bottom{i}=noff+1:noff+npix_long;
    map_top{i}=noff+257-npix_long:noff+256;
    map_whole_tube{i}=noff+1:noff+256;
    noff=noff+256;
end
for i=65:80
    map_bottom{i}=noff+1:noff+npix_short;
    map_top{i}=noff+129-npix_short:noff+128;
    map_whole_tube{i}=noff+1:noff+128;
    noff=noff+128;
end
for i=81:280
    map_bottom{i}=noff+1:noff+npix_long;
    map_top{i}=noff+257-npix_long:noff+256;
    map_whole_tube{i}=noff+1:noff+256;
    noff=noff+256;
end
