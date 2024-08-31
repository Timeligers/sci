// =============================================================================
// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - 3DS - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

// unit tests for polyfit function
// =============================================================================

assert_checkequal(polyfit(1, 1, 0), 1);

x = 0:5;
y = #(x) -> (2*x);
p = polyfit(x, y(x), 1);
expected = [2 0];
assert_checkalmostequal(p, expected, [], 1e-14);

[p, S, mu] = polyfit(x, y(x), 1);
assert_checkalmostequal(S.R, [0 -2.449489742783177881336; 2.2360679774997898050515 0], [], 1e-14);
assert_checkequal(S.df, 4);
assert_checkalmostequal(S.normr, 2.5510983e-15, [], 1e-14);
assert_checkequal(mu, [mean(x), stdev(x)]);

y = #(x) -> (x .* (-2 + x));
p = polyfit(x, y(x), 2);
expected = [1 -2 0];
assert_checkalmostequal(p, expected, [], 1e-14);

y = #(x) -> (x.^3 - 3*x.^2 + 2*x + 4);
p = polyfit(x, y(x), 3);
expected = [1 -3 2 4];
assert_checkalmostequal(p, expected, [], 1e-14);

y = #(x) -> (x.^5 + x - 3);
p = polyfit(x, y(x), 5);
expected = [1 0 0 0 1 -3];
assert_checkalmostequal(p, expected, [], 1e-11);

// checkerror
msg = msprintf(_("%s: Wrong number of input argument(s): %d expected.\n"), "polyfit", 3);
assert_checkerror("polyfit()", msg);

msg = msprintf(_("%s: Wrong size of input arguments #%d and #%d: Must have the same size.\n"), "polyfit", 1, 2);
assert_checkerror("polyfit(0:5, 1, 1)", msg);

msg = msprintf(_("%s: Wrong size of input arguments #%d and #%d: Must have the same size.\n"), "polyfit", 1, 2);
assert_checkerror("polyfit(1, 0:5, 1)", msg);

msg = msprintf(_("%s: Wrong size of input argument #%d: 1 x 1 expected.\n"), "polyfit", 3);
assert_checkerror("polyfit(1, 1, 0:2)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Integer numbers expected.\n"), "polyfit", 3);
assert_checkerror("polyfit(1, 1, 0.5)", msg);

msg = msprintf(_("%s: Wrong value for input argument #%d: Non negative numbers expected.\n"), "polyfit", 3);
assert_checkerror("polyfit(1, 1, -2)", msg);