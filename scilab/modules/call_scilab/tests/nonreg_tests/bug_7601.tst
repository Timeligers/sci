// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Allan CORNET
// Copyright (C) 2015 - Scilab-Enterprises - Cedric Delamarre
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 7601 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/7601
//
// <-- Short Description -->
// call_scilab C functions did not check if engine is started.

exec("SCI/modules/call_scilab/tests/nonreg_tests/compileHelpers.sce");

// Define Variables as decribed in the Makefile
// make bug_7601
// ./bug_7601

[stdout, status, stderr] = run_executable(compile_executable(get_absolute_file_path() + "bug_7601.c"));
disp(stdout, stderr)

// display   - 42.    42.
assert_checkequal(stdout, "- 42.    42.");

// default value returned by main will be -1
assert_checkequal(status, -1);
