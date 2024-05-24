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

// check a command
if getos() == "Windows" then
    status = host("ls "+WSCI+"\CHANGES.md");
else
    status = host("ls "+SCI+"/CHANGES.md");
end
assert_checktrue(status == 0)

// check a non existing command
status = host("this-is-not-a-valid-command");
assert_checktrue(status != 0)

// check stdout
[status, stdout] = host("ls "+SCI+filesep()+"*.md");
assert_checktrue(status == 0)
assert_checkequal(stdout, strsubst(listfiles("SCI/*.md"), "\", "/"))

// check a command outputting to both stdout and stderr
if getos() == "Windows" then
    [status, stdout, stderr] = host("xcopy.exe");
    assert_checkequal(stdout, "0 File(s) copied")
    assert_checkequal(status, 4)
    assert_checkequal(stderr, "Invalid number of parameters")
else
    [status, stdout, stderr] = unix_g("cp");
    assert_checkequal(stdout, "")
    assert_checkequal(status, 1)
    assert_checkequal(stderr, [ "cp: missing file operand"
                                "Try ''cp --help'' for more information."])
end
