// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) INRIA -
// Copyright (C) 2012 - 2016 - Scilab Enterprises
// Copyright (C) 2016, 2017, 2019, 2021 - Samuel GOUGEON
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function t=sci2exp(a,nom,lmax)
    // sci2exp - convert a variable to an expression
    //%SYNTAX
    // t=sci2exp(a [,nam] [,lmax])
    //%PARAMETERS
    //   a  : matrix of scalar or polynomials
    //   nam: character string
    //   t  : vector of string, contains the expression definition
    //   lmax : maximum line lengh (0 for no line length control)
    //%Example
    //  a=[1 2;3 4]
    //  sci2exp(a,'aa')
    //!

    deff("x=String(a)",["x=string(a)"
    "x=strsubst(x,''Nan'',''%nan'')"
    "x=strsubst(x,''Inf'',''%inf'')"
    ])


    [lhs,rhs]=argn(0)
    $ // import global variable $ in sci2exp context for efficiency
    select rhs
    case 1 then
        named=%f
        lmax=0
    case 2 then
        if type(nom)==1 then
            lmax=nom
            named=%f
        else
            named=%t
            lmax=0
        end
    case 3 then
        named=%t
        if type(nom)==1 then
            [lmax,nom]=(nom,lmax)
        end
    end

    // For an hypermatrix, we concatenate all components in a single row:
    hyperMat = or(type(a)==[1 2 4 8 10] | typeof(a) == "ce") && ndims(a) > 2;
    if hyperMat then
        s = size(a);
        a = matrix(a,1,-1);
    end

    dots="..";

    select type(a)
    case 1 then
        t=mat2exp(a,lmax)
    case 2 then
        t=pol2exp(a,lmax)
    case 4 then
        t=log2exp(a,lmax)
    case 5 then
        t=sp2exp(a,lmax)
    case 6 then
        t=sp2exp(a,lmax)
    case 7 then
        t=sp2exp(a,lmax)
    case 8 then
        t=int2exp(a,lmax)
    case 9 then
        t=h2exp(a, lmax)
    case 10 then
        t=str2exp(a,lmax)
    case 13 then
        tree=macr2tree(a);
        strfun=tree2code(tree);
        name="%fun";
        if named then
            name=nom;
        end
        strfun(1) = strsubst(strfun(1), tree.name+"(", name+"(");
        strfun($)=[];
        t=strfun;
        t(1) = part(t(1),10:length(t(1)))
        t($) = [];
        t = sci2exp(t, lmax);
        t(1) = "createfun(" + t(1);
        t($) = t($) + ")";
    case 15 then
        t = list2exp(a, lmax);
    case 16 then
        if typeof(a)=="rational"
            t = rlist2exp(a, lmax);
        else
            t = tlist2exp(a, lmax);
        end
    case 17 then            // cells, struct, mlists
        if typeof(a)=="st"
            t = struct2exp(a, lmax);
        elseif typeof(a) == "ce" then
            t = cell2exp(a, lmax);
        else
            t = mlist2exp(a, lmax);
        end
    case 128 then
        t = mlist2exp(user2mlist(a), lmax);
    case 129 then
        t = imp2exp(a, lmax);
    else
        //  execstr('t='+typeof(a)+'2exp(a,lmax)')
        msg = _("%s: This feature has not been implemented: Variable translation of type %s.\n");
        error(msprintf(msg, "sci2exp", string(type(a))));
    end
    // Post-processing:
    if hyperMat then
        s = strcat(msprintf("%d\n",s(:)), ",");  // Literal list of sizes
        if lmax>0
            if length(t(1)) > (lmax-8)
                t = ["matrix(.."; t];
            else
                t(1) = "matrix("+t(1);
            end
            if length(t($)) > (lmax-length(s)-5)
                t($) = t($)+",..";
                t = [t ; "["+s+"])"];
            else
                t($) = t($)+", ["+s+"])";
            end
        else
            t = "matrix(" + t + ", ["+s+"])";
        end
    end
    if named & and(type(a)<>13) then
        t(1) = nom + " = " + t(1)
    end
