// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - 3DS - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17187 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17187
//
// <-- Short Description -->
// the second input argument of bar was considered as the width of bar when 
// the first input argument was scalar and the second input argument was lower or equal to 1.

scf(1);
bar(3, 0.5);

scf(2);
bar(3, 2, 0.5);

scf(3);
bar(3, 0.5, 0.5);