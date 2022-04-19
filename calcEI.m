function [EI_min, uncertaintySE, uncertaintyT, uncertaintyE, alpha] = calcEI
% weights (N) in vectors by straw lengths (cm)
SL10 = [14.72 16.19 15.70 13.73 14.72];
SL11 = [14.72 17.67 16.19 14.72 15.70];
SL12 = [13.73 12.75 11.78 11.28 10.79];
SL125 = [12.26 13.24 12.56 12.75 13.73];
SL13 = [9.34 10.79 11.28 11.77 13.73];
SL135 = [9.81 10.30 10.50 10.30 10.79];
SL14 = [10.79 9.81 9.32 11.28 9.81];
SL15 = [8.34 8.04 7.85 7.55 7.65];
 
% mean weights in vector Mw
Mw = zeros(1,8);
Mw(1) = mean(SL10);
Mw(2) = mean(SL11);
Mw(3) = mean(SL12);
Mw(4) = mean(SL125);
Mw(5) = mean(SL13);
Mw(6) = mean(SL135);
Mw(7) = mean(SL14);
Mw(8) = mean(SL15);
 
% finding the buckling weights (N) in vector y1 using mean loads (Mw)
y1 = zeros(1,8);
for i = 1:8
    y1(i) = ((.165 .* Mw(i))+(.215 * .5 * 2.16801))/.195;
end   
 
% given straw lengths (cm) in vector x1
x1 = [10 11 12 12.5 13 13.5 14 15];
 
% plot scatterplot of straw lengths vs. buckling weights
figure(1);
s1 = scatter(x1, y1, 50, 'o');
 
% finding compressive force vectors wSL### for each recorded mass (N) for each length (cm)
%-- The negative is to indicate compression
%-- The formula used is the moment formula described in the Straw Testing Report
wSL10 = zeros(1,5);
for i = 1:5
    wSL10(i) = -1*((.165.*SL10(i))+(.215*.5*2.16801))/.195; 
end  
 
wSL11 = zeros(1,5);
for i = 1:5
    wSL11(i) = -1*((.165.*SL11(i))+(.215*.5*2.16801))/.195;
end   
 
wSL12 = zeros(1,5);
for i = 1:5
    wSL12(i) = -1*((.165.*SL12(i))+(.215*.5*2.16801))/.195;
end   
 
wSL125 = zeros(1,5);
for i = 1:5
    wSL125(i) = -1*((.165.*SL125(i))+(.215*.5*2.16801))/.195;
end   
 
wSL13 = zeros(1,5);
for i = 1:5
    wSL13(i) = -1*((.165.*SL13(i))+(.215*.5*2.16801))/.195;
end   
 
wSL135 = zeros(1,5);
for i = 1:5
    wSL135(i) = -1*((.165.*SL125(i))+(.215*.5*2.16801))/.195;
end   
 
wSL14 = zeros(1,5);
for i = 1:5
    wSL14(i) = -1*((.165.*SL14(i))+(.215*.5*2.16801))/.195;
end   
 
wSL15 = zeros(1,5);
for i = 1:5
    wSL15(i) = -1*((.165.*SL15(i))+(.215*.5*2.16801))/.195;
end   
 
% Standard Deviation calculations for the compressive force vectors wSL###
%-- STD put in vector err1
format long
err1 = zeros(1,8);
err1(1) = std(wSL10);
err1(2) = std(wSL11);
err1(3 )= std(wSL12);
err1(4) = std(wSL125);
err1(5) = std(wSL13);
err1(6) = std(wSL135);
err1(7) = std(wSL14);
err1(8) = std(wSL15);
hold on
 
% finding empirical curve fit 
c1 = polyfit(x1, y1, 4); 
xaxis = linspace(9, 16, 15);
y_est2 = polyval(c1, xaxis);
l2 = plot(xaxis, y_est2, 'g-', 'LineWidth', 1);
xlabel('Straw Length (cm)');
ylabel('Buckling Weight (N)');
title('Buckling Weight vs. Straw Length');
 
%--equation of the empirical curve fitting for plot 
eq2_str = ['Emp. fit: y = ' num2str(c1(1)) '*x^4 + ' num2str(c1(2)) '*x^3 + ' num2str(c1(3)) '*x^2 + ' num2str(c1(4)) '*x^1 + ' num2str(c1(5))]; 
text(9.5, 5, eq2_str)
 
