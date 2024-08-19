// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - Dassault Systèmes - Clément DAVID
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================

function b = isLinuxPackaged()
    b = isdir(SCI + "/../../include")
endfunction

function [binary] = compile_executable(srcFiles, cflags, ldflags)
    // compile the srcFiles to produce an executable using call_scilab

    binary = basename(srcFiles(1));

    if getos() == "Windows"
        // Load dynamic_link Internal lib if it's not already loaded
        if ~ exists("dynamic_linkwindowslib") then
            load("SCI/modules/dynamic_link/macros/windows/lib");
        end
        [dynamic_info, static_info] = getdebuginfo();
        arch_info  = static_info(grep(static_info,"/^Compiler Architecture:/","r"));
        arch = strsplit(arch_info, ": ")($);

        CL_EXE =  listfiles(getVsWhereInformation()(1).path + "\VC\Tools\MSVC\*")(1) + "\bin\Host"+arch+"\"+arch+"\cl.exe";
        binary = binary + ".exe";

        CC = CL_EXE + " /out:"+binary;
        CFLAGS = [  "/Wall"
                    "/I ""WSCI\modules\call_scilab\includes"""
                    "/I ""WSCI\modules\core\includes"""
                    "/I ""WSCI\modules\ast\includes\ast"""
                    "/I ""WSCI\modules\ast\includes\types"""
                    "/I ""WSCI\modules\dynamic_link\includes"""
                    "/I ""WSCI\modules\string\includes"""
                    "/I ""WSCI\modules\fileio\includes"""
                    "/I ""WSCI\modules\localization\includes"""
                    "/I ""WSCI\modules\output_stream\includes"""
                    "/I ""WSCI\libs\intl"""
                    "-I."];
        LDFLAGS = [ """WSCI\bin\call_scilab.lib"""
                    """WSCI\bin\core.lib"""
                    """WSCI\bin\api_scilab.lib"""
                    """WSCI\bin\ast.lib"""
                    """WSCI\bin\fileio.lib"""
                    """WSCI\bin\scilocalization.lib"""
                    """WSCI\bin\output_stream.lib"""
                    """WSCI\bin\libintl.lib"""];
    else
        // use CC here to let the user configure it if needed
        CC = "$CC -o " + binary;
        CFLAGS = [  "-Wall -Wextra -Werror"
                    "-I ."];
        LDFLAGS = [ "--allow-shlib-undefined" ] // Scilab has recursive dependencies, do not check them
        if isLinuxPackaged()
            CFLAGS = [  CFLAGS
                        "-I SCI/../../include/scilab/"];
            LDFLAGS = [ LDFLAGS
                        "SCI/../../lib/scilab/libscicall_scilab.so"
                        "SCI/../../lib/scilab/libscilab.so"];
        else
            CFLAGS = [  CFLAGS
                        "-I SCI/modules/call_scilab/includes"
                        "-I SCI/modules/core/includes"
                        "-I SCI/modules/ast/includes/ast"
                        "-I SCI/modules/ast/includes/types"
                        "-I SCI/modules/dynamic_link/includes"
                        "-I SCI/modules/string/includes"
                        "-I SCI/modules/fileio/includes"
                        "-I SCI/modules/localization/includes"
                        "-I SCI/modules/output_stream/includes"];
            LDFLAGS = [ LDFLAGS
                        "SCI/modules/call_scilab/.libs/libscicall_scilab.so"
                        "SCI/modules/.libs/libscilab.so"];
        end
    end
    if isdef("cflags", 'l')
        CFLAGS = [CFLAGS ; cflags];
    end
    if isdef("ldflags", 'l')
        LDFLAGS = [LDFLAGS ; ldflags];
    end

    command = strcat([CC strcat(srcFiles, " ") strcat(CFLAGS, " ") strcat("-Wl," + LDFLAGS, " ")], " ");
    command = strsubst(command, "SCI", SCI);
    if getos() == "Windows"
        command = strsubst(command, "WSCI", WSCI);
    end
    disp(command)
    
    status = host(command)
    if status
        error(msprintf("compile_executable: failed %s", command));
    end
endfunction

function [stdout, status, stderr] = run_executable(binary)
    // run the binary using call_scilab and proper env. variable

    if getos() <> "Windows"
        if isLinuxPackaged()
            env = ["LD_LIBRARY_PATH="+strcat([SCI+"/../../lib/scilab"], ":")]
        else
            env = ["LD_LIBRARY_PATH="+strcat([SCI+"/modules/call_scilab/.libs" SCI+"/modules/.libs"], ":")]
        end
    end

    command = strcat([strcat(env, " ") binary], " ");
    disp(command)
    host(command);
    [stdout, status, stderr] = unix_g(command);
endfunction