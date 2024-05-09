// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2021 - Samuel GOUGEON - Le Mans Université
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function Lev = contour_pretty_levels(varargin)
    // Lev = contour_pretty_levels(zmin, zmax, nLevels)
    // Lev = contour_pretty_levels(rawLevels)
    //
    // Internal function called by contour# functions
    // There must be nL levels equispaced in ]zmin, zmax[
    // Compute a smart series of levels (could still be improved):

    if argn(2)==1 then
        Lev = varargin(1)
        // simplifying given level values
        if length(Lev)==2
            Dz = max(Lev) - min(Lev)
            dz = 10^(floor(log10(Dz))-1)
            Lev = round(Lev/dz)*dz
        elseif length(Lev)>2
            tmp = [2*Lev(1) - Lev(2), Lev, 2*Lev($) - Lev($-1)];
            Dz = min(abs(tmp(3:$)-tmp(2:$-1)), abs(tmp(2:$-1)-tmp(1:$-2)));
            dz = 10^(floor(log10(Dz))-1);
            Lev = round(Lev./dz) .* dz
        end
        return
    end

    [zmin, zmax, nL] = (varargin(:))
    if zmin > zmax then
        [zmin, zmax] = (zmax, zmin)
    end
    // Tuning the step
    // ---------------
    dz0 = (zmax - zmin)/nL
    dzmin = (zmax - zmin)/(nL+1)
    dzmax = (zmax - zmin) / (nL-1)
    dzTol = (zmax - zmin)/(nL^2-1)
    f = 10^(-floor(log10(dz0)))
    dzi = int(dz0 * f)          //
    dz = dzi / f                //
    dzOK = %f
    if dz < dzmin then
        tmp = (dzi + 1) / f
        if tmp < dzmax
            dzi = dzi + 1
            dz = dzi / f
            dzOK = %t
        end
    end
    while dz < dzmin
        f = f*10
        dzi = int(dz0 * f)
        dz = dzi / f
        for m = [5 4 3 2]
            tmp = int(dzi/m) * m / f
            if tmp > dzmin & tmp < dzmax
                dz = tmp
                break
            end
        end
    end

    // Tuning the step's step
    df = 10^(-floor(log10(dzTol)))
    ddzi = int(dzTol * df)
    df = f
    ddzi = dzi
    while abs(dz-dz0) >= dzTol
        [ddzi, df] = decrease_ddzi(ddzi, df)
        ddz = ddzi / df
        dz = dz - sign(dz-dz0)*ddz
    end
    if ~isdef("ddz","l") then
        [ddzi, df] = decrease_ddzi(ddzi, df)
        ddz = ddzi / df
    end

    done = %f
    zstart = ceil(zmin/dz) * dz
    dzmax = zmax - (zstart + (nL-1)*dz)
    if (zstart-zmin) > abs(zstart)*%eps & dzmax > 0 & dzmax < dz-abs(zmax)*%eps then
        Lev = zstart + (0:nL-1)*dz
        done = %t
    end

    if ~done then
        zstart = floor(zmin / dz) * dz
        while (zstart-zmin <= abs(zmin)*%eps & zstart+(nL-1)*dz+ddz < zmax) | ..
            (zmax - (zstart+(nL-1)*dz) >= dz & (zstart+ddz-zmin < dz ))
            zstart = zstart + ddz
        end
        done = (zstart > zmin+abs(zmin)*%eps) & (zstart - zmin) < dz & ..
               (zstart+(nL-1)*dz < zmax) & (zmax - (zstart+(nL-1)*dz) < dz)
        if ~done  // we decrease ddz
            [ddzi, df] = decrease_ddzi(ddzi, df)
            ddz = ddzi / f
            zstart = floor(zmin / dz) * dz
            while (zstart-zmin <= abs(zmin)*%eps & zstart+(nL-1)*dz+ddz < zmax) | ..
                (zmax - (zstart+(nL-1)*dz) >= dz & (zstart+ddz-zmin < dz ))
                zstart = zstart + ddz
            end
            done = (zstart > zmin+abs(zmin)*%eps) & (zstart - zmin) < dz*(1-%eps) & ..
                   (zmax - (zstart+(nL-1)*dz) > abs(zmax)*%eps) & ..
                   (zmax - (zstart+(nL-1)*dz) - dz < -abs(zmax)*%eps)
        end
    end
    if done
        Lev = clean(zstart + (0:nL-1)*dz)
    else
        // fallback solution
        Lev = zmin + dz0/2 + (0:nL-1)*dz0
        f = 10^(-floor(log10(dz0)))
        Lev = clean(round(Lev * f) / f)
    end
    // Symmetrization around 0 (when applicable):
    if Lev(1)*Lev($) < 0
        dz = Lev(2)-Lev(1)
        [v, ks] = gsort(abs(Lev),"g","i")
        k = find(v<dz)
        for i = ks(k)
            v = Lev(i)
            tmp = Lev - v
            if (tmp(1)-zmin > abs(zmin)*%eps) & (tmp(1)-zmin - dz < -abs(zmin)*%eps) & ..
               (zmax-tmp($) > abs(zmax)*%eps) & (zmax-tmp($) - dz < -abs(zmax)*%eps)
                Lev = tmp
                break
            end
        end
    end
endfunction
function [ddzi, df] = decrease_ddzi(ddzi, df)
    if ddzi==1 then
        [ddzi, df] = (5, df*10)
    elseif or(ddzi==[2 4 8])
        ddzi = ddzi / 2
    elseif or(ddzi==[3 6 9])
        ddzi = ddzi / 3
    else // [5 7]
        ddzi = 1
    end
endfunction
