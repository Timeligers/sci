//
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA
//
// This file is distributed under the same license as the Scilab package.
//

function demo_mixed()
  mode(-1)
  lines(0);
  //display the diagram
  x=[5,10,20,40,50,70,80,90];xmin=-10;xmax=100;
  y=[22,28,30,32];ymin=12;ymax=40;

  xx=[xmin,xmin,x([1 2 2 7 4 6 3 4 5 6 3 3 5 5]);xmax,xmax,x([3,2,7,7,5,8,3,4,5,6,4,4,6,6])];
  yy=[ymin,ymax,y([3,1,1,1,3,3,2,2,2,2,2,4,2,4]);ymin,ymax,y([3,3,1,3,3,3,4,4,4,4,2,4,2,4])];

  scf(100001);clf();show_window();
  plot2d(xx,yy,ones(1,16),'022');
  xstring(28,30,'K');xstring(56,30,'Plant');xstring(12,28.80,'-');
  xtitle('PLANT   and   CONTROLLER')
  mode(2)

  path=get_absolute_file_path('mixed.dem.sce');
  messagebox(['Mixed Sensitivity Controller Design';
           'file: '+path+'mixed.dem.sce'],"modal");
  mode(1)
  s=poly(0,'s');
  str='[(s-1)/((s-1)^2*(s+2))]';
  rep=x_dialog('Nominal plant?',str)
  if rep==[] then return,end
  Plant=evstr(rep);Plant=syslin('c',Plant);
   //Nominal Plant
  P22=tf2ss(Plant);    //...in state-space form
  [ny,nu,nx]=size(P22);
  [Pms,r]=augment(P22);
  txt=['W1 (sensitivity function S)';'W2 (K*S)';'W3 (complementary sensitivity T)'];
  default=['s';'1';'1'];
  while %t
    rep=x_mdialog('Set weighting functions',txt,default);
    if rep==[] then return;end
    W1=evstr(rep(1));W2=evstr(rep(2));W3=evstr(rep(3));
    default=rep;
    Pms=blockdiag(W1,W2,W3,eye(P22))*Pms;
    gms=['gamma min= ';'gamma max= ';'# iterations'];
    vals=['0.01';'1000';'50'];
    reps=x_mdialog('Set interval for gamma and #iterations',gms,vals);
    if reps==[] then return;end
    mumin=1/evstr(reps(2))^2;
    mumax=1/evstr(reps(1))^2;
    iter=evstr(reps(3));
    [K,mu]=h_inf(Pms,r,mumin,mumax,iter);
    if K~=[] then break;end
  end

  disp(spec(h_cl(Pms,r,K)),'closed loop eigenvalues')    //Check internal stability
  [Ssens,Rsens,Tsens]=sensi(P22,K);  //Sensitivity functions
  messagebox('Singular values plot',"modal");
  fcts=['S function';'R (=K*S) function';'T function'];
  www=x_mdialog('Select sensitivity function',fcts,['Yes';'No';'Yes']);
  if www==[] then return,end

  ww1=part(www(1),1)=='Y';
  if ww1 then
    scf(100002);clf();show_window();
    gainplot(Ssens);
    xtitle('S = Sensitivity function');
  end

  ww2=part(www(2),1)=='Y';
  if ww2 then
    scf(100003);clf();show_window();
    gainplot(Rsens);
    xtitle('R (=G*S) Sensitivity function');
  end

  ww3=part(www(3),1)=='Y';
  if ww3 then
    scf(100004);clf();show_window();
    gainplot(Tsens);
    xtitle('T = Complementary Sensitivity function');
  end

endfunction

demo_mixed();
clear demo_mixed;
