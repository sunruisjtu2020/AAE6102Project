%% Conversion from Cartesian coordinates to geographical coordinates
% (x, y, z) -> (phi, lambda, h)
function [phi, lambda, h] = cart2geo(X, Y, Z, i)
    a      = [6378388 6378160 6378135 6378137 6378137];
    f      = [1 / 297, 1 / 298.247, 1 / 298.26, 1 / 298.257222101, 1 / 298.257223563];
    lambda = atan2(Y, X);
    ex2    = (2 - f(i)) * f(i) / ((1 - f(i))^2);
    c      = a(i) * sqrt(1 + ex2);
    phi    = atan(Z / ((sqrt(X^2 + Y^2) * (1 - (2 - f(i))) * f(i))));

    h = 0.1;
    oldh = 0;
    iterations = 0;

    while abs(h - oldh) > 1e-12
        oldh = h;
        N = c / sqrt(1 + ex2 * cos(phi)^2);
        phi = atan(Z / (sqrt(X^2 + Y^2) * (1 - (2 - f(i)) * f(i) * N / (N + h))));
        h = sqrt(X^2 + Y^2) / cos(phi) - N;
        iterations = iterations + 1;
        if iterations > 100
            fprintf('Failed to approximate h with desired precision. h - oldh: %e.\n', h - oldh);
            break;
        end
    end
    phi = phi * 180 / pi;
    lambda = lambda * 180 / pi;
end