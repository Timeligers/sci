// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Bruno JOFRET
// Copyright (C) 2013 - Scilab Enterprises - Sylvestre LEDRU
// Copyright (C) 2018 - Samuel GOUGEON
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unitary tests for modulo() and pmodulo() functions
// =============================================================================

assert_checkerror("modulo()", msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"),"modulo", 2));
errarg = sci2exp(["double", "polynomial", "int"]);
assert_checkerror("modulo(''a'',1)", msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "modulo", 1, errarg));
assert_checkerror("modulo(1,''a'')", msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "modulo", 2, errarg));
assert_checkerror("modulo(%pi+%i,1)", msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "modulo", 1));
assert_checkerror("modulo(1,1+%i)", msprintf(_("%s: Wrong value for input argument #%d: Real numbers expected.\n"), "modulo", 2));

n=[1,2,10,15];
m=[2,2,3,5];
r = modulo(n,m);
assert_checkequal(r, [1,0,1,0]);

n = 100 * rand(1,100);
m = 100 * rand(1,100);
r = modulo(n,m);
computed_r = n - m .* int (n ./ m);
assert_checkequal(r, computed_r);
// Hypermatrices
m = matrix(1:8, [2 2 2]);
n = matrix(-9:-2, [2 2 2]);
a=[1 3;2 4];a(:,:,2)=[0 2; 1 3];
assert_checkequal(modulo(m, 5), a );
assert_checkequal(pmodulo(m,5), a);
a=[6 2;3 3];a(:,:,2)=[1 0; 3 1];
assert_checkequal(modulo(51, n), a);
assert_checkequal(pmodulo(51,n), a);
a=[1 3;2 4];a(:,:,2)=[0 1; 2 0];
assert_checkequal(modulo(m, n), a);
assert_checkequal(pmodulo(m,n), a);


// ENCODED INTEGERS
// Same inttypes
assert_checkequal(modulo(     -9 ,     [-7 5]) ,[-2 -4]);
assert_checkequal(modulo(int8(-9),int8([-7 5])),int8([-2 -4]));
assert_checkequal(modulo(      9 ,     [-7 5]) ,[2 4]);
assert_checkequal(modulo( int8(9),int8([-7 5])),int8([2 4]));

assert_checkequal(pmodulo(     -9,      [-7 5]) ,[5 1]);
assert_checkequal(pmodulo(int8(-9),int8([-7 5])),int8([5 1]));
assert_checkequal(pmodulo(      9,      [-7 5]) ,[2 4]);
assert_checkequal(pmodulo( int8(9),int8([-7 5])),int8([2 4]));
// Distinct inttypes
assert_checkequal(modulo( int8(-123), int16(-7)), int8(-4));
assert_checkequal(pmodulo(int8(-123), int16(-7)), int8(3));
assert_checkequal(modulo( int8(-123), int16([-7 5])),int8([-4,-3]));
assert_checkequal(pmodulo(int8(-123), int16([-7 5])),int8([3,2]));
assert_checkequal(modulo( int8([-123 51]), int16(-7)),  int8([-4,2]));
assert_checkequal(pmodulo(int8([-123 51]), int16(-7)),int8([3,2]));
assert_checkequal(modulo( int8([-123 51]), int16([-7 5])),int8([-4,1]) );
assert_checkequal(pmodulo(int8([-123 51]), int16([-7 5])),  int8([3,1]));
// Hypermatrices
m = grand(2,4,2, "uin", -120, 120);
n = grand(2,4,2, "uin", -100, 100);
assert_checkequal(modulo(int8(m), int8(n)), int8(modulo(m,n)));
assert_checkequal(modulo(int16(m), int8(n)), int16(modulo(m,n)));
assert_checkequal(pmodulo(int8(m), int8(n)), int8(pmodulo(m,n)));
assert_checkequal(pmodulo(int16(m), int8(n)), int16(pmodulo(m,n)));


// POLYNOMIALS
assert_checkequal(modulo(%z^2,%z),0);
assert_checkequal(modulo( %z^2+1, %z), 1);
assert_checkequal(pmodulo(%z^2+1, %z), 1);
// Hypermatrices
h = grand(2,2,2, "uin", 1,9)*%s;
assert_checkequal(modulo(h,h),zeros(h));
assert_checkequal(pmodulo(h,h),zeros(h));
