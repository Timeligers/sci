/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2007 - INRIA
 *
 * Copyright (C) 2012 - 2016 - Scilab Enterprises
 *
 * This file is hereby licensed under the terms of the GNU GPL v2.0,
 * pursuant to article 5.3.4 of the CeCILL v.2.1.
 * This file was originally licensed under the terms of the CeCILL v2.1,
 * and continues to be available under such terms.
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */
#ifndef __BOOL_H__
#define __BOOL_H__

/* define boolean type */
#ifdef BOOL
#undef BOOL
#endif

#ifdef TRUE
#undef TRUE
#endif

#ifdef FALSE
#undef FALSE
#endif


typedef int BOOL;
#define FALSE 0
#define TRUE 1

/* converts BOOL to bool */
#define BOOLtobool(w)     ((w != FALSE) ? true : false)

/* converts bool to BOOL */
#define booltoBOOL(w)     ((w == true) ? TRUE : FALSE)

#endif /* __BOOL_H__ */
/*--------------------------------------------------------------------------*/
