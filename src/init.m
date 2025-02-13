%---------------------------------------------------
% This code is a fork of SoftGNSS for course AAE6102
% at PolyU.
%---------------------------------------------------

%--------------------------------------------------------------------------
%                           SoftGNSS v3.0
%
% Copyright (C) Darius Plausinaitis and Dennis M. Akos
% Written by Darius Plausinaitis and Dennis M. Akos
%--------------------------------------------------------------------------
%This program is free software; you can redistribute it and/or
%modify it under the terms of the GNU General Public License
%as published by the Free Software Foundation; either version 2
%of the License, or (at your option) any later version.
%
%This program is distributed in the hope that it will be useful,
%but WITHOUT ANY WARRANTY; without even the implied warranty of
%MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%GNU General Public License for more details.
%
%You should have received a copy of the GNU General Public License
%along with this program; if not, write to the Free Software
%Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
%USA.
%--------------------------------------------------------------------------

%% Clean up environment
clear;
close all;
clc;

%% Add additional functions
addpath("functions");    % Add software recevier functions
addpath("include");      % Add position calculation functions

%% Print startup license
fprintf(['\n',...
    'Welcome to:  softGNSS\n\n', ...
    'An open source GNSS SDR software project initiated by:\n\n', ...
    '              Danish GPS Center/Aalborg University\n\n', ...
    'The code was improved by GNSS Laboratory/University of Colorado.\n\n',...
    'The software receiver softGNSS comes with ABSOLUTELY NO WARRANTY;\n',...
    'for details please read license details in the file license.txt. This\n',...
    'is free software, and  you  are  welcome  to  redistribute  it under\n',...
    'the terms described in the license.\n\n']);
fprintf('                   -------------------------------\n\n');

%% Initialize configuration
settings = initSettings;

%% Generate plot of raw data and ask if ready to start processing
try
    fprintf('Probing data (%s)...\n', settings.fileName)
    probeData(settings);
catch ME
    % throw an exception
    fprintf("Error ID: %s\n", ME.identifier);
    fprintf("Error message: %s\n", ME.message);
    return;
end

disp('  Raw IF data plotted ')
disp('  (run setSettings or change settings in "initSettings.m" to reconfigure)')
disp(' ');
gnssStart = input('Enter "1" to initiate GNSS processing or "0" to exit : ');

if (gnssStart == 1)
    disp(' ');
    %start things rolling...
    postProcessing;
end
