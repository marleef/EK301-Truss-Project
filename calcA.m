% Determine coefficient matrix A
% A is populated by the coeffs of force for the respective member
% tension at each joint
 
function A = calcA(C, X, Y, Sx, Sy)
    [r, c] = size(C);
    A = zeros(2*r); % Preallocate A
    Ax = zeros(r, c); % Preallocate X component of A (excluding Sx)
    Ay = zeros(r, c); % Preallocate Y component of A (excluding Sy)
    S = [Sx; Sy];
    dist = calcDist(C, X, Y);
    
    % Fill in Ax and Ay components
    for i = 1:c
        pt = find(C(:,i) == 1);
        Ax(pt(1),i) = (X(pt(2)) - X(pt(1))) / dist(i);
        Ax(pt(2),i) = -Ax(pt(1), i);
        Ay(pt(1),i) = (Y(pt(2)) - Y(pt(1))) / dist(i);
        Ay(pt(2),i) = -Ay(pt(1), i);
    end
    A(:,1:c) = [Ax; Ay];
 
    % Fill in Sx and Sy components
    A(:, c+1:c+3) = S;
    
    % Find distances for each coeff (1 per column)
    function distances = calcDist(C, X, Y)
        distances = zeros(1, c);
        for k = 1:c
            pts = find(C(:,k) == 1);
            distances(k) = sqrt((X(pts(1)) - X(pts(2)))^2 + (Y(pts(1)) - Y(pts(2)))^2);
        end
    end
end
