// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - 3DS - Antoine ELIAS
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function str = %ce_string(ce)
    if size(ce, "*") == 0 then
        str = "{}";
    else
        str = emptystr(ce);
        for i = 1:size(ce, "*")
            val = ce{i};
            t = type(val)
            select t
            case 13 //macro
                str(i) = "function";
            case 14 //lib
                str(i) = "lib";
            case 15 //list
                str(i) = sprintf("[list of %d element(s)]", size(val));
            case 16 //tlist
                str(i) = typeof(val);
            case 17 //mlist
                select typeof(val)
                case "st"
                    str(i) = sprintf("[%dx%d struct]", size(val, 1), size(val, 2));
                case "ce"
                    str(i) = sprintf("{%dx%d cell}", size(val, 1), size(val, 2));
                else
                    str(i) = typeof(val);
                end
            case 128 //pointer
                str(i) = typeof(val);
            case 130 //builtin
                str(i) = "function";
            case 9 //handles
                str(i) = sprintf("[%dx%d handle]", size(val, 1), size(val, 2));
            else
                [n1, m1] = size(val);
                if n1 == 0 && m1 == 0 then
                    str(i) = "[]";
                elseif n1 == 1 then
                    x = sci2exp(val);
                    if size(x, "*") <> 1 || length(x) > 15 then
                        str(i) = sprintf("[%dx%d %s]", size(val, 1), size(val, 2), typeof(val));
                    else
                        str(i) = x;
                    end
                else
                    str(i) = sprintf("[%dx%d %s]", size(val, 1), size(val, 2), typeof(val));
                end
            end
        end
    end

    s = max(length(str), "r");

    for j = 1:size(str, 2)
        f = sprintf("%%%ds\n", -s(j));
        for i = 1:size(str, 1)
            str(i, j) = sprintf(f, str(i, j))
        end
    end
endfunction
