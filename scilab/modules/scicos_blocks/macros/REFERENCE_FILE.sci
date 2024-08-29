function [x,y,typ]=REFERENCE_FILE(job,arg1,arg2)
    x=[];
    y=[];
    typ=[];
    
    select job
    case "set" then
        model = arg1.model;
        graphics = arg1.graphics;
        
        // locate and load the diagram
        diagramPath = fileparts(scs_m.props.title(2));
        if isfile(fullfile(diagramPath, graphics.exprs)) then
            // diagram relative path 
            path = fileparts(fullfile(diagramPath, graphics.exprs));
        elseif isfile(fullfile(pwd(), graphics.exprs)) then
            // scilab relative path 
            path = fileparts(fullfile(pwd(), graphics.exprs));
        elseif isfile(graphics.exprs) then
            // full path on exprs
            path = fileparts(graphics.exprs);
        else
            path = diagramPath;
        end
        PathFileName = uigetfile("*.zcos", path);
        if ~isfile(PathFileName) then
            return;
        end
        scs = xcosDiagramToScilab(PathFileName);
        
        // copy SUPER_f interface
        for nb=1:length(scs.objs)
            if scs.objs(nb).gui == "SUPER_f" then
               model = scs.objs(nb).model;
               graphics = scs.objs(nb).graphics;
               break;
            end
        end
        
        exprs = getrelativefilename(diagramPath, PathFileName);
        if part(exprs, 1) == '.' then
            exprs = getrelativefilename(pwd(), PathFileName);
            if part(exprs, 1) == '.' then
                exprs = PathFileName;
            end
        end
        graphics.exprs = exprs;
        graphics.style = "blockWithLabel;displayedLabel="+scs.props.title(1);
        arg1.model = model;
        arg1.graphics = graphics;
        x = arg1;
    case "define" then
        // nested diagram settings (2 ports)
        scs=scicos_diagram();
        scs.props.title="Undefined reference";
        
        // block settings
        model=scicos_model();
        model.sim="super";
        model.rpar=scs;
        model.blocktype="h";
        model.dep_ut=[%f %f];

        gr_i=[];
        x=standard_define([2 2],model,"",gr_i);
        x.graphics.style = "blockWithLabel;displayedLabel="+scs.props.title(1);
    end
endfunction
