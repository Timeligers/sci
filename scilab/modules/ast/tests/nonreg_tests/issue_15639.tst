// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systemes - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- Non-regression test for issue 15639 -->
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Gitlab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15639
//
// <-- Short Description -->
// %inf*%i <> %i*%inf (regression)

// Test written using:
// - Windows MKL version as reference (Scilab 2024.1.0)
// - OpenBLAS fixed issues: https://github.com/OpenMathLib/OpenBLAS/issues/4413 & https://github.com/OpenMathLib/OpenBLAS/issues/86

assert_checkequal(%i * %inf, %nan + %i*%inf);
assert_checkequal(%i * %inf, %inf * %i);

assert_checkequal(%i * %nan, %nan + %i*%nan);
assert_checkequal(%i * %nan, %nan * %i);

assert_checkequal(3 * %nan, %nan * 3);
