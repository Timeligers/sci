// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 8115 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/8115
//
// <-- Short Description -->
// DisableInteractiveMode did not work

exec("SCI/modules/call_scilab/tests/compileHelpers.sce");

// Define Variables as decribed in the Makefile
// make bug_8115
// ./bug_8115

[stdout, status, stderr] = run_executable(compile_executable(get_absolute_file_path() + "bug_8115.c"));
disp(stdout, stderr)

// nothing must be displayed
assert_checkequal(stdout, "");

assert_checkequal(status, 0);