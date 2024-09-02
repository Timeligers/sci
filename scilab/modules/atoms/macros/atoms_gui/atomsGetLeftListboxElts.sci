// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2010 - DIGITEO - Pierre MARECHAL <pierre.marechal@scilab.org>
//
// Copyright (C) 2012 - 2016 - Scilab Enterprises
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

// Internal function
// GUI function

// Returns a struct that contains the followings fields:
//  - elements("items_str")
//  - elements("items_mat")
//  - elements("title")
//

function elements = atomsGetLeftListboxElts(category)

    rhs = argn(2);

    // Check number of input arguments
    // =========================================================================

    if rhs <> 1 then
        error(msprintf(_("%s: Wrong number of input argument: %d expected.\n"),"getLeftListboxElements",1));
    end

    // Check input argument types
    // =========================================================================

    if category<>[] & type(category) <> 10 then
        error(msprintf(_("%s: Wrong type for input argument #%d: string expected.\n"),"getLeftListboxElements",1));
    end

    if category<>[] & type(category) <> 10 then
        error(msprintf(_("%s: Wrong type for input argument #%d: string expected.\n"),"getLeftListboxElements",1));
    end

    if size(category(1,:),"*") > 2 then
        error(msprintf(_("%s: Wrong size for input argument #%d: mx1 or mx2 string matrix expected.\n"),"atomsIsCategory",1));
    end

    // Build lists
    // =========================================================================

    items_str  = [];
    items_mat  = [];

    atomsfig   = findobj("tag","atomsFigure");
    allModules = atomsfig("UserData");

    background = "#ffffff";

    // 1st case, All main categories
    // -------------------------------------------------------------------------

    if category=="filter:main" then

        categories = atomsCategoryGet("filter:main");

        items_str = [items_str ; "user-home", _("All modules"), "#ffffff"];
        items_mat = [items_mat ; "category" "filter:all"];

        for i=1:size(categories, "*")
            if background == "#eeeeee" then
                background = "#ffffff";
            else
                background = "#eeeeee";
            end

            items_str = [items_str ; "folder", _(categories(i)), background];
            items_mat = [items_mat ; "category" categories(i)];
        end

        // 2nd case: Sub categories + modules
        // -------------------------------------------------------------------------

    else

        // Categories
        // ---------------------------------------------------------------------

        index_start = regexp(category,"/ - /");
        // if index_start == [], category is a main category
        // otherwise, category is a subcategory

        if category=="filter:all" then
            categories = [];
            top_str    = _("Main categories");
            top_mat    = ["category" "filter:main"];

        elseif index_start==[] then
            categories = atomsCategoryGet(category);
            top_str    = _("Main categories");
            top_mat    = ["category" "filter:main"];

        else
            categories = [];
            parent     = part(category,1:index_start(1)-1);
            top_str    = parent;
            top_mat    = ["category" parent];

        end

        items_str = [items_str ; "user-home", _(top_str), "#ffffff"];
        //items_str = [items_str ; thisItem ];
        items_mat = [items_mat ; top_mat  ];

        for i=1:size(categories, "*")
            if background == "#eeeeee" then
                background = "#ffffff";
            else
                background = "#eeeeee";
            end

            items_str = [items_str ; "folder", _(categories(i)), background];
            items_mat = [items_mat ; "category" category+" - "+categories(i) ];
        end

        // Modules
        // ---------------------------------------------------------------------

        if category=="filter:all" then
            modulesNames = atomsGetAvailable([],%T);
        else
            modulesNames = atomsGetAvailable(category,%T);
        end

        MRVersionAvailable = atomsGetMRVersion(modulesNames);
        modulesIsInstalled = atomsIsInstalled(modulesNames);

        for i=1:size(modulesNames, "*")

            thisModuleTitle    = allModules(modulesNames(i))(MRVersionAvailable(i)).Title;

            if modulesIsInstalled(i) then

                MRVersionInstalled = atomsVersionSort(atomsGetInstalledVers(modulesNames(i)),"DESC");
                MRVersionInstalled = MRVersionInstalled(1);
                thisModuleTitle    = allModules(modulesNames(i))(MRVersionInstalled).Title;

                if atomsVersionCompare(MRVersionInstalled,MRVersionAvailable(i)) == -1 then
                    // Not up-to-date
                    icon = "software-update-notuptodate";
                else
                    // The Most Recent Version is already installed
                    icon = "software-update-installed";
                end

            else
                icon = "software-update-notinstalled";
            end

            if background == "#eeeeee" then
                background = "#ffffff";
            else
                background = "#eeeeee";
            end

            items_str = [items_str ; icon, _(thisModuleTitle), background];
            items_mat = [items_mat ; "module" modulesNames(i)];

        end

    end

    if items_str==[] then
        elements("items_str") = "";
    else
        elements("items_str") = items_str;
    end

    elements("items_mat") = items_mat;

    if category=="filter:main" then
        elements("title") = _("Main categories");
    elseif category=="filter:all" then
        elements("title") = _("All modules");
    else
        elements("title") = _(category);
    end

    if %f then
        // NEVER EXECUTED ON PURPOSE
        // inlined category "filter:main" data to ease localization
        _("Aerospace");
        _("Contributed Scilab Binaries");
        _("Data Analysis And Statistics");
        _("Data Handling");
        _("Editor Styles");
        _("Education");
        _("GUI");
        _("Graphics");
        _("Graphs");
        _("Image Processing");
        _("Instruments Control");
        _("Linear algebra");
        _("Modeling and Control Tools");
        _("Number theory");
        _("Numerical Maths");
        _("Optimization");
        _("Physics");
        _("Real-Time");
        _("Scilab development");
        _("Signal Processing");
        _("Technical");
        _("Tests");
        _("Xcos");
    end
