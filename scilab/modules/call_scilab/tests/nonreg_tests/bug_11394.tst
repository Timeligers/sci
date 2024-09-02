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
// <-- Non-regression test for bug 11394 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/11394
//
// <-- Short Description -->
// In call_scilab, TerminateScilab did not allow a restart in NW mode.

exec("SCI/modules/call_scilab/tests/nonreg_tests/compileHelpers.sce");

// Define Variables as decribed in the Makefile
// make bug_11394
// ./bug_11394

[stdout, status, stderr] = run_executable(compile_executable(get_absolute_file_path() + "bug_11394.c"));
disp(stdout, stderr)

// nothing must be displayed
assert_checkequal(stdout, "");

assert_checkequal(status, 0);