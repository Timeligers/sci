// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises - Adeline CARNIS
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->

// <-- Non-regression test for bug 9385 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/9385
//
// <-- Short Description -->
//    The type checking in trigonometric functions has been added
// =============================================================================

errtype1 = sci2exp("double");
errtype2 = sci2exp(["double", "sparse"]);
assert_checkfalse(execstr("tanm(""x"")"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "tanm", 1, errtype1);
assert_checkerror("tanm(""x"")", refMsg);

assert_checkfalse(execstr("tanhm(""x"")"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "tanhm", 1, errtype2);
assert_checkerror("tanhm(""x"")", refMsg);

assert_checkfalse(execstr("tanh(""x"")"   ,"errcatch") == 0);
refMsg = [msprintf(_("Function not defined for given argument type(s),\n"));msprintf(_("  check arguments or define function %s for overloading.\n"), "%c_tanh")];
assert_checkerror("tanh(""x"")", refMsg);

assert_checkfalse(execstr("tand(""x"")"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "tand", 1, errtype2);
assert_checkerror("tand(""x"")", refMsg);

assert_checkfalse(execstr("sind(""x"")"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "sind", 1, errtype1);
assert_checkerror("sind(""x"")", refMsg);

assert_checkfalse(execstr("sinc(""x"")"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Real or complex, sparse or full matrix or hypermatrix expected.\n"),"sinc",1);
assert_checkerror("sinc(""x"")", refMsg);

assert_checkfalse(execstr("sech(""x"")"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "sech", 1, errtype1);
assert_checkerror("sech(""x"")", refMsg);

assert_checkfalse(execstr("secd(""x"")"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "secd", 1, errtype1);
assert_checkerror("secd(""x"")", refMsg);

assert_checkfalse(execstr("sec(""x"")"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "sec", 1, errtype2);
assert_checkerror("sec(""x"")", refMsg);

assert_checkfalse(execstr("csgn(""x"")"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "csgn", 1, errtype2);
assert_checkerror("csgn(""x"")", refMsg);

assert_checkfalse(execstr("csch(""x"")"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"),"csch", 1, errtype1);
assert_checkerror("csch(""x"")", refMsg);

assert_checkfalse(execstr("cscd(""x"")"   ,"errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "cscd", 1, errtype1);
assert_checkerror("cscd(""x"")", refMsg);

assert_checkfalse(execstr("csc(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "csc", 1, errtype2);
assert_checkerror("csc(""x"")", refMsg);

assert_checkfalse(execstr("cotd(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "cotd", 1, errtype1);
assert_checkerror("cotd(""x"")", refMsg);

assert_checkfalse(execstr("cosd(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "cosd", 1, errtype1);
assert_checkerror("cosd(""x"")", refMsg);

assert_checkfalse(execstr("atand(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Real matrix expected.\n"), "atand", 1);
assert_checkerror("atand(""x"")", refMsg);

assert_checkfalse(execstr("atand(1, ""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Real matrix expected.\n"), "atand", 2);
assert_checkerror("atand(1, ""x"")", refMsg);

assert_checkfalse(execstr("asind(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "asind", 1, errtype1);
assert_checkerror("asind(""x"")", refMsg);

assert_checkfalse(execstr("asech(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "asech", 1, errtype2);
assert_checkerror("asech(""x"")", refMsg);

assert_checkfalse(execstr("asecd(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "asecd", 1, errtype2);
assert_checkerror("asecd(""x"")", refMsg);

assert_checkfalse(execstr("asec(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "asec", 1, errtype2);
assert_checkerror("asec(""x"")", refMsg);

assert_checkfalse(execstr("acsch(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "acsch", 1, errtype2);
assert_checkerror("acsch(""x"")", refMsg);

assert_checkfalse(execstr("acscd(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "acscd", 1, errtype2);
assert_checkerror("acscd(""x"")", refMsg);

assert_checkfalse(execstr("acsc(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "acsc", 1, errtype2);
assert_checkerror("acsc(""x"")", refMsg);

assert_checkfalse(execstr("acoth(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "acoth", 1, errtype2);
assert_checkerror("acoth(""x"")", refMsg);

assert_checkfalse(execstr("acotd(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "acotd", 1, errtype1);
assert_checkerror("acotd(""x"")", refMsg);

assert_checkfalse(execstr("acot(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "acot", 1, errtype1);
assert_checkerror("acot(""x"")", refMsg);

assert_checkfalse(execstr("acosd(""x"")", "errcatch") == 0);
refMsg = msprintf(_("%s: Wrong type for input argument #%d: Must be in %s.\n"), "acosd", 1, errtype1);
assert_checkerror("acosd(""x"")", refMsg);


