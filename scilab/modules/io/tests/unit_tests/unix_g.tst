// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//

if getos() == "Windows" then
    [stdout, status, stderr] = unix_g("xcopy.exe");
    assert_checkequal(stdout, "0 File(s) copied")
    assert_checkequal(status, 4)
    assert_checkequal(stderr, "Invalid number of parameters")
else
    [stdout, status, stderr] = unix_g("cp");
    assert_checkequal(stdout, "")
    assert_checkequal(status, 1)
    assert_checkequal(stderr, [ "cp: missing file operand"
                                "Try ''cp --help'' for more information."])
end
