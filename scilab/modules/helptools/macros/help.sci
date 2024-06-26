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

    printf("%s - %s\n", page.refname, page.refpurpose)
    if size(page.synopsis, "*") <> 0 then
        printf("\n  Syntax\n")
        for s = page.synopsis'
            printf("    %s\n", s);
        end
    end

    if size(page.varlist, "*") <> 0 then
        printf("\n  Arguments\n");
        for a = page.varlist'
            printf("    %s - %s\n", a.term, a.description);
        end
    end

    if size(page.seealso, "*") <> 0 then
        printf("\n  See also\n    ");
        printf("%s", strcat(page.seealso, " - "));
        printf("\n\nFor more information: `doc %s`\n", key);
    end
end