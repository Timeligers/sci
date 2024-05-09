// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA
// Copyright (C) 2011 - DIGITEO - Michael Baudin
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2021 - 2023 - Samuel GOUGEON - Le Mans Université
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

/* https://gitlab.com/scilab/scilab/-/issues/17026

TODO:
* TO CHECK: The default fpf precision must be set according to the z-step,
  not to a fixed format
* Datatips do not show the z elevation.
* Actual levels are currently not returned
* Update unitary tests
* Update documentation <> en_US

DONE:
* The example (demo) could be nicer. It is intended to be representative and attractive.
* The example can't be displayed in a subplot
* The style option can't be an expandable scalar (for instance to set the same
  dash style for all level curves)
* z = fun:
  - builtin are not accepted.
  - list(fun, params) is not supported.
  - Even if fun is vectorized, the current implementation calls fun(X(i),Y(j)),
    what can be (very) slow
* nz should be optional. Computation of nice default automatic levels should be proposed.
* When the number of levels is provided, most often computed levels are not smart,
  with respect to the current precision.\
  The series of equally spaced values should be slightly shifted to get smarter values.
* Display of labels must be a lot improved:
  - Labels may be hidden by curves : #12552
  - For so small islands that their labels is bigger, labelling should be skipped (canceled).
  - Labels placement is far from being optimized. For instance, labels of close
    curves are often stacked on each others: #11023
  - Any label should preferably be displayed along its curve.
  - By default, any label should have the color of its curve.
* Addressing the set of labels and the set of curves to post-process and customize
  their style is not easy. It should be simpler:
  - all labels could be gathered in gca().children(1)
  - all curves could be gathered in gca().children(2)

* When zooming in, labels are currently unclipped outside the axes box.
* Documentation:
  - unlike what was documented, x and y do not have to be rows.
  - x and y must be sorted in increasing order. In addition, x is along the
    horizontal axis, y is along the vertical one. This deserved to be documented.
*/
function varargout = contour2d(x, y, z, nz, style, strf, leg, rect, nax, fpf)

    [lhs, rhs] = argn(0);

    // EXAMPLE
    // =======
    if rhs == 0 then
        s = gca().axes_bounds; delete(gca()); xsetech(s)  // clears the current axes
        // levels = contour2d(1:10, 1:10, rand(10,10), 6, rect = [0 0 10 10]+0.5);
        levels = contour2d_example()
        title("contour2d")
        if argn(1)>0
            varargout = list(levels)
        end
        return
    end

    // ARGUMENTS CHECKING and INITIALIZATIONS
    // ======================================
    if rhs < 3 then
        tmp = gettext("%s: Wrong number of input argument(s): At least %d expected.\n")
        error(msprintf(tmp, "contour2d", 3));
    end

    // x vector
    // --------
    if type(x) <> 1 | ~isreal(x) then
        tmp = gettext("%s: Wrong type for input argument #%d: Real vector expected.\n")
        error(msprintf(tmp, "contour2d", 1));
    end
    if ~isvector(x) then
        tmp = gettext("%s: Wrong size for input argument #%d: Real vector expected.\n")
        error(msprintf(tmp, "contour2d", 1));
    end

    // y vector
    // --------
    if type(y) <> 1 | ~isreal(y)  then
        tmp = gettext("%s: Wrong type for input argument #%d: Real vector expected.\n")
        error(msprintf(tmp, "contour2d", 2));
    end
    if ~isvector(y) then
        tmp = gettext("%s: Wrong size for input argument #%d: Real vector expected.\n")
        error(msprintf(tmp, "contour2d", 2));
    end

    // z data
    // ------
    if type(z)==15 then     // list(fun, params, ..)
        if length(z)>1
            params = z
            params(1) = null()
        end
        z = z(1)
    end
    if and(type(z) <> [1 13 15 130]) | (type(z)==1 & ~isreal(z))
        tmp = gettext("%s: Argument #%d: Real matrix or function handle expected.\n")
        error(msprintf(tmp, "contour2d", 3));
    end
    if or(type(z)==[13 130]) then
        fun = z
        clear z  // to avoid redefinition warning
        if ~isdef("params","l") then
            params = list()
        end
        // Is fun() vectorized? (=> if so, direct call will be much faster)
        isVectorized = %t
        try
            z = fun(x(1:2), y(1:2), params(:))
            isVectorized =  and(size(z)==[2 1])
        catch
            isVectorized = %f
        end
        if isVectorized then
            [X, Y] = ndgrid(x,y)
            s = size(X)
            z = fun(X(:), Y(:), params(:))
            z = matrix(z, s)
        else
            if params
                [nx, ny] = (length(x), length(y))
                z = zeros(nx, ny)
                for i = 1:nx
                    for j = 1:ny
                        z(i,j) = fun(x(i), y(j), params(:))
                    end
                end
            else
                z = feval(x, y, fun);
            end
        end
    end

    // Curves levels
    // -------------
    if ~isdef("nz","l")
        nz = 15
    elseif type(nz) <> 1 | ~isreal(nz) then
        tmp = gettext("%s: Argument #%d: Decimal number expected.\n")
        error(msprintf(tmp, "contour2d", 4));
    else
        nz = matrix(nz,1,-1)
        num = length(nz)
        if num > 1
            k = isnan(nz) | isinf(nz)
            nz(k) = []
            if isdef("style","l") & size(style,"*")>1
                style(k) = []
            end
            if nz == []
                tmp = gettext("%s: Argument #%d: No valid values.\n")
                error(msprintf(tmp, "contour2d", 4));
            end
            // Simplify given levels (for over-accurate ones):
            nz = contour_pretty_levels(nz)
        else
            // Compute a smart series of nz levels equispaced on ]min(z), max(z)[:
            nz = contour_pretty_levels(min(z), max(z), nz)
        end
        if (num > 1 & length(nz)==1) | nz < 0
            nz = [nz nz]
        end
    end

    // Styles of curves
    // ----------------
    if ~exists("style", "local") then
        if size(nz, "*") == 1 then
            style = 1:nz;
        else
            style = 1:size(nz, "*");
        end
    elseif type(style) <> 1 | ~isreal(style) | or(style<>int(style)) then
        msg = _("%s: Argument #%d: Integers expected.\n")
        error(msprintf(msg, "contour2d", 5))
    elseif size(style,"*")==1 then
        style = ones(1,length(nz)) * style
    end

    // Other options
    // -------------
    opts = [];
    if exists("strf", "local") then
        yflag = part(strf, 2);
        if or(yflag == ["2" "4" "6" "8"]) then
            rect = [min(x), min(y), max(x), max(y)];
            yflag = string(evstr(yflag) - 1);
            strf = part(strf, 1) + yflag + part(strf, 3);
        end
        opts = [opts,"strf=strf"];
    end
    if exists("leg", "local") then
        opts = [opts, "leg=leg"];
    end
    rectSpecified = %f;
    if exists("rect","local") then
        opts = [opts, "rect=rect"];
        rectSpecified = %t;
    end
    if exists("nax","local") then
        opts = [opts, "nax=nax"];
    end
    if exists("logflag","local") then
        opts = [opts, "logflag=logflag"];
    end
    if exists("frameflag","local") then
        opts = [opts,"frameflag=frameflag"];
    else
        frameflag = [];
    end
    if exists("axesflag","local") then
        opts = [opts, "axesflag=axesflag"];
    end
    opts = strcat([opts, "style=style(c)"], ",");

    // Figure & axes : initializations
    // ===============================
    fig = gcf();
    a = gca();
    nbChildren0 = length(a.children); // to be prevent ungluing/gluing them


    if ~isdef("fpf","l") | fpf=="" then
        fpf = "%g"
    end

    autoc = a.auto_clear;
    if autoc == "on" then
        if ~isempty(a.children) then
            delete(a.children);
        end
    end
    v = fig.immediate_drawing;
    fig.immediate_drawing = "off";
    a.auto_clear = "off";

    // If contour2d() is called from contourf(), levelled curves are already
    //  computed and available in the axes.userdata structure (.contour field)
    ud = a.userdata
    if isstruct(ud) & isfield(ud,"contourf") & ud.contourf
         fromContourf = %T
         xc = ud.xc
         yc = ud.yc
     else
         fromContourf = %F
        [xc, yc] = contour2di(x, y, z, nz);
    end

    // we draw the contour with call to 2d for each level line
    // however the data_bounds will be always reset after each plot
    // so we must compute before the bounding rectangle (xmin,ymin,xmax,ymax)
    // and give it to each plot2d. This is useful for frameflag = (2,4,6,8)
    // since the data_bounds are given by the extrema of x and y
    if ( frameflag == 2 | frameflag == 4 | frameflag == 6 | frameflag == 8 )
        // get the bounding rectangle
        rect = [min(x), min(y), max(x), max(y)];
        // set the option accordingly
        if ~rectSpecified then
            opts = strcat([opts, "rect=rect"], ",");
        end
        // the rect will be taken into account
        frameflag = frameflag - 1 ;
    elseif (~rectSpecified) then
        // get rect any way for clipping
        rect = [min(x), min(y), max(x), max(y)];
    end

    k = 1;
    n = yc(k);
    c = 0;
    level = %inf;
    levels = [];
   // x/y ratio for label orientation
    clear tmp
    [tmp(1,:), tmp(2,:)] = xchange([0 1], [0 1], "i2f")
    tmp = abs(tmp(:,2) - tmp(:,1))
    xR = tmp(1) // in x/pixel
    yR = tmp(2) // in y/pixel

    LabList = []  // List of labels positions [{xL} {yL}]
    // MAIN LOOP over levelled curves
    while k < length(xc)
        n = yc(k);
        if xc(k) ~= level then
            c = c + 1;
            level = xc(k);
            levels = [level levels];
        end
        // the curve:
        cx = xc(k + (1:n))
        cy = yc(k + (1:n))
        if ~fromContourf
            err = execstr("plot2d(cx, cy," + opts + ")", "errcatch", "m");
            frameflag = 0;
            // add a test to see if plot2d call succeeds
            // and, if not, restore good figure property values before exiting
            if err <> 0
                mprintf(gettext("Error %d : in plot2d called by contour2d"), err)
                fig.immediate_drawing = v
                a.auto_clear = autoc
                return
            end
            unglue(a.children(1))
        end

        // LABELLING the LEVEL CURVE:
        if stripblanks(fpf) <> "" then
            // Length of the curve:
            dx = diff(cx)/xR
            dy = diff(cy)/yR
            segs = sqrt(dx.^2 + dy.^2)  // length of segments (in pixels)
            cL  = sum(segs)

            // slopes of the curve
            orien = dy
            orien(dx==0)=90
            kx = dx~=0
            orien(kx) = -atand(dy(kx)./dx(kx))

            // Label display
            labelText = msprintf(fpf, level)
            tmp = xstringl(0,0,labelText)

            // Too small islands are not labelled:
            w = tmp(3)/xR  // Label's width [in pixels]
            if (cx(1)==cx($) & cL>3*w) | cL>2*w then
                // Choosing where on the curve the label must be displayed
                // Points out of rect are excluded:
                tmp = find((cx(1:$-1)<=rect(1) & cx(2:$)<=rect(1)) | ..
                           (cx(1:$-1)>=rect(3) & cx(2:$)>=rect(3)) | ..
                           (cy(1:$-1)<=rect(2) & cy(2:$)<=rect(2)) | ..
                           (cy(1:$-1)>=rect(4) & cy(2:$)>=rect(4)))
                tmp = find(cx<=rect(1)|cx>=rect(3)|cy<=rect(2)|cy>=rect(4))
                cx(tmp) = []
                cy(tmp) = []
                orien(tmp) = []
                // 75% of points among the least inclined are retained:
                [tmp, kL] = gsort(abs(orien),"g","i")
                iPmax = ceil(length(orien)*0.75)
                if LabList==[] // First label = the most horizontal
                    //dn = kL(ceil(rand(1,1)*iPmax))
                    dn = kL(1)
                else // The point furthest to existing Labels is chosen
                    [tmpC, tmpL] = ndgrid(cx(kL(1:iPmax))/xR, LabList(:,1))
                    d2 = (tmpC-tmpL).^2
                    [tmpC, tmpL] = ndgrid(cy(kL(1:iPmax))/yR, LabList(:,2))
                    d2 = d2 + (tmpC-tmpL).^2
                    // For each eligible point of the curve, we determine
                    // the distance to the nearest existing label. Finally,
                    // we chose the point for which this distance is maximal
                    [d2,dn] = max(min(d2,"c"))
                    dn = kL(dn)
                end
                if dn~=[] then
                    LabList($+1,:) = [cx(dn)/xR cy(dn)/yR]
                    if dn < length(cx) & dn < length(cy)
                        xL = (cx(dn)+cx(dn+1))/2
                        yL = (cy(dn)+cy(dn+1))/2
                    else
                        xL = cx(dn)
                        yL = cy(dn)
                    end

                    labelBox = stringbox(labelText, xL, yL);
                    // check that the text is not outside the box
                    // better than clipping to avoid half cut strings
                    if labelBox(1,1) > rect(1) & labelBox(2,1) > rect(2) & ..
                        labelBox(1,3) < rect(3) & labelBox(2,3) < rect(4) then
                        // Does this condition work for reversed axes?
                        th = orien(dn)
                        xstring(xL, yL, labelText, th)
                        e = gce()
                        e.box = "on"
                        e.line_mode = "off"
                        e.text_box_mode = "centered"
                        e.fractional_font = "on"
                        e.font_size = 0.8
                        if ~fromContourf then
                            e.font_foreground = style(c)
                            e.fill_mode = "on"
                            e.font_size = 1
                        else
                            e.fill_mode = "off"
                        end
                        e.clip_state = "clipgrf"
                        data = struct("level",level, "color0",style(c), ..
                                      "angle0",th, "dydx", tand(th)*yR/xR)
                        e.userdata = data
                    end
                end
            end
        end
        k = k + n + 1
    end

    if length(a.children) > nbChildren0 then
        tmp = a.children(1:$-nbChildren0)
        labels = tmp(tmp.type=="Text")
        curves = tmp(tmp.type=="Polyline")
        tmp = tmp(tmp.type=="Compound")
        for c = tmp'
            tmp2 = unglue(c)
            labels = [labels ; tmp2(tmp2.type=="Text")]
            curves = [curves ; tmp2(tmp2.type=="Polyline")]
        end
        if curves <> []
            glue(curves)
        end
        if labels <> []
            glue(labels)
        end
    end
    set("current_entity", a);
    fig.immediate_drawing = v;
    if argn(1)>0
        varargout = list(nz)
    end
endfunction

// ---------------------------------------------------------------------------

function levels = contour2d_example()
    x = -2:0.1:2;
    y = -2:0.1:2;
    [X,Y] = meshgrid(x,y);
    Z = X.*Y.*exp(1-X.^2-Y.^2);
    f = gcf();
    levels = -0.45:.05:0.45;
    nL = length(levels);
    f.color_map = jetcolormap(nL+1)
    levels = contour2d(x,y,Z',levels, fpf="")
endfunction
