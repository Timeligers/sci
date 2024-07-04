/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2008 - INRIA - Vincent COUVERT
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

#ifndef __CALLCONSOLE_H__
#define __CALLCONSOLE_H__

extern "C"
{

#include "BOOL.h"
#include "dynlib_gui.h"

GUI_IMPEXP void console_display(const char*);

GUI_IMPEXP char* console_readLine(void);

GUI_IMPEXP void console_clear(void);

GUI_IMPEXP void console_clearNLines(int);

GUI_IMPEXP int console_getCharWithoutPrompt(void);

GUI_IMPEXP void console_toHome(void);

GUI_IMPEXP void console_linesUpdate(void);

GUI_IMPEXP void console_setPrompt(const char*);

GUI_IMPEXP BOOL console_isWaitingForInput(void);

}

#endif /* __CALLCONSOLE_H__ */
