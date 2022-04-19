% EK301, Section C1, Group #1, 7/27/20.
% Eileen Duong, ID U23210183
% Marlee Feltham, ID U74081325
% Patra Hsu, ID U35567789
clear
clf
% ----------------------------- Main Script ----------------------------- %
% ======================================================================= %
% This main script analyzes the internal member forces of various truss 
% designs and determines the maximum failure load each design can withstand
 
% ----------------------------- File Header ----------------------------- %
disp('% EK301, Section C1, Group #1, 7/27/20.');
disp('% Eileen Duong, ID U23210183');
disp('% Marlee Feltham, ID U74081325');
disp('% Patra Hsu, ID U35567789');
format_out = 'mm/dd/yy';
t = datetime('now');
d = datestr(t, format_out);
fprintf('%% DATE: %s\n', d);
 
% ----------------------- Define Truss Parameters ----------------------- %
% Truss parameters include: the joint locations, the member-joint
% connections, the locations of the reaction forces, 
% and the magnitude of the applied load.
 
% Loads spreadsheet and saves info in corresponding variables
% fileName = 'truss.xlsx'; 
% C = readmatrix(fileName, 'Range', 'B2:N9');       % This commented
% Sx = readmatrix(fileName, 'Range', 'B13:D20');    % was used for loading
% Sy = readmatrix(fileName, 'Range', 'B23:D30');    % an excel sheet
% X = readmatrix(fileName, 'Range', 'B33:I33');
% Y = readmatrix(fileName, 'Range', 'B36:I36');
% L = readmatrix(fileName, 'Range', 'B40:Q40');
C = [
1   1   0   0   0   0   0   0   0   0   0   0   0   0   0   ;
1   0   1   1   0   0   0   0   0   0   0   0   0   0   0   ;
0   1   1   0   1   1   0   0   0   0   0   0   0   0   0   ;
0   0   0   1   1   0   1   1   0   0   0   0   0   0   0   ;
0   0   0   0   0   1   1   0   1   1   0   0   0   0   0   ;
0   0   0   0   0   0   0   1   1   0   1   1   0   0   0   ;
0   0   0   0   0   0   0   0   0   1   1   0   1   1   0   ;
0   0   0   0   0   0   0   0   0   0   0   1   1   0   1   ;
0   0   0   0   0   0   0   0   0   0   0   0   0   1   1   ];
    
Sx = [          
1   0   0   ;
0   0   0   ;
0   0   0   ;
0   0   0   ;
0   0   0   ;
0   0   0   ;
0   0   0   ;
0   0   0   ;
0   0   0   ];
 
Sy = [
0   1   0   ;
0   0   0   ;
0   0   0   ;
0   0   0   ;
0   0   0   ;
0   0   0   ;
0   0   0   ;
0   0   0   ;
0   0   1   ];
 
X = [0     5.74    12.0    19.0    25   31.5    38.5    46.0    53.5];                          
Y = [0     13.3    0.31    13.3    0    13.3    0.31    13.3    0.31];              
L = [0  0   0   0   0   0   0   0   0   0   0   0   0   -16.9840388375526   0   0   0   0];
 
% ------------------ Coefficient Matrix A Calculations ------------------ %
A = calcA(C, X, Y, Sx, Sy);
 
% ------------------------- Output Calculations ------------------------- %
% Compute vector T
T = -A \ L';
 
% --------------------- Member Force Classification --------------------- %
[j, m] = size(C);
forceType = strings(1, m);
 
Tround = round(T, 8); % For very small forces that are approximately 0, round off so that 'Zero-Force Member' rather than 'T' is displayed in Command Window
for i = 1:(length(Tround)-3)
    if Tround(i) < 0
        forceType(i) = 'C';
    elseif Tround(i) > 0
        forceType(i) = 'T';
    else
        forceType(i) = 'Zero-Force Member';
    end
end
 
% -------------------------- Cost Calculations -------------------------- %
[lengths, lengthsA, totalLength] = calcLength(C, X, Y);
cost = 10*j + totalLength;
load = sum(L);
 
% ---------------------- Load Failure Calculations ---------------------- %
[EI_min, uncertaintySE, uncertaintyT, uncertaintyE, alpha] = calcEI;
[firstMem, maxloadt, maxloada, maxloadUt, maxloadUa, Ubuckle, Ft, Fa] ...
    = calcLoad(lengths, lengthsA, T, load, EI_min, uncertaintyT, alpha);
ratio = maxloada / cost;
cost = num2str(cost);
 
% -------------------------- Print Statements --------------------------- %
plotfig = trussplot(X, Y, Tround, C);
fprintf('\nLoad: %.2f N\n\n', -load); % Assumes load is entered as a (-) value
fprintf('Member forces in Newtons\n');
 
TAbs = abs(T);
for i = 1:length(T)-3
    fprintf('m%d: %.3f (%s)\n', i, TAbs(i), forceType(i));
end
 
fprintf('\nReaction forces in Newtons:\n');
fprintf('Sx1: %.2f\n', TAbs(length(TAbs) - 2));
fprintf('Sy1: %.2f\n', TAbs(length(TAbs) - 1));
fprintf('Sy2: %.2f\n', TAbs(length(TAbs)));
fprintf('\nCost of truss: $%s\n', cost);
fprintf('Theoretical max load/cost ratio in N/$: %f\n', ratio);
