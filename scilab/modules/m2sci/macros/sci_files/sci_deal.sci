// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2020 - Samuel GOUGEON
// Copyright (C) 2024 - 3DS - Vincent COUVERT
//
// This file is hereby licensed under the terms of the GNU GPL v2.0,
// pursuant to article 5.3.4 of the CeCILL v.2.1.
// This file was originally licensed under the terms of the CeCILL v2.1,
// and continues to be available under such terms.
// For more information, see the COPYING file which you should have received
// along with this program.

function tree = sci_deal(tree)
    // M2SCI function
    // Conversion function for Matlab deal()
    // Input: tree = Matlab funcall tree
    // Output: tree = Scilab equivalent for tree

    // [a,b,c] = deal(X)
    // [a,b,c] = deal(X,Y,Z,T) => erreur Octave
    // [a,b,c] = deal(X,Y,Z)
    
    argins = tree.rhs    // (....)
    argouts = tree.lhs   // [a,b,c]

    if length(argins)==1 then
        // [a,b,c] = deal(X)
        // Set the properties of the argouts
        for i = 1:length(argouts)
            argouts(i).infer = argins(1).infer
        end
    else
        // [a,b,c] = deal(X, Y, Z)
        // Set the properties of the argouts
        for i = 1:length(argouts)
            argouts(i).infer = argins(i).infer
        end
    end
    // We update the tree:
    tree.lhs = argouts
endfunction
