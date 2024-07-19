// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - 3DS - Antoine ELIAS
// For more information, see the COPYING file which you should have received
// along with this program.

function varargout = help(key, lang)
    arguments
        key (1, 1) string
        lang (1, 1) string = getlanguage()
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
                formatHelp(page, name, t);
                return;
            end
        end

        printf(_("%s: Requested help page ""%s"" does not exist.\n"), "help", key);
        return;
    end

    if nargout == 0 then
        formatHelp(page, name);
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
        //try with some permutation for short key (factorial)
        if length(key) <= 8  then
            ret = perms(strsplit(key)');
            ret = strcat(ret, "", "c");
            ret = find(members(fieldnames(%inline_help(domain)(lang).links), ret));
            if ret <> [] then
                [page, name] = getPage(fieldnames(%inline_help(domain)(lang).links)(ret), domain, lang);
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

function formatHelp(page, key, domain)
    arguments
        page
        key
        domain = []
    end
    if domain <> [] then
        printf(_("From help pages of toolbox `%s`.\n"), domain);
    end

    for i = 1:min(size(page.refname, "*"), size(page.refpurpose, "*"))
        printf("  %s - %s\n", page.refname(i).children.string, page.refpurpose(i).children.string)
    end

    if size(page.synopsis, "*") <> 0 then
        printf("\n    Syntax\n")
        for s = page.synopsis'
            printf("      %s\n", s.children(1).string);
        end
    end

    if size(page.varlist, "*") <> 0 then
        printf("\n    Arguments\n");
        for a = page.varlist'
            printVarList(a, 0);
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

function str = nodeString(node)

end

function printVarList(node, indent)

    term = findSt(node.children, "type", "term");
    desc = findSt(node.children, "type", "listitem");

    if term == [] || desc == [] then
        return
    end

    printf("      %*s%s", indent * 2, "", term.string);
    for i = 1:size(desc, "*")
        a = desc(i);

        select desc.type
        case "listitem"
            for l = desc.children
                disp(l, "");
            end
        case "para"
            disp("para");
        else
        end
        /*
        if a == [] then
            printf("\n");
        elseif typeof(a) == "string" then
            if size(a, "*") == 1 then
                if i == 1 then
                    printf("\n");
                end
                printf("      %*s%s\n", (indent + 1) * 2, "", a);
            else
                for j = 1:size(a, "*")
                    if i == 1 then
                        printf("\n%s\n", a(j));
                    else
                        printf("      %*s%s\n", (indent + 2) * 2, "", a(j));
                    end
                end
            end
        else //struct
            for b = a
                printVarList(b, indent + 2);
            end
        end
        */
    end
    /*
    else
        if size(node.description, "*") > 1
            printf("\n");
            for i = 1:size(node.description, "*")
                printf("      %*s%s\n", (indent + 1) * 2, "", node.description(i));
            end
        else
            printf(" - %s\n", node.description);
        end
    end
    */
end