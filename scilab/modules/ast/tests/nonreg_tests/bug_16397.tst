// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 16397 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/16397
//
// <-- Short Description -->
// display of long real vectors in the console is slow

x=rand(1e4,1);
tic;
disp(x)
t1 = toc();
tic;
disp([x,x])
t2 = toc();

assert_checktrue(t2 > t1);
