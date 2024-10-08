//<-- CLI SHELL MODE -->
// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2007-2009 - INRIA - Serge STEER <serge.steer@inria.fr>
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

// <-- Non-regression test for bug 4069 -->
// 
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/4069
//
// <-- Short Description -->
// problem in dassl dasrt when the jacobian is given by a list


 function [r,ires]=chemres(t,y,yd ,a,b,c)
     r=[-a*y(1)+b*y(2)*y(3)-yd(1)
         a*y(1)-b*y(2)*y(3)-c*y(2)*y(2)-yd(2)
         y(1)+y(2)+y(3)-1];
     ires=0
  endfunction
  function pd=chemjac(x,y,yd,cj, a,b,c)
      pd=[-a-cj , b*y(3)             , b*y(2);
           a    ,-b*y(3)-2*c*y(2)-cj ,-b*y(2);
           1    , 1                  , 1       ]
  endfunction

a=0.04;b=1d4;c=3d7;
y0=[1;0;0];
yd0=[-0.04;0.04;0];
t=[1.d-5:0.02:.4,0.41:.1:4,40,400,4000,40000,4d5,4d6,4d7,4d8,4d9,4d10];


y1=%_dassl([y0,yd0],0,t,chemres,chemjac);
y2=%_dassl([y0,yd0],0,t,list(chemres),list(chemjac));
y3=%_dassl([y0,yd0],0,t,list(chemres,a,b,c),list(chemjac,a,b,c));

if or(y1<>y2)|or(y1<>y3) then pause,end
