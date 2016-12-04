function h = plotCircle(x, y, r, angle_start ,angle_span)
    if nargin == 3
        angle_start = 0;
        angle_span = 2*pi;
    end

    hold on
    th = angle_start:pi/50:angle_span;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    h = plot(xunit, yunit);
    hold off