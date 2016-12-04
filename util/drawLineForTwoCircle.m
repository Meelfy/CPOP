function h = drawLineForTwoCircle(Circle1, Circle2, Position)
    hold on
    x1 = Circle1(1);
    y1 = Circle1(2);
    r1 = Circle1(3);
    x2 = Circle2(1);
    y2 = Circle2(2);
    r2 = Circle2(3);

    min_x = min([x1 x2 10*x1 10*x2 -10*x1 -10*x2]);
    max_x = max([x1 x2 10*x1 10*x2 -10*x1 -10*x2]);
    x = min_x:max_x;

    
    y = kx + b;
    h = plot(xunit, yunit);
    hold off