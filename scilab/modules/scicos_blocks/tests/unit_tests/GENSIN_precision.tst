// ============================================================================
// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
// Copyright (C) 2023 - Dassault Systemes - Bruno JOFRET
//
//  This file is distributed under the same license as the Scilab package.
// ============================================================================
//
// <-- ENGLISH IMPOSED -->
// <-- XCOS TEST -->
//
// <-- Short Description -->
// Sin function is loosing precision on big values.
// sin(2*%pi*t)

// Validate numerical statement
t = 0:2e6;
data = sin(2 * %pi * t);
assert_checktrue(max(data) > %eps);

dataFixed = sin(2 * %pi * (t - floor(t)));
assert_checktrue(max(dataFixed) < %eps);

importXcosDiagram("SCI/modules/scicos_blocks/tests/unit_tests/GENSIN_precision.zcos");
xcos_simulate(scs_m, 4);

assert_checktrue(simulationData.time - floor(simulationData.time) < %eps);
assert_checktrue(simulationData.values < %eps);
