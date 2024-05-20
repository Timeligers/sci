// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) XXXX-2008 - INRIA
// Copyright (C) XXXX-2008 - INRIA - Allan CORNET
// Copyright (C) 2024 - Dassault Systèmes - Clément DAVID

//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.


function varargout = unix_g(cmd)
    //unix_g - shell command execution
    //%Syntax
    //stdout=unix_g(cmd)
    //%Parameters
    // cmd - a character string
    // stdout - a column vector of character strings
    //%Description
    // cmd instruction (sh syntax) is passed to shell, the standard output
    // is redirected  to scilab variable stdout.
    //%Examples
    // unix_g("ls")
    //%See also
    // host unix_x unix_s
    //!

    [lhs,rhs] = argn(0);

    if rhs <> 1 then
        error(msprintf(gettext("%s: Wrong number of input argument(s): %d expected.\n"),"unix_g",1));
    end

    if type(cmd) <> 10 then
        error(msprintf(gettext("%s: Wrong type for input argument #%d: String expected.\n"),"unix_g",1));
    end

    if size(cmd,"*") <> 1 then
        error(msprintf(gettext("%s: Wrong size for input argument #%d: string expected.\n"),"unix_g",1));
    end

    if lhs > 3 then
        error(msprintf(gettext("%s: Wrong number of output argument(s).\n"),"unix_g"));
    end

    [stat, stdout, stderr] = host(cmd);

    if stat == -1 then
        // host failed, append a descriptive message to the stderr stream
        if lhs == 3 then
            stderr = [ stderr ; msprintf(gettext("%s: The system interpreter does not answer..."),"unix_g") ];
        else
            disp(msprintf(gettext("%s: The system interpreter does not answer..."),"unix_g"));
        end
    elseif stat <> 0 && lhs < 3 then
        // display something on error
        disp(stderr(1));
    end


    // output arguments

    varargout(1) = stdout;
    varargout(2) = stat;
    varargout(3) = stderr;
endfunction
