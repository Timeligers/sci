//
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) ????-2008 - INRIA
//
// This file is distributed under the same license as the Scilab package.
//

function demo_lqg()

  mode(-1);
  oldln=lines();
  lines(0);
  //display the diagram
  x=[5,10,20,40,50,70,80,90];xmin=-10;xmax=100;
  y=[22,28,30,32];ymin=12;ymax=40;

  xx=[x([1 2 2 7 4 6 3 4 5 6 3 3 5 5]);x([3,2,7,7,5,8,3,4,5,6,4,4,6,6])];
  yy=[y([3,1,1,1,3,3,2,2,2,2,2,4,2,4]);y([3,3,1,3,3,3,4,4,4,4,2,4,2,4])];

  scf(100001);
  clf();
  show_window();
  a=gca();
  a.data_bounds=[xmin ymin;xmax ymax];
  a.box='on';
  xpolys(xx,yy)
  xstring(28,30,'K');
  xstring(56,30,'Plant');
  xstring(12,28.80,'-');
  xtitle('PLANT   and   CONTROLLER')


  path=get_absolute_file_path('lqg.dem.sce');
  s=poly(0,'s');z=poly(0,'z');
  messagebox(['Simple example of SISO LQG Design';
           'Demo is in file '+path+'lqg.dem.sce';
           'Computes the LQG compensator and plots response'],"modal");

  n=x_choose(['Continuous time';'Discrete time'],'Select time domain');

  select n
  case 0
    return
  case 1
    mode(1)
    s=poly(0,'s');
    str='(s-1)/(s^2-5*s+1)';
    rep=x_dialog('Nominal plant?',str)
    if rep==[] then return,end
    Plant=evstr(rep);
    Plant=syslin('c',Plant);
    mode(-1)
  case 2
    mode(1)
    z=poly(0,'z');
    str='(z+1)/(z^2-5*z+2)'
    rep=x_dialog('Nominal plant?',str)
    if rep==[] then return,end
    Plant=evstr(rep);
    Plant=syslin('d',Plant);
    mode(-1)
  end

  mode(1)

  //Nominal Plant

  P22=tf2ss(Plant);    //...in state-space form
  [ny,nu,nx]=size(P22);
  messagebox('Now enter weighting matrices',"modal");
  rep=x_matrix('x-weighting matrix',eye(nx,nx))
  if rep==[] then return,end
  Qx=evstr(rep);
  rep=x_matrix('u-weighting matrix',eye(nu,nu));
  if rep==[] then return,end
  Qu=evstr(rep);
  bigQ=blockdiag(Qx,Qu);
  rep=x_matrix('x-noise covariance matrix',eye(nx,nx))
  if rep==[] then return,end
  Rx=evstr(rep);
  rep=x_matrix('y-noise covariance matrix',eye(ny,ny))
  if rep==[] then return,end
  Ry=evstr(rep);
  bigR=blockdiag(Rx,Ry);
  [Plqg,r]=lqg2stan(P22,bigQ,bigR);     //LQG pb as a standard problem
  Klqg=lqg(Plqg,r);                     //LQG compensator

  disp(spec(h_cl(Plqg,r,Klqg)),'closed loop eigenvalues:');    //Check internal stability
  [Slqg,Rlqg,Tlqg]=sensi(P22,Klqg);  //Sensitivity functions

  disp(clean(ss2tf(Slqg)),'Sensitivity function');
  disp(clean(ss2tf(Tlqg)),'Complementary sensitivity function');

  mode(-1);

  messagebox('Closed-loop response',"modal");

  resp=['Frequency response';'Time response'];
  while %t do
    n=x_choose(resp,'Select response(s)');
    select n
    case 0
      disp("LQG demo stops!");break;
    case 1 then
      mode(1)
      scf(100001);
      clf();
      show_window();
      bode(Tlqg);
      mode(-1)
    case 2
      if Plant(4)=='c' then
        mode(1)
        defv=['0.1';'20'];
        _title='Enter Sampling period and Tmax';
        rep=x_mdialog(_title,['Sampling period?';'Tmax?'],defv)
        if rep==[] then break,end
        dttmax=evstr(rep)
        dt=evstr(dttmax(1));
        tmax=evstr(dttmax(2));
        t=0:dt/5:tmax;
        n1=x_choose(['Step response?';'Impulse response?'],'Simulation:');
        select n1
        case 1 then
          scf(100002);
          clf();
          show_window();
          plot2d([t',t'],[(csim('step',t,Tlqg))',ones(t')]);
        case 2 then
          scf(100002);
          clf();
          show_window();
          plot2d([t',t'],[(csim('impul',t,Tlqg))',0*t']);
        end
        mode(-1)
      elseif Plant(4)=='d' then
        mode(1)
        defv=['30'];
        _title='Tmax?';
        rep=x_mdialog(_title,['Tmax='],defv)
        if rep==[] then break,end
        Tmax=evstr(rep);
        mode(-1)
        n2=x_choose(['Step response?';'Impulse response?'],'Simulation:');
        select n2
        case 0 then
        break;
        case 1 then
          mode(1)
          u=ones(1,Tmax);u(1)=0;
          scf(100002);clf();show_window();
          plot2d([(1:Tmax)',(1:Tmax)'],[(dsimul(Tlqg,u))',(ones(1:Tmax)')])
          mode(-1)
        case 2 then
          mode(1)
          u=zeros(1,Tmax);u(1)=1;
          scf(100002);clf();show_window();
          plot2d((1:Tmax)',(dsimul(Tlqg,u))')
          mode(-1)
        end
      end
    end
  end
  lines(oldln(2))
endfunction

demo_lqg()
clear demo_lqg;