% Theoretical Curve Fitting
%-- Finding the minimum of summation of square error between theoretical equation and measured samples
%-- Finding what is the value of E*I that will give the best theoretical fit (by equation) to the measured samples 
for EI = 160:0.5:220 % Ranges of E*I that will give the underestimate/ overestimate of the empirical fit line. 
    %The ranges for EI are found by setting the Wl equation with various...
    % numbers and plotting to find where the Theor. curve is under the...
    % empirical curve and where it is obviously over the emp. curve.
    Wl = 0;
    Wl = pi^2 * EI ./ xaxis.^2; % this is the equation for the buckling theory
 
    error = 0;
    for i = 1:8 
        error = error + abs(Wl(find(xaxis == x1(i)))-y1(i)); % finding the error summation
    end
 
    if EI == 160 % this will give the underestimate bound for W(l)
        min_error = error;
        EI_min = EI;
    elseif error < min_error
        min_error = error;
        EI_min = EI;
    end
end
%-- Now we get the E*I that will give the best theoretical fit (by equation) to the measured samples ---
 
hold on
Wl = pi^2 * EI_min ./ xaxis.^2; % Finds the buckling strength as a function of straw length for the E*I found
ls3 = plot(xaxis, Wl, '--', 'LineWidth',1);
%fprintf('The E*I value that will give the best theoretical fit (by equation) to the measured samples = %6.3f', EI_min);
%--- Buckling strength W(l) using the EI_min value found above
% since the moment of inertia of the straw about the center is (I/(length)^2) =1/12(mass)
% i.e. W(l) = (EI_min * pi^2)/l^2
% Therefore, the theoretical fit gives buckling strength of the straw at a given length can be
% found by inputting various lengths in for l.
 
% Extra plot formatting coding -- error bars
eb2 = errorbar(x1,y1,err1,'vertical','LineStyle','none'); 
set(eb2,'color','k','LineWidth',1);
hold on
 
 
 
 
%--- Semi-empirical curve fitting---
%-- the ranges for both A and alpha were both ran with broad ranges to find the numerical optimization and
%... then once the optimal scalars are found, the ranges are narrowed to
%... save on processing time when running the code
for A = 1:0.5:220 % Ranges of A that will give the underestimate/ overestimate of the semi-empirical fit line. 
    for alpha = 1:0.5:10
        W_Semi = 0;
        W_Semi = A ./ xaxis.^alpha; % this is the equation for the buckling theory
 
        error = 0;
        for i = 1:8 
            error = error + abs(W_Semi(find(xaxis == x1(i)))-y1(i)); % finding the error summation
        end
 
        if (A == 160)&&(alpha == 1) % this will give the underestimate bound for W(l)
            min_error = error;
            A_min = A;
            alpha_min = alpha;
        elseif error < min_error
            min_error = error;
            A_min = A;
            alpha_min = alpha;
        end
    end
end
 
hold on
W_Semi = A_min ./ xaxis.^alpha_min; % Finds the buckling strength as a function of straw length for the A and alpha found
ls4 = plot(xaxis, W_Semi, '--', 'LineWidth',3);
%fprintf('\n The A value and alpha value that will give the best semi-empirical fit (by equation) to the measured samples = %6.3f and %6.3f', A_min, alpha_min);
%-- add legend
legend([s1 l2 ls3 ls4], 'Data', 'Empirical Fit','Theoretical curve', 'Semi-Empirical Fit', 'location', 'northeast');
    % Calculate uncertainty by finding average vertical distance for
    % empirical fit    
    n = length(x1);
    y_line = zeros(1,n);
    for i = 1:n;
        y_line(i) = c1(1)*(x1(i).^4)+c1(2)*(x1(i).^3)+c1(3)*(x1(i).^2)+c1(4)*(x1(i))+c1(5);
        vert_distE(i) = y1(i) - y_line(i);
        vert_distE(i) = abs(vert_distE(i)); 
    end
    uncertaintyE = sum(vert_distE) / length(vert_distE);
    
    % Calculate uncertainty by finding average vertical distance for
    % semi-empirical fit
    x2 = A_min ./W_Semi;
    x2 = round(x2,2);
    x1 = round(x1,2);
    findXcoord = find(ismember(x2, x1));
    yW_Semi = zeros(1, length(y1)); % W_Semi y-coordinates
    for i = 1:length(findXcoord)
        yW_Semi(i) = W_Semi(findXcoord(i));
        vert_distSE(i) = yW_Semi(i)- y1(i);
        vert_distSE(i) = abs(vert_distSE(i));
    end
    uncertaintySE = sum(vert_distSE) / length(vert_distSE);
    
    % Calculate uncertainty by finding average vertical distance for
    % theoretical fit
    x3sq = pi^2 * EI_min ./ Wl; 
    x3 = sqrt(x3sq);   
    findXcoord2 = find(ismember(x3, x1));
    yWl = zeros(1, length(y1)); % Wl y-coordinates
    for i = 1:length(findXcoord2)
        yWl(i) = Wl(findXcoord2(i));
        vert_distT(i) = yWl(i)- y1(i);
        vert_distT(i) = abs(vert_distT(i));
    end
    uncertaintyT = sum(vert_distT) / length(vert_distT);
 
    
end
