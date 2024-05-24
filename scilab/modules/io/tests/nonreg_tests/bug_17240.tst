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
// <-- Non-regression test for bug 17240 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17240
//
// <-- Short Description -->
// stdout and stderr should be outputed whatever the exit code
// 


[stdout1, status1, stderr1] = unix_g("ls "+SCI+"/CHANGES.md");
if status1 <> 0 then pause, end
assert_checkequal(stderr1, []);

[stdout2, status2, stderr2] = unix_g("ls nonexisting_file");
if status2 == 0 then pause, end
assert_checkequal(stdout2, []);

[stdout3, status3, stderr3] = unix_g("ls "+SCI+"/CHANGES.md nonexisting_file");
if status3 == 0 then pause, end
assert_checkequal(stdout3, stdout1);
assert_checkequal(stderr3, stderr2);
