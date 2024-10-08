// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2012 - S/E - Sylvestre Ledru
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->

filename=TMPDIR+"/test_matfile.mat";

A = rand(10,10);
B = sprand(100,100,0.1);
C = "foo";
D = "bar";
savematfile(filename,'A','B','C','D','-v6');
clear();
filename=TMPDIR+"/test_matfile.mat";
fd = matfile_open(filename);
[name, classes, types]=matfile_listvar(fd);
assert_checkequal(matfile_close(fd), %t);

assert_checkequal(name(1), "A");
assert_checkequal(name(2), "B");
assert_checkequal(name(3), "C");
assert_checkequal(name(4), "D");

assert_checkequal(types(1), 9);
assert_checkequal(types(2), 9);
assert_checkequal(types(3), 16);
assert_checkequal(types(4), 16);

assert_checkequal(classes(1), 6);
assert_checkequal(classes(2), 5);
assert_checkequal(classes(3), 4);
assert_checkequal(classes(4), 4);
