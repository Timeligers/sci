// Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2015 - Scilab Enterprises - Clement DAVID
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2.1-en.txt
//==============================================================================

function tbx_generate(NAME, TITLE, entryPoints)
    // Generate a new external module (eg. toolbox) using the toolbox_skeleton
    //
    // Calling Sequence
    // tbx_generate(NAME, TITLE) // generate a new module
    // tbx_generate(NAME, TITLE, entryPoints) // generate a new module with a kind of code
    //
    // Parameters
    // NAME: the name (used for filenames) of the created external module
    // TITLE: the title (any character allowed) of the created external module
    // entryPoints: a string matrix of [gatewayKind , functionName]
    //

    if fileinfo("SCI/contrib/toolbox_skeleton") == [] then
        error(msprintf("%s: the toolbox skeleton is not available", "tbx_generate"));
    end

    [lhs,rhs]=argn();
    if 2 > rhs | rhs > 3  then
        error(msprintf(gettext("%s: Wrong number of input arguments: %d to %d expected.\n"), "tbx_generate", 2, 3))
    end
    if rhs == 2 then
        entryPoints = [];
    end

    if typeof(NAME) <> "string" then
        msg = _("%s: Argument %d: String expected.\n");
        error(sprintf(msg, "tbx_generate", 1));
    end
    if size(NAME) <> [1 1] then
        msg = _("%s: Argument %d: String expected.\n");
        error(sprintf(msg, "tbx_generate", 1));
    end
    if grep(NAME, "/[a-zA-Z0-9_]+/", "r") == [] then
        msg = _("%s: Argument %d: valid directory name expected.\n");
        error(sprintf(msg, "tbx_generate", 1));
    end

    if typeof(TITLE) <> "string" then
        msg = _("%s: Argument %d: String expected.\n");
        error(sprintf(msg, "tbx_generate", 2));
    end
    if size(TITLE) <> [1 1] then
        msg = _("%s: Argument %d: String expected.\n");
        error(sprintf(msg, "tbx_generate", 2));
    end

    if entryPoints <> [] & typeof(entryPoints) <> "string" then
        msg = _("%s: Argument %d: String expected.\n");
        error(sprintf(msg, "tbx_generate", 3));
    end
    if entryPoints <> [] & size(entryPoints, "c") > 2 then
        msg = _("%s: Argument %d: String expected.\n");
        error(sprintf(msg, "tbx_generate", 3));
    elseif entryPoints <> [] & size(entryPoints, "c") == 1 then
        // reshape entryPoints if the kind was not specified : macros is the default
        entryPoints = [("macros"+emptystr(size(entryPoints, "r"), 1)) entryPoints];
    end

    [status, message] = copyfile("SCI/contrib/toolbox_skeleton", NAME);
    if status == 0 then
        error(message);
    end

    //
    // Rename files
    //
    [status, message] = movefile(NAME+"/etc/toolbox_skeleton.start", NAME+"/etc/"+NAME+".start")
    if status == 0 then
        error(message);
    end
    [status, message] = movefile(NAME+"/etc/toolbox_skeleton.quit", NAME+"/etc/"+NAME+".quit")
    if status == 0 then
        error(message);
    end
    [status, message] = movefile(NAME+"/etc/toolbox_skeleton_preferences.xsl", NAME+"/etc/"+NAME+"_preferences.xsl")
    if status == 0 then
        error(message);
    end
    [status, message] = movefile(NAME+"/etc/toolbox_skeleton_preferences.xml", NAME+"/etc/"+NAME+"_preferences.xml")
    if status == 0 then
        error(message);
    end
    [status, message] = movefile(NAME+"/demos/toolbox_skeleton.dem.gateway.sce", NAME+"/demos/"+NAME+".dem.gateway.sce")
    if status == 0 then
        error(message);
    end

    //
    // Update some file content accordingly to the NAME and TITLE
    //
    function update_name_and_title(f)
        content=mgetl(f);
        [row, which] = grep(content, ["toolbox_skeleton" "Toolbox Skeleton"]);
        for i=row(which==1),
            content(i)=strsubst(content(i), "toolbox_skeleton", NAME);
        end
        for i=row(which==2),
            content(i)=strsubst(content(i), "Toolbox Skeleton", TITLE);
        end
        mputl(content, f);
    endfunction

    function st = deletefile_glob_pattern(glob_pattern)
        files = ls(glob_pattern);
        st = files == ""; // initialize to false
        for i=1:size(files, "*")
            st(i) = deletefile(files(i))
        end
    endfunction


    //
    // Update or cleanup the provided sources files ; these are sorted by name to ease adding
    //
    update_name_and_title(NAME+"/builder.sce");
    update_name_and_title(NAME+"/changelog.txt");
    update_name_and_title(NAME+"/demos/"+NAME+".dem.gateway.sce");
    update_name_and_title(NAME+"/DESCRIPTION");
    update_name_and_title(NAME+"/etc/"+NAME+"_preferences.xml");
    update_name_and_title(NAME+"/etc/"+NAME+"_preferences.xsl");
    update_name_and_title(NAME+"/etc/"+NAME+".quit");
    update_name_and_title(NAME+"/etc/"+NAME+".start");
    deletefile_glob_pattern(NAME+"/help/en_US/*.xml");
    deletefile_glob_pattern(NAME+"/help/fr_FR/*.xml");
    rmdir(NAME+"/locales", "s");
    deletefile_glob_pattern(NAME+"/macros/*.sci");
    update_name_and_title(NAME+"/readme.txt");
    deletefile_glob_pattern(NAME+"/sci_gateway/c/*.c");
    deletefile_glob_pattern(NAME+"/sci_gateway/cpp/*.cpp");
    rmdir(NAME+"/sci_gateway/fortran", "s");
    deletefile_glob_pattern(NAME+"/src/c/*.c");
    deletefile_glob_pattern(NAME+"/src/c/*.h");
    deletefile_glob_pattern(NAME+"/src/cpp/*.cpp");
    deletefile_glob_pattern(NAME+"/src/cpp/*.hxx");
    deletefile_glob_pattern(NAME+"/src/fortran/*.f");
    rmdir(NAME+"/src/java/org", "s");
    deletefile_glob_pattern(NAME+"/tests/unit_tests/*.tst");
    deletefile_glob_pattern(NAME+"/tests/unit_tests/*.dia.ref");
    deletefile(NAME+"toolbox_skeleton_redist.iss");

    //
    // Generate empty entry points
    //

    // utility to find the extensions
    function fileExtensions=get_extension_per_kind(entryPoints)
        fileExtensions=emptystr(size(entryPoints, "r"));

        map = ["macros" "sci"
        "sci_gateway/c" "c"
        "sci_gateway/cpp" "cpp"
        "src/c" "c"
        "src/cpp" "cpp"
        "src/fortran" "f"
        "src/java" "java"];

        for i=1:size(map, "r"),
            fileExtensions(entryPoints(:,1)==map(i,1)) = map(i,2);
        end
    endfunction

    // utility to generate the macros
    function generate_macros(entryPoints, fileExtensions)
        txt = ["// FIXME add some logic to this file"
        "// Generated by tbx_generate.sci"
        ""
        "function [x,y,z] = %s(a,b)"
        "    error(""Not implemented yet"");"
        "endfunction"];
        txt = strcat(txt, "\n");

        macros = entryPoints(:,1) == "macros";
        fname = entryPoints(macros, 2);
        ext = fileExtensions(macros);

        path = NAME + "/macros/";
        for i=1:size(fname, "*")
            mputl(path+fname(i)+"."+ext(i), msprintf(txt, fname));
        end
    endfunction

    fileExtensions=get_extension_per_kind(entryPoints);
    if or(fileExtensions == "") then
        error(msprintf(gettext("%s: Argument #%d: Must be in the set {%s}.\n"), "tbx_generate", 3, """macros"" , ""sci_gateway/c"" , ""sci_gateway/cpp"" , ""src/c"" , ""src/cpp"" , ""src/java"""))
    end


    generate_macros(entryPoints, fileExtensions);
    generate_gateway_c(entryPoints, fileExtensions);
    generate_gateway_cpp(entryPoints, fileExtensions);
    generate_src_c(entryPoints, fileExtensions);
    generate_src_cpp(entryPoints, fileExtensions);
    generate_src_fortran(entryPoints, fileExtensions);
    generate_src_java(entryPoints, fileExtensions);
endfunction
