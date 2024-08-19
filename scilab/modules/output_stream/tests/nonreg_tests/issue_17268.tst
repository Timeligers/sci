// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 17268 -->
//
// <-- CLI SHELL MODE -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17268
// <-- Short Description -->
// disp(a,b) with a, a variable zpk or state-space type, displays the [zpk] (or [state-space]) outline for each following variable.
A=[0,1;0,0];B=[1;1];C=[1,1];
S1=syslin('c',A,B,C);
disp(S1, 1, %t, "toto")
