// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2013 - Scilab Enterprises
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- CLI SHELL MODE -->
// <-- ENGLISH IMPOSED -->

// <-- Non-regression test for bug 12948 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/12948
//
// <-- Short Description -->
// When host is not found, getURL provokes a Crash To Desktop

instr = "getURL(''https://www.scilab-dummy.org'', ''scilab_homepage.html'');";
if getos() == 'Windows' then
  errReason = "Could not resolve host: www.scilab-dummy.org; Host not found";
else
  errReason = "Couldn''t resolve host ''www.scilab-dummy.org''";
end
errMsg =  msprintf(gettext("Transfer did not complete successfully: %s\n"), errReason);

assert_checkerror(instr, errMsg);
