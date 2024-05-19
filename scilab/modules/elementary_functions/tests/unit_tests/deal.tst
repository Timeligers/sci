// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - 3DS - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

assert_checkerror("[a, b] = deal(1, 2, 3);", msprintf(gettext("%s: Wrong number of output argument(s): %d expected.\n"), "deal", 3));
assert_checkerror("[a, b, c] = deal(1, 2);", msprintf(gettext("%s: Wrong number of output argument(s): %d expected.\n"), "deal", 2));

[out1] = deal(1);
assert_checkequal(out1, 1);

[out1, out2, out3] = deal(2);
assert_checktrue(and([out1, out2, out3] == 2));

[out1, out2, out3] = deal(1, 2, 3);
assert_checkequal(out1, 1);
assert_checkequal(out2, 2);
assert_checkequal(out3, 3);

st(3).f = [];
[st.f] = deal(3);
assert_checkequal(st(:).f, list(3, 3, 3));
[a, b, c] = deal(st.f(:));
assert_checktrue(and([a, b, c] == 3));

// Cell contents
ce{3} = [];
[ce{:}] = deal("string");
assert_checkequal(ce{:},  list("string", "string", "string"));
[a, b, c] = deal(ce{:}(:));
assert_checktrue(and([a, b, c] == "string"));
