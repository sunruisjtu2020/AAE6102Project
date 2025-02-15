%% Cartesian coordinate to UTM
% (X, Y, Z) -> (E, N, U)
%Kai Borre -11-1994
%Copyright (c) by Kai Borre
%
% CVS record:
% $Id: cart2utm.m,v 1.1.1.1.2.4 2006/08/22 13:45:59 dpl Exp $


function [E, N, U] = cart2utm(X, Y, Z, zone)
    a     = 6378388;
    f     = 1 / 297;
    ex2   = (2 - f) * f / ((1 - f)^2);
    c     = a * sqrt(1 + ex2);
    vec   = [X; Y; Z - 4.5];
    alpha = .756e-6;
    R     = [1 -alpha 0;
            alpha 1 0;
            0 0 1];
    trans = [89.5; 93.8; 127.6];
    scale = 0.9999988;
    v     = scale * R * vec + trans;
    L     = atan2(v(2), v(1));
    N1    = 6395000;
    B     = atan2(v(3) / ((1 - f) ^ 2 * N1), norm(v(1:2)) / N1);
    U     = 0.1;
    oldU  = 0;
    while (abs(U - oldU) > 1.e-4)
        oldU = U;
        N1   = c / sqrt(1 + ex2 * (cos(B))^2);
        B    = atan2(v(3) / ((1 - f)^2 * N1 + U), norm(v(1:2)) / (N1 + U));
        U    = norm(v(1:2)) / cos(B) - N1;
    end

    m0  = 0.0004;
    n   = f / (2 - f);
    m   = n^2 * (1/4 + n * n / 64);
    w   = (a * (-n - m0 + m * (1 - m0))) / (1 + n);
    Q_n = a + w;

    E0 = 500000;
    L0 = (zone - 30) * 6 - 3;

    toltum = pi / 2 * 1.2e-10 * Q_n;
    tolgeo = 0.000040;
    bg = [-3.37077907e-3;
        4.73444769e-6;
        -8.29914570e-9;
        1.58785330e-11];

    gb = [ 3.37077588e-3;
        6.62769080e-6;
        1.78718601e-8;
        5.49266312e-11];

    gtu = [ 8.41275991e-4;
            7.67306686e-7;
            1.21291230e-9;
            2.48508228e-12];

    utg = [-8.41276339e-4;
        -5.95619298e-8;
        -1.69485209e-10;
        -2.20473896e-13];

    neg_geo = 'FALSE';

    if B < 0
        neg_geo = 'TRUE ';
    end

    cos_BN = cos(Bg_r);
    Np = atan2(sin(Bg_r), cos(Lg_r) * cos_BN);
    Ep = atanh(sin(Lg_r) * cos_BN);

    Np = 2 * Np;
    Ep = 2 * Ep;
    [dN, dE] = clksin(gtu, 4, Np, Ep);
    Np = Np / 2;
    Ep = Ep / 2;
    Np = Np + dN;
    Ep = Ep + dE;
    N = Q_n * Np;
    E = Q_n * Ep + E0;

    if neg_geo == 'TRUE '
        N = -N + 2e7;
    end
end