endfunction

// =============================================================================

function packages = atomsGetAvailable(category, nameonly)
	// Input parameters
	//
	// - category: [], 1x1 or 1x2 string array
	//   + []
	//   + "Data Analysis And Statistics"
	//   + "Data Analysis And Statistics - Neural networks"
	//   + ["Data Analysis And Statistics","Neural networks"]
	//
	// - nameonly: %T or %F (%F is the default value)


	// Returns the list of available packages
	// - In ascending (lexical) order for the name
	// - In descending order for the versions

	// if nameonly is TRUE, a mx1 matrix is returned:
	//
	//         !ampl_toolbox      !
	//         !ANN_Toolbox       !
	//         !celestlab         !
	//         ...

	// if nameonly is FALSE, a mx2 matrix is returned:
	//
	//        !ampl_toolbox      1.3-1      !
	//        !ampl_toolbox      1.2-1      !
	//        !ANN_Toolbox       0.4.2.3-1  !
	//        !celestlab         2.0.0-1    !
	//        !celestlab         1.0.1-1    !
	//        ...

    packages = [];

    // Check input parameters
    // =========================================================================

    rhs = argn(2);

    if rhs > 2 then
        error(msprintf(gettext("%s: Wrong number of input arguments: %d to %d expected.\n"),"atomsGetAvailable",0,2))
    end

    if rhs==0 then
        category = [];
    end

    if category<>[] then

        if type(category) <> 10 then
            error(msprintf(gettext("%s: Wrong type for input argument #%d: string expected.\n"),"atomsGetAvailable",1));
        end

        if (size(category,"*") <> 1) & or(size(category) <> [1 2]) then
            error(msprintf(gettext("%s: Wrong size for input argument #%d: A 1x1 or 1x2 string matrix expected.\n"),"atomsGetAvailable",1));
        end

        if and(size(category)==[1 2]) then
            category = category(1)+" - "+category(2);
        end

        if ~atomsIsCategory(category) then
            error(msprintf(gettext("%s: Wrong value for input argument #%d: A valid category expected.\n"),"atomsGetAvailable",1));
        end

    end

    if rhs>=2 then

        if type(nameonly) <> 4 then
            error(msprintf(gettext("%s: Wrong type for input argument #%d: A boolean expected.\n"),"atomsGetAvailable",2));
        end

        if size(nameonly,"*") <> 1 then
            error(msprintf(gettext("%s: Wrong size for input argument #%d: A boolean expected.\n"),"atomsGetAvailable",2));
        end

    else
        nameonly = %F;
    end

    // Get the list of available packages
    // =========================================================================

    [packages_struct,categories_struct] = atomsDESCRIPTIONget();

    if category==[] then
        // All packages
        packages_list      = getfield(1,packages_struct);
        packages_list(1:2) = [];
        packages_list      = packages_list';
    else
        // Filter by category
        category_struct    = categories_struct(category);
        packages_list      = category_struct("packages");
        packages_list      = unique(packages_list(:,1));
    end

    [A,k]         = gsort(convstr(packages_list,"l"),"lr","i");
    packages_list = packages_list(k);

    // Loop on package list
    // =========================================================================

    for i=1:size(packages_list,"*")

        // packages_list(i) is the technical name of the current package

        // Get the list of versions compatibles with this version of Scilab
        this_package_versions = atomsCompatibleVersions(packages_list(i));

        // If no compatible version, no need to add this package to the list
        if isempty(this_package_versions) then
            continue;
        end

        // Add the package to the list
        if nameonly then
            packages = [ packages;packages_list(i)];
        else
            packages = [ packages; ..
            emptystr(size(this_package_versions,"*"),1)+packages_list(i), ..
            this_package_versions ];
        end
    end

endfunction
