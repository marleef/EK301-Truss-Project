function [fitresult, gof] = createFitscftool(x1, y1)
%CREATEFITS(X1,Y1)
%  Create fits.
%
%  Data for 'EmpiricalFitD3' fit:
%      X Input : x1
%      Y Output: y1
%  Data for 'EmpiricalFitD2' fit:
%      X Input : x1
%      Y Output: y1
%  Data for 'EmpiricalFitD4' fit:
%      X Input : x1
%      Y Output: y1
%  Data for 'EmpiricalFitD6' fit:
%      X Input : x1
%      Y Output: y1
%  Output:
%      fitresult : a cell-array of fit objects representing the fits.
%      gof : structure array with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 27-Jul-2020 12:52:53

%% Initialization.

% Initialize arrays to store fits and goodness-of-fit.
fitresult = cell( 4, 1 );
gof = struct( 'sse', cell( 4, 1 ), ...
    'rsquare', [], 'dfe', [], 'adjrsquare', [], 'rmse', [] );

%% Fit: 'EmpiricalFitD3'.
[xData, yData] = prepareCurveData( x1, y1 );

% Set up fittype and options.
ft = fittype( 'poly3' );

% Fit model to data.
[fitresult{1}, gof(1)] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'EmpiricalFitD3' );
h = plot( fitresult{1}, xData, yData );
legend( h, 'y1 vs. x1', 'EmpiricalFitD3', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x1', 'Interpreter', 'none' );
ylabel( 'y1', 'Interpreter', 'none' );
grid on

%% Fit: 'EmpiricalFitD2'.
[xData, yData] = prepareCurveData( x1, y1 );

% Set up fittype and options.
ft = fittype( 'poly2' );

% Fit model to data.
[fitresult{2}, gof(2)] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'EmpiricalFitD2' );
h = plot( fitresult{2}, xData, yData );
legend( h, 'y1 vs. x1', 'EmpiricalFitD2', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x1', 'Interpreter', 'none' );
ylabel( 'y1', 'Interpreter', 'none' );
grid on

%% Fit: 'EmpiricalFitD4'.
[xData, yData] = prepareCurveData( x1, y1 );

% Set up fittype and options.
ft = fittype( 'poly4' );

% Fit model to data.
[fitresult{3}, gof(3)] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'EmpiricalFitD4' );
h = plot( fitresult{3}, xData, yData );
legend( h, 'y1 vs. x1', 'EmpiricalFitD4', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x1', 'Interpreter', 'none' );
ylabel( 'y1', 'Interpreter', 'none' );
grid on

%% Fit: 'EmpiricalFitD6'.
[xData, yData] = prepareCurveData( x1, y1 );

% Set up fittype and options.
ft = fittype( 'poly5' );

% Fit model to data.
[fitresult{4}, gof(4)] = fit( xData, yData, ft, 'Normalize', 'on' );

% Plot fit with data.
figure( 'Name', 'EmpiricalFitD6' );
h = plot( fitresult{4}, xData, yData );
legend( h, 'y1 vs. x1', 'EmpiricalFitD6', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x1', 'Interpreter', 'none' );
ylabel( 'y1', 'Interpreter', 'none' );
grid on
