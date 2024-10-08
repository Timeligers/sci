// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2018 - UTC - Stéphane MOTTELET
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- CLI SHELL MODE -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for bug 15733 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/15733
//
// <-- Short Description -->
// Failing unit and NR tests after deg(0*%s) = -%inf

sys = cont_frm(1,0*%s)
assert_checktrue(isnan(sys.D))
assert_checkequal(dtsi(syslin('c',0*%s,0*%s)),syslin('c',0,1))
assert_checkerror("evans(0*%s,1)", msprintf(_("%s: The given system has no poles and no zeros.\n"),"evans"))
assert_checkerror("flts(1,syslin(''d'',1,0*%s))", msprintf(_("Problem is singular.\n")));
assert_checkequal(gtild(0*%s,'d'),0*%s)
assert_checkequal(tf2ss(syslin('c',1,0*%s)),syslin('c',[],[],[],%inf))
assert_checktrue(isempty(tf2zp(syslin('c',1,0*%s))))
assert_checkequal(polfact(0*%s),0)
Ar=armac([1,-1,-2].*.eye(2,2),[1,2,3,-4,-5,-6,7,8,9].*.[1;1],[eye(2,2)],2,3,0);
u= (1:4).*.ones(3,1);
assert_checkequal(narsimul(Ar,u),[6,3,27,60].*.[1;1])
assert_checkerror("[0*%s]^-2", msprintf(_("%s: Wrong value for input argument #%d: A non null denominator expected.\n"), "simp", 2))
assert_checkerror("[0*%s].^-2", msprintf(_("%s: Division by 0...\n"), "%p_j_s"))
assert_checkerror("[0*%s/(1+0*%s)]^-2" ,msprintf(_("%s: Wrong value for input argument #%d: A non null denominator expected.\n"), "simp", 2))
assert_checkerror("[0*%s/(1+0*%s)].^-2", _("Division by zero"))
assert_checkequal(diophant(%s*[0 0],0*%s),%s*[0 0]+1)
assert_checkequal(horner([0 0]*%s,[0 0]),zeros(1,4))
assert_checkequal(sylm(0*%s,0*%s), [])
assert_checkequal(trans(%z*0/(1+%z),'lp',[.1 .2]),rlist(0,1,'d'))
assert_checkequal(mtlb_filter(0,1,1),0)