endfunction

function t=str2exp(a,lmax)
    if rhs<2 then lmax=0,end
    [lhs,rhs]=argn(0)

    [m,n]=size(a),
    dots="."+"."
    t=[];
    quote="''"

    a=strsubst(a,quote,quote+quote)
    dquote=""""
    a=strsubst(a,dquote,dquote+dquote)
    a = strsubst(a, ascii(10), """+ascii(10)+""")
    a=quote(ones(a))+a+quote(ones(a))

    for i=1:m
        x=emptystr();
        for j=1:n,
            y=a(i,j);
            y=dquote+part(y,2:length(y))
            y=part(y,1:length(y)-1)+dquote
            if y=="''''" then y="emptystr()",end
            if lmax==0|length(x($))+length(y)<lmax then
                if j==1 then
                    x=y
                else
                    x($)=x($)+","+y,
                end
            else
                if j>1 then
                    x($)=x($)+","+dots;
                    x($+1)=y
                else
                    x=y
                end
            end
        end
        if i<m then x($)=x($)+";",end
        if lmax>0 then
            t=[t;x]
        elseif isempty(t) then
            t = x;
        else
            t=t+x
        end
    end,
    if lmax>0&sum(length(t))<lmax then
        t=strcat(t)
    end
    if m*n>1 then
        t(1)="["+t(1)
        t($)=t($)+"]"
    end
endfunction

function t = mat2exp(a,lmax)
    if rhs<2 then lmax=0,end
    [lhs,rhs]=argn(0)
    if size(a,"*")==0 then t="[]",return,end
    [m,n]=size(a);

    // Special case #1: eye() and its multiples
    if m<0 then
        t = mat2exp(a(1));
        if t=="1" then
            t="eye()";
        else
            if imag(a(1))<>0 & part(t,1:8)<>"complex("
                t = "(" + t + ")"
            end
            t = t + "*eye()"
        end
        return
    end

    // Special case #2: Complex with Inf or Nan parts
    // Process issue 16317
    if or(isinf(imag(a))) | or(isnan(imag(a)))
        ar = sci2exp(real(a),lmax)
        ai = sci2exp(imag(a),lmax)
        if ~lmax | 10+length(ar)+length(ai) <= lmax
            t = "complex("+ar+"," + ai +")"
        else
            if 7+length(ar(1)) <= lmax
                ar(1) = "complex(" + ar(1);
            else
                ar = ["complex(.." ; ar]
            end
            ar($) = ar($) + ","
            ai($) = ai($) + ")"
            t = [ar ; ai]
        end
        return
    end

    // Regular case
    a=String(a);
    dots="."+"."
    t="";
    if n==1 then
        x=strcat(a,";")
        lx=length(x)
        if lmax==0|lx<lmax then
            t=x;
        else
            ind=strindex(x,";");
            k1=1;l=0;I=[];
            while %t
                if lx-l<lmax|k1>length(ind) then,break,end
                found = find(ind(k1:$)<l+lmax);
                if found then
                    k2=k1-1+max(found);
                else
                    // keep the element size in case where
                    // the element is bigger than lmax
                    k2=k1
                end
                I=[I ind(k2)];
                k1=k2+1
                l=ind(k2)
            end
            t=[t;strsplit(x,I)];
        end
    elseif m==1 then
        x=strcat(a,",")
        lx=length(x)
        if lmax==0|lx<lmax then
            t=x;
        else
            ind=strindex(x,",");
            k1=1;l=0;I=[];
            while %t
                if lx-l<lmax|k1>length(ind) then break,end
                found = find(ind(k1:$)<l+lmax);
                if found then
                    k2=k1-1+max(found);
                else
                    // keep the element size in case where
                    // the element is bigger than lmax
                    k2=k1
                end
                I=[I ind(k2)];
                k1=k2+1
                l=ind(k2)
            end
            x=strsplit(x,I);
            x(1:$-1)=x(1:$-1)+dots;
            t=[t;x]
        end
    else
        for i=1:m
            x=strcat(a(i,:),",")
            if i<m then x=x+";",end
            lx=length(x)
            if lmax==0 then
                t=t+x
            elseif lx<lmax then
                t=[t;x]
            else
                ind=strindex(x,",");
                k1=1;l=0;I=[];
                while %t
                    if lx-l<lmax|k1>length(ind) then break,end
                    k2=k1-1+max(find(ind(k1:$)<l+lmax))
                    I=[I ind(k2)];
                    //	  t=[t;part(x,l+1:ind(k2))+dots]
                    k1=k2+1
                    l=ind(k2)
                end
                x=strsplit(x,I);x(1:$-1)=x(1:$-1)+dots;x(2:$)=" "+x(2:$);
                t=[t;x]
            end
        end
    end
    if m*n>1 then
        t(1)="["+t(1)
        t($)=t($)+"]"
    end
endfunction

function t=pol2exp(a,lmax)
    $
    if rhs<2 then lmax = 0, end
    [lhs,rhs] = argn(0)

    [m,n] = size(a)
    var = " ";
    lvar = 1;
    var = varn(a);
    if or(var==["s" "z"]) then
        var = "%"+var;
    end
    lvar=length(var);
    while part(var,lvar)==" " then lvar=lvar-1,end
    var=part(var,1:lvar);

    // polynomial eye()
    if m<0 then
        t = pol2exp(a(1))
        t = "(" + t + ")*eye()"
        return
    end

    t=[];
    for i=1:m
        x=emptystr(1)
        for j=1:n,
            v=a(i,j);d=max(0,degree(v));
            v=coeff(v);
            k0=1;while (k0<d+1)&(v(k0))==0 then k0=k0+1,end
            y=emptystr(1)
            nul=%t
            for k=k0:(d+1),
                s=String(v(k))
                if s<>"0" then
                    nul=%f
                    if part(s,1)==" " then s=part(s,2:length(s)),end
                    mnm=emptystr(1)
                    if k>0 then
                        mnm=var
                        if k>2 then
                            mnm=mnm+"^"+string(k-1),
                        end
                    end
                    if k>1 then
                        if string(imag(v(k)))<>"0" then s="("+s+")",end
                        if s=="1" then
                            s=mnm
                        elseif s=="-1" then
                            s="-"+mnm
                        else
                            s=s+"*"+mnm
                        end
                        if k>k0&part(s,1)<>"-" then s="+"+s,end
                    end
                    if lmax==0|length(y($))+length(s) <lmax then
                        y($)=y($)+s
                    else
                        y($)=y($)+dots
                        y($+1)=s
                    end
                end
            end
            if nul then y="0*"+var,end
            [ny,my]=size(y)

            if lmax==0|length(x($))+length(y(1))<lmax then
                if j==1 then
                    x=y(1)
                else
                    x($)=x($)+","+y(1),
                end
                if ny>1 then x($+1:$+ny-1)=y(2:ny),end
            else
                if length(x($))==0 then
                    x($:$+ny-1) = y;
                else
                    x($)=x($)+","+dots;
                    x($+1:$+ny)=y
                end
            end
        end
        if i<m then x($)=x($)+";",end
        if lmax>0 | t==[] then
            t=[t;x]
        else
            t=t+x
        end
    end,
    if lmax>0&sum(length(t))<lmax then
        t=strcat(t)
    end
    if m*n>1 then
        t(1)="["+t(1)
        t($)=t($)+"]"
    end
endfunction

function t = list2exp(l, lmax)
    t = glist2exp("list", l, lmax)
endfunction
function t = mlist2exp(l, lmax)
    t = glist2exp("mlist", l, lmax)
endfunction
function t = tlist2exp(l, lmax)
    t = glist2exp("tlist", l, lmax)
endfunction
function t = rlist2exp(l, lmax)
    t = sci2expAdd("rlist(", sci2exp(l.num, lmax))
    t($) = t($)+","
    t = sci2expAdd(t, sci2exp(l.den, lmax))
    t($) = t($)+")"
endfunction

function r = sci2expAdd(head,t,lmax)
    h = head($)
    if ~lmax | length(h+t(1))<=lmax then
        head($) = h + t(1)
        r = [head ; t(2:$)]
    else
        r = [head + "."+"." ; t]
    end
endfunction

function t = glist2exp(listType, l, lmax)
    [lhs,rhs] = argn(0)
    if rhs<3 then lmax = 0, end
    dots = "."+".";
    t = listType + "("
    if or(listType==["list", "mlist", "tlist"]) then
        L = length(l)
    else
        L = size(getfield(1,l),"*");
    end
    for k = 1:L
        sep = ",", if k==1 then sep = "", end
        clear lk
        if listType ~= "mlist"
            lk = l(k)
        else
            try
                lk = getfield(k,l)
            catch
            end
        end
        if ~isdef("lk","local") | type(lk)==0
            t1 = ""  // undefined element as in list(2,,5)
        else
            t1 = sci2exp(lk, lmax)
        end
        if size(t1,"*")==1 & (lmax==0|max(length(t1))+length(t($))<lmax) then
            t($) = t($)+sep+t1
        else
            t($) = t($)+sep+dots
            t = [t; t1]
        end
    end

    t($) = t($)+")"

endfunction

function t = cell2exp(l, lmax)
    if argn(2)<2 then lmax = 0, end
    dots = "."+".";
    [m, n]=size(l);
    s = m * n;
    if s == 0 then
        t = "{}"
        return
    end
    t = "{";
    if m > 1 && n > 1 then
        L = m
    else
        L = 1 
    end

    l = l{:}
    for ki = 1:m
        for kj = 1:n
            sep = ",", if kj==1 then sep = "", end
            lk = l(ki+L*(kj-1))
            t1 = sci2exp(lk, lmax)
            if size(t1,"*")==1 & (lmax==0|max(length(t1))+length(t($))<lmax) then
                t($) = t($)+sep+t1
            else
                t($) = t($)+sep+dots
                t = [t; t1]
            end
        end
        if ki * kj < s then
            t($) = t($)+";";
        end
    end
    t($) = t($) + "}";
endfunction

function t = struct2exp(l, lmax)
    if argn(2)<2 then lmax = 0, end
    dots = "."+".";
    stSize = size(l);
    stIsScalar = isscalar(l);
    t = "struct(";
    if ~stIsScalar & (stSize(1)>1 | length(stSize)>2)
        t = "matrix(" + t;
    end
    fields = fieldnames(l);
    n = size(fields,"*");
    for i = 1:n
        if ~lmax | lmax>(length(t($))+length(fields(i))+3)
            t($) = t($) + """"+fields(i)+""",";
        else
            t($) = t($) + "" + dots;
            t = [t; """"+fields(i)+""","];
        end
        clear lk
        lk = l(fields(i));
        if ~isdef("lk","local") | type(lk)==0
            t1 = "";
        else
            t1 = sci2exp(lk, lmax)
            if ~stIsScalar  // "list(..)" => "{..}"
                if size(t1,1)==1
                    t1 = "{" + part(t1,6:$-1) + "}"
                else
                    t1 = ["{" + part(t1(1),6:$)
                          t1(2:$-1)
                          part(t1($),1:$-1) + "}"
                          ]
                end
            end
        end
        if i<n then
            tmp = ", ";
        else
            tmp = "";
        end
        if size(t1,"*")==1&(lmax==0|max(length(t1))+length(t($))<lmax) then
            t($) = t($) + t1 + tmp;
        else
            t($) = t($) + "..";
            t = [t; t1 + tmp]
        end
    end
    t($) = t($)+")"
    if ~stIsScalar & (stSize(1)>1 | length(stSize)>2)   // matrix(.., sizes)
        t($) = t($) + ",[" + strcat(msprintf("%d\n",stSize(:))," ") + "])"
    end
endfunction

function t=log2exp(a,lmax)
    $;
    if rhs<2 then lmax = 0, end
    [lhs,rhs] = argn(0)
    [m,n]=size(a),
    a1=matrix(a,m*n,1)
    F="%f"
    T="%t"
    a=F(ones(m*n,1))
    k=find(a1);
    if k<>[] then
        a(k)=T(ones(size(k,"*"),1));
    end
    a=matrix(a,m,n);
    dots="."+"."
    t=[];
    for i=1:m
        x=emptystr()
        for j=1:n,
            y=a(i,j);
            if lmax==0|length(x($))+length(y)<lmax then
                if j==1 then
                    x=y
                else
                    x($)=x($)+","+y,
                end
            else
                x($)=x($)+","+dots;
                x($+1)=y
            end
        end
        t=[t;x]
    end,
    if lmax==0|lmax>0&sum(length(t))<lmax then
        t=strcat(t,";")
    end
    if m*n>1 then
        t(1)="["+t(1)
        t($)=t($)+"]"
    end

endfunction

function t=func2exp(a,lmax)
    if rhs<2 then lmax=0,end
    [lhs,rhs]=argn(0)
    [out,in,text]=string(a)
    if out==[] then out=emptystr(),end
    text=str2exp(text,lmax)
    nt=size(text,"*")
    if named then mac=nom,else mac="mac",end
    if nt==1 then
        t="deff(''["+strcat(out,",")+"]="+mac+"("+strcat(in,",")+")'',"+text+")"
    else
        text($)=text($)+")"
        semi=";"
        text(1:$-1)=text(1:$-1)+semi(ones(nt-1,1))'
        t=["deff(''["+strcat(out,",")+"]="+mac+"("+strcat(in,",")+")'',"+text(1)
        text(2:$)]
    end
endfunction

function t=imp2exp(a,lmax)
    if rhs<2 then lmax=0,end
    [lhs,rhs]=argn(0)
    v=[a(1),a(2),a(3)]
    if a(2)==1 then
        t=sci2exp(a(1))+":"+sci2exp(a(3))
    else
        t=sci2exp(a(1))+":"+sci2exp(a(2))+":"+sci2exp(a(3))
    end
endfunction

function t=sp2exp(a,lmax)
    if rhs<2 then lmax=0,end
    [lhs,rhs]=argn(0)
    dots="..";
    [ij,v,mn]=spget(a)
    t=sci2exp(ij,lmax)
    v=sci2exp(v,lmax)
    mn=sci2exp(mn,lmax)

    t(1)="sparse("+t(1)
    if lmax==0|length(t($))+length(v(1))+1<lmax then
        t($)=t($)+","+v(1)
        t=[t;v(2:$)]

    else
        t($)=t($)+","+dots
        t=[t;v]
    end
    if lmax==0|length(t($))+length(mn(1))+1<lmax then
        t($)=t($)+","+mn(1)
        t=[t;mn(2:$)]
    else
        t($)=t($)+","+dots
        t=[t;mn]
    end
    t($)=t($)+")"
endfunction


function t = int2exp(a,lmax)
    it=inttype(a)
    if it>10 then f="uint",else f="int",end
    f=f+string(8*modulo(it,10))
    tmp = format()
    format("v",22)    // be sure to not truncate big uint64
    t = mat2exp(double(a),lmax)
    format(tmp([2 1]))
    t(1)=f+"("+t(1)
    t($)=t($)+")"
endfunction


function t=h2exp(a,lmax) //Only for figure and uicontrol
    $;
    if rhs<2 then lmax=0
    end
    [lhs,rhs]=argn(0);

    f1="''parent'', ";
    f2="''children'', ";
    f3="''BackgroundColor'', ";
    f4="''Enable'', ";
    f5="''fontAngle'', ";
    f6="''fontName'', ";
    f7="''fontSize'', ";
    f8="''fontUnits'', ";
    f9="''fontWeight'', ";
    f10="''ForegroundColor'', ";
    f11="''HorizontalAlignment'', ";
    f12="''ListboxTop'', ";
    f13="''Max'', ";
    f14="''Min'', ";
    f15="''Position'', ";
    f16="''Relief'', ";
    f17="''SliderStep'', ";
    f18="''String'', ";
    f19="''Style'', ";
    f20="''TooltipString'', ";
    f21="''Units'', ";
    f22="''Value'', ";
    f23="''VerticalAlignment'', ";
    f24="''Visible'', ";
    f25="''Callback'', ";
    f26="''Callback_Type'', ";
    f27="''Handle_Visible'', ";
    f28="''Userdata'', ";
    f29="''Tag'', ";
    f30="''figure_position'', ";
    f31="''figure_size'', ";
    f32="''axes_size'', ";
    f33="''auto_resize'', ";
    f34="''viewport'', ";
    f35="''figure_name'', ";
    f36="''figure_id'', ";
    f37="''info_message'', ";
    f38="''color_map'', ";
    f40="''pixel_drawing_mode'', ";
    f41="''anti_aliasing'', ";
    f42="''immediate_drawing'', ";
    f43="''background'', ";
    f44="''rotation_style'', ";
    f45="''event_handler'', ";
    f46="''event_handler_enable'', ";
    f47="''resizefcn'', ";
    f48="''closerequestfcn'', ";
    x="";


    if a.type=="uicontrol"
        f="uicontrol";
        if a.BackgroundColor <> [0.8 0.8 0.8] then
            if type(a.BackgroundColor)==1 then
                f3_strg=String(a.Backgroundcolor);
                f3_strg="["+f3_strg(1)+" "+f3_strg(2)+" "+f3_strg(3)+"]";
                x=x+f3+f3_strg+", ";
            else
                f3_strg=a.BackgroundColor;
                x=x+f3+"''"+f3_strg+"''"+", ";
            end
        end
        if a.Enable <> "on" then x=x+f4+"''"+a.Enable+"''"+", "; end
        if a.fontAngle <> "normal" then x=x+f5+"''"+a.fontAngle+"''"+", "; end
        if a.fontName <> "helvetica" then x=x+f6+"''"+a.fontName+"''"+", "; end
        f7_strg=String(a.fontSize);
        if a.fontSize <> 10 then x=x+f7+f7_strg+", "; end
        if a.fontUnits <> "points" then x=x+f8+"''"+a.fontUnits+"''"+", "; end
        if a.fontWeight <> "normal" then x=x+f9+"''"+a.fontWeight+"''"+", "; end
        if a.foregroundColor <>[0 0 0] then
            if type(a.ForegroundColor)==1 then
                f10_strg=String(a.foregroundColor);
                f10_strg="["+f10_strg(1)+" "+f10_strg(2)+" "+f10_strg(3)+"]";
                x=x+f10+f10_strg+" ,";
            else
                f10_strg=a.ForegroundColor;
                x=x+f10+"''"+f10_strg+"''"+", ";
            end
        end
        if a.HorizontalAlignment <> "center" then x=x+f11+"''"+a.horizontalAlignment+"''"+", "; end
        f12_strg=String(a.ListBoxTop);
        if a.ListBoxTop <>[] then x=x+f12+f12_strg+", "; end
        f13_strg=String(a.Max);
        if a.max<> 1 then x=x+f13+f13_strg+", "; end
        f14_strg=String(a.Min);
        if a.min<> 0 then x=x+f14+f14_strg+", "; end
        if a.Position <>[20 40 40 20] then
            if type(a.Position)==1 then
                f15_strg=String(a.Position);
                f15_strg="["+f15_strg(1)+" "+f15_strg(2)+" "+f15_strg(3)+" "+f15_strg(4)+"]";
                x=x+f15+f15_strg+", ";
            else
                f15_strg=a.Position;
                x=x+f15+"''"+f15_strg+"''"+", ";
            end
        end
        x=x+f16+"''"+a.Relief+"''"+", ";
        f17_strg=String(a.sliderStep); f17_strg="["+f17_strg(1)+" "+f17_strg(2)+"]";
        if a.sliderStep <> [0.01 0.1] then x=x+f17+f17_strg+", "; end
        if a.String <>"" then
            if isempty(a.String)
                x = x + f18 + "'''' ,";
            else
                x=x+f18+"''"+a.String+"''"+" ,";
            end
        end
        if a.Style <> "pushbutton" then x=x+f19+"''"+a.Style+"''"+", "; end
        if a.TooltipString <> "" then x=x+f20+"''"+a.TooltipString+"''"+", "; end
        if a.Units <> "pixels" then x=x+f21+"''"+a.Units+"''"+", "; end
        if a.Value<>[] then
            f22_strg=String(a.value);
            f22l=length(a.value);
            for i=1:f22l
                f22_strg=strcat(f22_strg, ",");
                f22_strg="["+f22_strg+"]";
            end
            x=x+f22+", "+f22_strg+", ";
        end
        if a.VerticalAlignment <> "middle" then x=x+f23+"''"+a.VerticalAlignment+"''"+", "; end
        if a.Visible <> "on" then x=x+f24+"''"+a.Visible+"''"+", "; end
        if a.Callback <>"" then x=x+f25+"''"+a.Callback+"''"+" ,"; end
        f26_strg=String(a.Callback_Type);
        if a.Callback_Type <> -1 then x=x+f26+f26_strg+", "; end
        if a.Handle_Visible <> "on" then x=x+f27+"''"+a.Handle_Visible+"''"+", "; end
        if a.Userdata <>[] then
            if type(a.userdata) == 1 then
                f28_strg=mat2exp(a.userdata,0)
            elseif type(a.userdata) == 2 then
                f28_strg=pol2exp(a.userdata,0)
            elseif type(a.userdata) == 4 then
                f28_strg=log2exp(a.userdata,0)
            elseif type(a.userdata) == 5 | type(a.userdata) == 6 | type(a.userdata) == 7 then
                f28_strg=sp2exp(a.userdata,0)
            elseif type(a.userdata) == 8 then
                f28_strg=int2exp(a.userdata,0)
            elseif type(a.userdata) == 9 then
                f28_strg=h2exp(a.userdata,0)
            elseif type(a.userdata) == 10 then
                f28_strg=str2exp(a.userdata,0)
            elseif type(a.userdata) == 13 then
                if named then
                    f28_strg=sci2exp(a.userdata,nom)
                else
                    f28_strg=sci2exp(a.userdata,"%fun")
                end
            elseif type(a.userdata) == 15 then
                f28_strg=list2exp(a.userdata);
            elseif type(a.userdata) == 16 then
                f28_strg=tlist2exp(a.userdata,0);
            elseif type(a.userdata) == 17 then
                f28_strg=mlist2exp(a.userdata,0);
            elseif type(a.userdata) == 129 then
                f28_strg=imp2exp(a.userdata,0);
            end
            x=x+f28+f28_strg+", ";
        end
        if a.Tag<>"" then x=x+f29+"''"+a.Tag+"''"+", "; end
        lx=length(x);
        x=part(x,1:lx-2);
        t(1)=f+"("+x;
        t(1)=t(1)+")";
        dots="."+".";
        lt=length(t(1))
        if lt>lmax & lmax<>0 then
            ind=strindex(x,",");
            k1=1;l=0;I=[];
            while %t
                if lt-l<lmax|k1>length(ind) then break,end
                k2=k1-1+max(find(ind(k1:$)<l+lmax))
                I=[I ind(k2)];
                k1=k2+1
                l=ind(k2)
            end
            t=strsplit(t(1),I);
            t(1:$-1)=t(1:$-1)+dots;
        end


    elseif a.type == "Figure" then
        f="figure";
        f30_strg=String(a.figure_position);
        f30_strg="["+f30_strg(1)+" "+f30_strg(2)+"]";
        if a.figure_position <> [] then x=f30+f30_strg+", "; end
        f31_strg=String(a.figure_size);
        f31_strg="["+f31_strg(1)+" "+f31_strg(2)+"]";
        if a.figure_size <> [] then x=x+f31+f31_strg+", "; end
        f32_strg=String(a.axes_size);
        f32_strg="["+f32_strg(1)+" "+f32_strg(2)+"]";
        if a.axes_size <> [] then x=x+f32+f32_strg+", "; end
        if a.auto_resize<>"on" then x=x+f33+"''"+a.auto_resize+"''"+", "; end
        f34_strg=String(a.viewport);
        f34_strg="["+f34_strg(1)+" "+f34_strg(2)+"]";
        if a.viewport <>[0 0] then x=x+f34+f34_strg+", "; end
        if a.figure_name<>"Figure n°%d" then x=x+f35+"''"+a.figure_name+"''"+", ";
        end
        f36_strg=String(a.figure_id);
        x=x+f36+f36_strg+", ";
        if a.info_message<>"" then x=x+f37+"''"+a.info_message+"''"+", "; end
        if a.pixel_drawing_mode <> "copy" then x=x+f40+"''"+a.pixel_drawing_mode+"''"+", "; end
        if a.anti_aliasing <> "off" then x=x+f41+"''"+a.anti_aliasing+"''"+", "; end
        if a.immediate_drawing <>"on" then x=x+f42+"''"+a.immediate_drawing+"''"+", "; end
        f43_strg=String(f43);
        if a.background <> 33 then x=x+f43+f43_strg+", "; end
        if a.visible <> "on" then x=x+f24+"''"+a.visible+"''"+", "; end
        if a.rotation_style <> "unary" then x=x+f44+"''"+a.rotation_style+"''"+", "; end
        if a.event_handler <> "" then x=x+f45+"''"+a.event_handler+"''"+", "; end
        if a.event_handler_enable <> "off" then x=x+f46+"''"+a.event_handler_enable+"''"+", "; end
        if a.userdata <> [] then
            if type(a.userdata) == 1 then
                f47_strg=mat2exp(a.userdata,0)
            elseif type(a.userdata) == 2 then
                f47_strg=pol2exp(a.userdata,0)
            elseif type(a.userdata) == 4 then
                f47_strg=log2exp(a.userdata,0)
            elseif type(a.userdata) == 5 | type(a.userdata) == 6 | type(a.userdata) == 7 then
                f47_strg=sp2exp(a.userdata,0)
            elseif type(a.userdata) == 8 then
                f47_strg=int2exp(a.userdata,0)
            elseif type(a.userdata) == 9 then
                f47_strg=h2exp(a.userdata,0)
            elseif type(a.userdata) == 10 then
                f47_strg=str2exp(a.userdata,0)
            elseif type(a.userdata) == 13 then
                if named then
                    f47_strg=sci2exp(a.userdata,nom)
                else
                    f47_strg=sci2exp(a.userdata,"%fun")
                end
            elseif type(a.userdata) == 15 then
                f47_strg=list2exp(a.userdata);
            elseif type(a.userdata) == 16 then
                f47_strg=tlist2exp(a.userdata,0)
            elseif type(a.userdata) == 17 then
                f47_strg=mlist2exp(a.userdata,0)
            elseif type(a.userdata) == 129 then
                f47_strg=imp2exp(a.userdata,0)
            end
            x=x+f28+f47_strg+", ";
        end
        if a.resizefcn <> "" then x=x+f47+"''"+a.resizefcn+"''"+", "; end
        if a.closerequestfcn <> "" then x=x+f48+"''"+a.closerequestfcn+"''"+", "; end
        if a.tag <> "" then x=x+f27+"''"+a.tag+"''"+", "; end
        lx=length(x);
        x=part(x,1:lx-2);
        t(1)=f+"("+x;
        t(1)=t(1)+")";
        dots="."+".";
        lt=length(t(1))
        if lt>lmax & lmax<>0 then
            ind=strindex(x,",");
            k1=1;l=0;I=[];
            while %t
                if lt-l<lmax|k1>length(ind) then break,end
                k2=k1-1+max(find(ind(k1:$)<l+lmax))
                I=[I ind(k2)];
                k1=k2+1
                l=ind(k2)
            end
            t=strsplit(t(1),I);
            t(1:$-1)=t(1:$-1)+dots;
        end
    else
        msg = _("%s: This feature has not been implemented: Variable translation of type %s.\n")
        error(msprintf(msg,"sci2exp",string(a.type)));
    end

endfunction

function ml = user2mlist(u)
    fn = getfield(1, u);
    ml = mlist(fn);

    for k = 1:size(fn,"*")
        ml(k) = u(fn(k));
    end
endfunction
