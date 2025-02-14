%% Configuration initializing
function settings = initSettings()
    % inputs: none
    % outputs: settings - receiver configuration struct
    
    %% Processing settings
    % number of milliseconds to be processed
    settings.msToProcess = 36000; % [ms]
    % number of channels
    settings.numberOfChannels = 8;
    % Start point of processing
    settings.skipNumberOfSamples = 0;
    settings.skipNumberOfBytes   = 0;

    %% Raw signal file name and other parameter
    % File name
    settings.fileName = "~/Users/Documents/Homework/AAE6102Project/Data/Opensky.bin";
    % settings.fileName = "~/Users/Documents/Homework/AAE6102Project/Data/Urban.bin";
    % Data type used to store one sample
    settings.dataType = 'schar';
    % File type (1 for 8 bit real samples and 2 for 8 bit I/Q samples)
    settings.fileType = 2;
    % Intermediate frequency
    settings.IF = 4.58e6;
    % Sampling frequency
    settings.samplingFreq = 58e6;
    % Code frequency
    settings.codeFreqBasis = 1.023e6;
    % Code length in one period
    settings.codeLength = 1023;

    %% Acquisition settings
    % Skip the acquisition (1) or not (0)
    settings.skipAcquisition = 0;
    % List of satellites to search
    settings.acqSatelliteList = 1:32;
    % Band around IF to search for signal
    settings.acqSearchBand = 14;
    % Threshold for the signal presence decision rule
    settings.acqThreshold = 2.5;
    % No. of code periods for coherent integration (multiple of 2)
    settings.acquisition.cohCodePeriods = 2;
    % No. of non-coherent summations
    settings.acquisition.nonCohSums = 4;
    
    %% Tracking loops settings
    % Fast tracking
    settings.enableFastTracking = 0;
    % Code tracking loop parameters
    settings.dllDampingRatio      = 0.7;
    settings.dllNoiseBandwidth    = 1; % [Hz]
    settings.dllCorrelatorSpacing = 0.5; % [Chips]
    % Carrier tracking loops parameters
    settings.pllDampingRatio   = 0.7;
    settings.pllNoiseBandwidth = 6.5; % [Hz]
    settings.fllDampingRatio   = 0.7;
    settings.fllNoiseBandwidth = 10; % [Hz]

    %% Navigation solution settings
    % Rate for calculating pseudorange and position
    settings.navSolRate   = 10; % [Hz]
    settings.navSolPeriod = 1000 / settings.navSolRate; % [ms]
    % Elevation mask to exclude signals from low elevation satellites
    settings.elevationMask = 10; % [Degree]
    % Enable / disable use of tropospheric correction
    settings.useTropCorr = 0;
    % True position of the antenna in UTM system
    settings.truePosition.E = nan;
    settings.truePosition.N = nan;
    settings.truePosition.U = nan;

    %% Plot settings
    % Plot tracking results for each channel
    settings.plotTracking = 1;

    %% Constants
    % Speed of light in vacuum
    settings.c = 299792458; % [m / s]
    % Initial sign traval time
    settings.startOffset = 68.802; % [ms]

    %% CNo Settings
    % Accumulation interval in Tracking (in Sec)
    settings.CNo.accTime=0.001;
    % Show C/No during Tracking;1-on;0-off;
    % settings.CNo.enableVSM=1;
    settings.CNo.enableVSM = 0;
    % Accumulation interval for computing VSM C/No (in ms)
    settings.CNo.VSMinterval = 400;
    % Accumulation interval for computing PRM C/No (in ms)
    settings.CNo.PRM_K = 200;
    % No. of samples to calculate narrowband power;
    % Possible Values for M=[1,2,4,5,10,20];
    % K should be an integral multiple of M i.e. K=nM
    settings.CNo.PRM_M = 20;
    % Accumulation interval for computing MOM C/No (in ms)
    settings.CNo.MOMinterval = 200;
    % Enable/disable the C/No plots for all the channels
    % 0 - Off ; 1 - On;
    settings.CNo.Plot = 1;
    %Enable vector tracking when 1, otherwise scalar tracking.
    settings.VLLen = 0;
end