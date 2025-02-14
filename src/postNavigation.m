%% Post-processing
% This is the main structure of SDR

%% Initialization

disp('Start Processing...');

% Read raw data file
[fid, message] = fopen(settings.fileName, 'rb');

% Initialize the multiplier to adjust for the data type
if (settings.fileType == 1)
    dataAdaptCoeff = 1;
else
    dataAdaptCoeff = 2;
end

%% Processing

% If data is available, start processing
if (fid > 0)
    % Move the starting point for processing
    fseek(fid, dataAdaptCoeff * settings.skipNumberOfSamples, 'bof');

    % Do acquisition
    if (settings.skipAcquisition == 0)
        % Find number of samples per spreading code
        samplesPerCode = round(settings.samplingFreq / (settings.codeFreqBasis / settings.codeLength));
        % Start acquisition
        disp('Acquiring satellites...');
        data = fread(fid, dataAdaptCoeff * ...
         (settings.acquisition.cohCodePeriods * ...
          settings.acquisition.nonCohSums + 1) * ...
            samplesPerCode * 6, settings.dataType)';
        if (dataAdaptCoeff == 2)
            data1 = data(1:2:end);
            data2 = data(2:2:end);
            data = data1 * 1i .* data2;
        end

        acqResults = acquisition(data, settings);

        plotAcquisition(acqResults);
    elseif (settings.skipAcquisition == 1)
        disp('Acquisition skipped, reading existing acquisition results...')
        load acqresults
        plotAcquisition(acqResults);
    end

    % Initialize for channels

    if (any(acqResults.peakMetric > settings.acqThreshold))
        % Satellites acquired
        channel = preRun(acqResults, settings);
        showChannelStatus(channel, settings);
    else
        % No satellite acquired
        disp('No GNSS signal detected, signal processing finished.');
        trackResults = [];
        return;
    end

    % Do tracking
    if ~settings.VLLen
        startTime = datetime('now');
        disp(['Tracking started at ', datetime(startTime)]);
        % Process all channels for given data block
        [trackResults, channel] = tracking(fid, channel, settings);
        % Close data file
        fclose(fid);
        disp(['Tracking is finished in ', datetime('now') - startTime]);
        disp('Save the acquisition and tracking results to trackingResults.mat');
        save('trackingResults', 'trackResults', 'settings', 'acqResults', 'channel');
        load('trackingResults');
    else
        disp('Skip scalar tracking, load existing results')
        load('trackingResults');
        settings.VLLen = 1;
    end

    % Calculate navigation solutions
    if ~settings.VLLen
        disp('Calculating navigation solutions...');
        [navSolutions, eph, svTimeTable, activeChnList] = postNavigation(trackResults, settings);
        save('navSolutions', 'navSolutions', 'eph', 'svTimeTable', 'activeChnList');
        load('navSolutions');
    else
        disp('Skip postNavigation, load existing navSolution');
        load('navSolutions');
        disp('Start vector tracking')
        % return;
        [trackResults_v, channel] = vectorTracking(fid, channel, trackResults, navSolutions, eph, activeChnList, svTimeTable, settings);
        save('trackResults_v', 'trackResults_v');
    end

    disp('Processing completed for this data block.');

    % Plot results
    disp('Ploting results...');
    if (settings.plotTracking)
        plotTracking(1:settings.numberOfChannels, trackResults, settings);
    end
    plotNavigation(navSolutions, settings);

    disp('Post processing of the signal is over');

else
    % Error occured when reading data file
    error('Unable to read %s: %s', settings.fileName, message);
end