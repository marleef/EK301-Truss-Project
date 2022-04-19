% Each j row of matrix C represents joint number
% Each m column of matrix C represents member number
 
% Find indices of C where joints are connected to a given member
% Calculate length between joints
% Calculate actual straw lengths
% Calculate total joint-joint length
 
function [outLengths, outLengthsA out_totalLength] = calcLength(C, X, Y)
    [~, m] = size(C); 
    outLengths = zeros(1, m);
    outLengthsA = zeros(1, m);
    for i = 1:m 
        pts = find(C(:,i) == 1);
        outLengths(i) = sqrt((X(pts(1)) - X(pts(2)))^2 + (Y(pts(1)) - Y(pts(2)))^2);
    end
    outLengthsA = outLengths - 0.5;
    out_totalLength = sum(outLengths);
end
