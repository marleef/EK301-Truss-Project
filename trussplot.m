% Plot truss, and show which members are tension/compression/zero-force
 
function plotfig = trussplot(X, Y, Tround, C)
    figure(2)
    
    % Plot pin joint and rocker joint
    plot(X(1), Y(1)-.5, 'k^', 'MarkerSize', 15);
    axis([-5 max(X)+5 -5 max(Y)+5]);
    hold on
    plot(X(length(X)), Y(length(Y))-.5, 'ko', 'MarkerSize', 15);  
    hold on
 
    % ----------------------- Compression Members ----------------------- % 
    % Preallocate compression vector
    comp = Tround(1:length(Tround)-3);
    for i = 1:length(comp)
        if comp(i) > 0
            comp(i) = 0;
        elseif comp(i) == 0
            comp(i) = 2;
        else
            comp(i) = 1;
        end
    end
  
    % Find indices of members in compression
    findMems1 = find(comp==1);
    
    % Loop to match C columns (members) with findMems1 indices and find joint
    % coordinates
    % Plot each member in compression in red
    for i = 1:length(findMems1)
        c = find(C(:,findMems1(i))==1);
        plot(X(c), Y(c), 'r', 'LineWidth', 2);
        hold on
    end
 
    % ------------------------- Tension Members ------------------------- %
    % Preallocate tension vector
    ten = Tround(1:length(Tround)-3);
    for i = 1:length(ten)
        if ten(i) < 0
            ten(i) = 0;
        else
            ten(i) = 1;
        end
    end
    % Find indices of members in tension
    findMems2 = find(ten==1);
    
    % Loop to match C columns (members) with findMems2 indices and find joint
    % coordinates
    % Plot each member in tension in blue
    for i = 1:length(findMems2)
        t = find(C(:,findMems2(i))==1);
        plot(X(t), Y(t), 'b', 'LineWidth', 2);
        hold on
    end
    
    % ----------------------- Zero-Force Members ----------------------- %
    % Preallocate zero-force vector
    zero = Tround(1:length(Tround)-3);
 
    % Find indices of zero-force members
    findMems3 = find(zero==0);
      
    for i = 1:length(findMems3)
        z = find(C(:,findMems3(i))==1);
        plot(X(z), Y(z), 'k', 'LineWidth', 2);
        hold on
    end
 
    % Plot joints
    plotfig = scatter(X, Y, 'k', 'filled');
    axis([-5 max(X)+5 -5 max(Y)+5]);
    hold on
    
end
