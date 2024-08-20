// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - 3DS - Antoine ELIAS
// For more information, see the COPYING file which you should have received
// along with this program.

function varargout = help(key, lang, outputFormat)
    arguments
        key (1, 1) string
        lang (1, 1) string = getlanguage()
        outputFormat (1, 1) string {mustBeMember(outputFormat, ["raw" "html"])} = "raw"
    end

    if ~isdir(fullfile(strsplit(SCI, "share/scilab")(1), "modules", "helptools", "inline")) then
        error(msprintf(gettext("%s: help is not installed.\n"), "help"));
    end

    [page, name] = getPage(key, "scilab", lang);
    if page == [] then
        //look in toolbox
        global %inline_help;
        tbx = fieldnames(%inline_help);
        tbx(tbx == "scilab") = [];
        for t = tbx'
            [page, name] = getPage(key, t, lang);
            if page <> [] then
                if nargout == 0 then
                    formatHelp(page, name, t, outputFormat);
                else
                    varargout(1) = page;
                end
                return;
            end
        end

        printf(_("%s: Requested help page ""%s"" does not exist.\n"), "help", key);
        return;
    end

    if nargout == 0 then
        formatHelp(page, name, [], outputFormat);
    else
        varargout(1) = page;
    end
end

function [page, name] = getPage(key, domain, lang)
    page = [];
    name = key;
    loadInlineHelp(lang)
    global %inline_help;

    if ~isfield(%inline_help(domain), lang) then
        if lang <> "en_US" then
            page = getPage(key, domain, "en_US");
            if page == [] then
                //try in toolbox help page
                disp("tbx");
            end
            return;
        end
    end

    l = %inline_help(domain)(lang).links;
    if ~isfield(l, key) then
        //try with some permutations for short key (factorial)
        if length(key) <= 8  then
            ret = perms(strsplit(key)');
            ret = strcat(ret, "", "c");
            ret = find(members(fieldnames(%inline_help(domain)(lang).links), ret));
            if ret <> [] then
                [page, name] = getPage(fieldnames(%inline_help(domain)(lang).links)(ret(1)), domain, lang);
                return;
            end
        end

        if lang <> "en_US" then
            page = getPage(key, domain, "en_US");
        end
        return;
    end

    link = l(key);
    if ~isfield(%inline_help(domain)(lang), "pages") then
        loadInlineHelp(lang, %t);
    end

    page = %inline_help(domain)(lang).pages(link);
end

function formatHelp(page, key, domain, outputFormat)
    if domain <> [] then
        printf(_("From help pages of toolbox `%s`.\n"), domain);
    end

    for i = 1:min(size(page.refname, "*"), size(page.refpurpose, "*"))
        printf("  %s - %s\n", page.refname(i).children.string, page.refpurpose(i).children.string)
    end

    if size(page.synopsis, "*") <> 0 then
        printf("\n    Syntax\n")
        for s = page.synopsis'
            printf("      %s\n", s.string');
        end
    end

    if size(page.varlist, "*") <> 0 then
        printf("\n    Arguments\n");
        for a = page.varlist'
            printVarList(a, 3, outputFormat);
        end
    end

    if size(page.seealso, "*") <> 0 then
        printf("\n    See also\n");
        printf("      %s", strcat(page.seealso, " - "));
        printf("\n\n  For more information: `doc %s`\n", key);
    end
end

function f = findSt(st, field, type)
    f = [];
    if isfield(st, field) then
        for s = st
            if s(field) == type then
                f = s;
            end
        end
    end

end

function str = concatdesc(desc)
    str = [];
    for s = desc
        str = str + s.string;
    end
end

function r = isInlineType(node)
    r = or(node.type == ["text" "term" "constant" "link" "ulink" "function" "literal" "varname", "emphasis", "subscript" "superscript" "command" "replaceable" "xref"]);
end

function printNode(node, indent, outputFormat)
    select node.type
    case "variablelist"
        for l = node.children
            printNode(l, indent + 1, outputFormat);
        end
    case "varlistentry"
        printVarList(l, indent, outputFormat)
    case "para"
        printIndent(indent);
        for l = node.children
            if l.type <> "itemizedlist" then
                printNode(l, 0, outputFormat);
            else
                printNode(l, indent + 1, outputFormat);
            end
        end
        printLF(1);
        printf("\n");
    case "listitem"
        s = size(node.children, "*");
        for i = 1:s
            l = node.children(i);
            if l.type <> "para" && l.type <> "warning" && l.type <> "variablelist" && ~isInlineType(l) then
                printIndent(indent);
            end

            if i == 1 && isInlineType(l) then
                printIndent(indent);
            end

            printNode(l, indent, outputFormat);
        end
    case "itemizedlist"
        printLF(2);
        printf("\n");
        printIndent(indent);
        for i = 1:size(node.children, "*")
            printf("* ", indent * 2, "");
            printNode(node.children(i), 0, outputFormat);
            if i <> size(node.children, "*") then
                printLF(3);
                printf("\n");
                printIndent(indent);
            end
        end
    case "text"
        //printIndent(indent);
        printf("%s", node.string);
    case {"link" "ulink"}
        //printIndent(indent);
        printf("%s", node.string);
    case {"literal" "varname" "emphasis"}
        //printIndent(indent);
        printf("%s", node.string);
    case "warning"
        printLF(4);
        //printf("\n");
    else
        printf("\nnot yet managed: %s\n", node.type);
    end
end

function printLF(val)
    //printf("LF%d", val);
endfunction

function printIndent(indent)
    printf("%*s", indent * 2, "");
endfunction

function printVarList(node, indent, outputFormat)

    term = findSt(node.children, "type", "term");
    desc = findSt(node.children, "type", "listitem");

    if term == [] || desc == [] then
        return
    end

    printIndent(indent);
    printf("%s", term.string);
    printLF(0);
    printf("\n");

    s = size(desc, "*")
    for i = 1:s
        a = desc(i);
        //printf("======%*s", (indent + 1) * 2, "");
        printNode(a, indent + 1, outputFormat);
        //printf("LF3\n");
    end
end