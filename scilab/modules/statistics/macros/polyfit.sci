// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - 3DS - Adeline CARNIS
//
// For more information, see the COPYING file which you should have received
// along with this program.

function [p, s, mu] = polyfit(x, y, n)
    arguments
        x {mustBeA(x, "double")}
        y {mustBeA(y, "double")}
        n (1,1) {mustBeA(n, "double"), mustBeInteger, mustBeNonnegative}
    end

    if size(x, "*") <> size(y, "*") then
        error(msprintf(_("%s: Wrong size of input arguments #%d and #%d: Must have the same size.\n"), "polyfit", 1, 2));
    end

    if nargout == 3 then
        mu = [mean(x), stdev(x)];
        x = (x - mu(1)) / mu(2);
    end

    x = x(:);
    y = y(:);
    if (n >= length(x)) then
        warning(msprintf(_("%s: The solution is not unique because the argument #%d n >= number of data points.\n"), "polyfit", 3));
    end
    
    v = vander(x, n+1);
    v = v(:, $:-1:1);

    [Q, R, P] = qr(v, "e");
    p = R \ (Q' * y);
    p = P * p;
    
    if nargout > 1 then
        s.R = R * P;
        s.df = max(0, size(x, "*") - (n + 1));
        s.normr = norm(y - v * p)
    end

    p = p.';

endfunction
