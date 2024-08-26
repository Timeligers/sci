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
// - OpenBLAS fixed issues: 
//   - https://github.com/OpenMathLib/OpenBLAS/issues/4413
//   - https://github.com/OpenMathLib/OpenBLAS/issues/86
//
// This test covers all codes 

//
// TEST SCALAR * SCALAR
//

assert_checkequal(%i * %inf, %nan + %i*%inf);
assert_checkequal(%i * %inf, %inf * %i);

assert_checkequal(%i * %nan, %nan + %i*%nan);
assert_checkequal(%i * %nan, %nan * %i);

assert_checkequal(3 * %nan, %nan * 3);
assert_checkequal(3 * %inf, %inf * 3);

// crafted complex
iinf = complex(0, %inf);
inan = complex(0, %nan);

assert_checkequal(%i * iinf, complex(-%inf, %nan));
assert_checkequal(%i * iinf, iinf * %i);

assert_checkequal(%i * inan, %nan + %i*%nan);
assert_checkequal(%i * inan, inan * %i);

assert_checkequal(3 * inan, inan * 3);
assert_checkequal(3 * iinf, iinf * 3);


//
// TEST SCALAR * MATRIX and MATRIX * SCALAR
//

INF = [%inf %inf];
NAN = [%nan %nan];

assert_checkequal(%i * INF, NAN + %i*INF);
assert_checkequal(%i * INF, INF * %i);

assert_checkequal(%i * NAN, NAN + %i*NAN);
assert_checkequal(%i * NAN, NAN * %i);

assert_checkequal(3 * NAN, NAN * 3);
assert_checkequal(3 * INF, INF * 3);

// crafted complex
iINF = complex(0, INF);
iNAN = complex(0, NAN);

assert_checkequal(%i * iINF, complex(-INF, NAN));
assert_checkequal(%i * iINF, iINF * %i);

assert_checkequal(%i * iNAN, NAN + %i*NAN);
assert_checkequal(%i * iNAN, iNAN * %i);

assert_checkequal(3 * iNAN, iNAN * 3);
assert_checkequal(3 * iINF, iINF * 3);


//
// TEST MATRIX .* MATRIX
//

I = [%i %i];
INF = [%inf %inf];
NAN = [%nan %nan];

assert_checkequal(I .* INF, NAN + I.*INF);
assert_checkequal(I .* INF, INF .* I);

assert_checkequal(I .* NAN, NAN + I.*NAN);
assert_checkequal(I .* NAN, NAN .* I);

assert_checkequal([3 3] .* NAN, NAN .* [3 3]);

// crafted complex
iINF = complex(0, INF);
iNAN = complex(0, NAN);

assert_checkequal(I .* iINF, complex(-INF, NAN));
assert_checkequal(I .* iINF, iINF .* I);

assert_checkequal(I .* NAN, NAN + I.*NAN);
assert_checkequal(I .* NAN, NAN .* I);

assert_checkequal([3 3] .* NAN, NAN .* [3 3]);


//
// TEST MATRIX * MATRIX
//

I = [%i %i ; %i %i];
INF = [%inf %inf ; %inf %inf];
NAN = [%nan %nan ; %nan %nan];

assert_checkequal(I * INF, NAN + I*INF);
assert_checkequal(I * INF, INF * I);

assert_checkequal(I * NAN, NAN + I*NAN);
assert_checkequal(I * NAN, NAN * I);

assert_checkequal([3 3 ; 3 3] * NAN, NAN * [3 3 ; 3 3]);
assert_checkequal([3 3 ; 3 3] * INF, INF * [3 3 ; 3 3]);

// crafted complex
iINF = complex(0, INF);
iNAN = complex(0, NAN);

assert_checkequal(I * iINF, complex(-INF, NAN));
assert_checkequal(I * iINF, iINF * I);

assert_checkequal(I * iNAN, NAN + I*NAN);
assert_checkequal(I * iNAN, iNAN * I);

assert_checkequal([3 3 ; 3 3] * iNAN, iNAN * [3 3 ; 3 3]);
assert_checkequal([3 3 ; 3 3] * iINF, iINF * [3 3 ; 3 3]);
