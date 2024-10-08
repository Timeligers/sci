// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- XCOS TEST -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 12057 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12057
//
// <-- Short Description -->
// Scopes with big scope buffer size simulation was much more slower.
// 
// This test check cscope and cmscope huge-buffer (more than 4k points)
// optimization.

assert_checktrue(importXcosDiagram(SCI + "/modules/xcos/tests/nonreg_tests/bug_12057_cscope.zcos"));
timer();
xcos_simulate(scs_m, 4);
t = timer()

assert_checktrue(t < 60);

assert_checktrue(importXcosDiagram(SCI + "/modules/xcos/tests/nonreg_tests/bug_12057_cmscope.zcos"));
timer();
xcos_simulate(scs_m, 4);
t = timer()

assert_checktrue(t < 60);
