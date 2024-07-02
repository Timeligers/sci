/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2011 - DIGITEO - Cedric DELAMARRE
 *
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 * Copyright (C) 2023 - UTC - Stéphane MOTTELET
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#ifndef __DIFFERENTIAL_EQUATIONS_GW_HXX__
#define __DIFFERENTIAL_EQUATIONS_GW_HXX__

#include "cpp_gateway_prototype.hxx"

extern "C"
{
#include "dynlib_differential_equations_gw.h"
}

// equation 1
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_ode, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);

// equation 2
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_impl, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);    // Old function name was sciimpl
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_dassl, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);   // Old function name dassli
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_dasrt, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);   // Old function name was dasrti
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_daskr, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);

// equation 3
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_odedc, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);   // Old function name was sci_odc

// equation 4
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_intg, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_int2d, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_int3d, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_feval, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);

// equation 6
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_bvode, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);   // Old function name was scibvode

// Sundials
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_cvode, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_ida, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_arkode, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);
CPP_OPT_GATEWAY_PROTOTYPE_EXPORT(sci_kinsol, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_percent_odeSolution_clear, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);
CPP_GATEWAY_PROTOTYPE_EXPORT(sci_percent_odeSolution_e, DIFFERENTIAL_EQUATIONS_GW_IMPEXP);

#endif /* !__DIFFERENTIAL_EQUATIONS_GW_HXX__ */
