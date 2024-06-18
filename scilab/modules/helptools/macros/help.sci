// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2024 - 3DS - Antoine ELIAS

function help(key, lang)
    arguments
        key (1, 1) string
        lang (1, 1) string = getlanguage()
    end

    page = getPages(key, lang);
    if page == [] then
        error(sprintf("%s: Requested help page ""%s"" does not exist", "help", key));
    end

    formatHelp(page, key);
end

function loadHelpFiles(lang, page)
    arguments
        lang
        page = %f //by default load only links
    end

    global %inline_help;
    if %inline_help == [] || ~isfield(%inline_help, lang) || (page && ~isfield(%inline_help(lang), "pages")) then
        //load "lang" links
        filename = fullfile(strsplit(SCI, "share/scilab")(1), "modules", "helptools", "inline", lang, "links.json");
        if isfile(filename) then
            %inline_help(lang).links = fromJSON(filename, "file");
            if page then
                filename = fullfile(strsplit(SCI, "share/scilab")(1), "modules", "helptools", "inline", lang, "pages.json");
                if isfile(filename) then
                    %inline_help(lang).pages = fromJSON(filename, "file");
                end
            end
        end
    end
end

function page = getPages(key, lang)
    page = [];
    loadHelpFiles(lang)
    global %inline_help;

    if ~isfield(%inline_help, lang) then
        if lang <> "en_US" then
            page = getPages(key, "en_US");
            return;
        end
    end

    l = %inline_help(lang).links;
    if ~isfield(l, key) then
        if lang <> "en_US" then
            page = getPages(key, "en_US");
            return;
        end
    end

    link = l(key);
    if ~isfield(%inline_help(lang), "pages") then
        loadHelpFiles(lang, %t);
    end

    page = %inline_help(lang).pages(link);
end

function formatHelp(page, key)
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