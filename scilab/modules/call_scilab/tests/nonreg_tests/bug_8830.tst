// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2011 - DIGITEO - Sylvestre LEDRU
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 8830 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8830
//
// <-- Short Description -->
// In call_scilab, TerminateScilab  did not clear the last error.

exec("SCI/modules/call_scilab/tests/nonreg_tests/compileHelpers.sce");

// Define Variables as decribed in the Makefile
// make bug_8830
// ./bug_8830

[stdout, status, stderr] = run_executable(compile_executable(get_absolute_file_path() + "bug_8330.c"));
disp(stdout, stderr)

// "getLastErrorValue 0" must be displayed
assert_checkequal(stdout, "getLastErrorValue 0");

assert_checkequal(status, 0);
