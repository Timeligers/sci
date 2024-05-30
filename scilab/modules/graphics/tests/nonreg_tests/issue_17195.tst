// =============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - 3DS - Vincent COUVERT
//
//  This file is distributed under the same license as the Scilab package.
// =============================================================================
//
// <-- TEST WITH GRAPHIC -->
// <-- NO CHECK REF -->
//
// <-- Non-regression test for issue 17195 -->
//
// <-- GitLab URL -->
// https://gitlab.com/scilab/scilab/-/issues/17195
//
// <-- Short Description -->
// Updating data property of a Matplot entity in a loop randomly crashes Scilab

gcf().color_map = jetcolormap(256);
Matplot(floor(256 * rand(100, 100)));
e = gce();
for j = 1:10000
    e.data = floor(256 * rand(100, 100));
end
