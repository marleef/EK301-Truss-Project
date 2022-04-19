% firstMem = member that will fail first
% maxLoad = maximum truss load
% Ubuckle = uncertainty in the buckling strength of the member that will
% fail first
% maxloadU = uncertainty in the maximum truss load = maxLoad * Ubuckle
% F = buckling strength
 
function [firstMem, maxloadt, maxloada, maxloadUt, maxloadUa, Ubuckle, Ft, Fa] ...
    = calcLoad(lengths, lengthsA, T, load, EI_min, uncertaintyT, alpha)  
    % Create new vector T2 without rxn forces Sx1, Sy1, Sy2
    % Replace the positive tensile forces as 0 N
    % Make the vector positive (compression forces are < 0)
    T2t = T(1:length(T)-3);
    for i = 1:length(T2t)
        if T2t(i) > 0
            T2t(i) = 0;
        end
    end
    T2t = abs(T2t);
    T2a = T2t;
    % Preallocate F and Ubuckle vectors
    n = length(lengths);
    Ft = zeros(1, n);
    Fa = zeros(1, n);
    Ubuckle = zeros(1, n);
    
    for i = 1:n
        Ft(i) = (EI_min * pi.^ 2) / (lengths(i) .^ 2);
        T2t(i) = T2t(i)./Ft(i);
        Ubuckle(i) =  uncertaintyT / (lengths(i) .^ 3);
        
        % Calculate the actual truss load Fa
        Fa(i) = ((lengths(i) / (lengthsA(i))) .^ alpha) .* Ft(i);
        T2a(i) = T2a(i)./Fa(i);
    end 
    
 
    % Find index for the first member to fail
    firstMem = find(max(T2t) == T2t);
    
    % Calculate theoretical max load and max load uncertainty
    maxloadt = -load / T2t(firstMem); 
    maxloadUt = maxloadt .* (Ubuckle(firstMem));
    
    % Calculate actual max load and max load uncertainty
    maxloada = -load / T2a(firstMem); 
    maxloadUa = maxloada .* (Ubuckle(firstMem));
end
 
 
% Thus, to find the member that buckles first, you can 
% calculate the ratio of the compressive member force for an 
% applied truss load of 1 N to the buckling force of the member. 
% The member with the maximum ratio is the one that will buckle first, 
% since that member will reach its buckling force first as applied truss 
% load is increased. The maximum applied load for the truss is then 1 N 
% divided by the maximum member ratio.
