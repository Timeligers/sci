/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2024 - Dassault Systèmes - Clément DAVID
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */

#include "CallScilabBridge.hxx"
extern "C"
{
#include "CallConsole.h"
#include "getScilabJavaVM.h"
}

using namespace org_scilab_modules_gui_bridge;

void console_display(const char* dataToDisplay)
{
    CallScilabBridge::display(getScilabJavaVM(), dataToDisplay);
}

char* console_readLine(void)
{
    return CallScilabBridge::readLine(getScilabJavaVM());
}

void console_clear(void)
{
    CallScilabBridge::clear(getScilabJavaVM());
}

void console_clearNLines(int nbLines)
{
    CallScilabBridge::clear(getScilabJavaVM(), nbLines);
}

int console_getCharWithoutPrompt(void)
{
    return CallScilabBridge::getCharWithoutOutput(getScilabJavaVM());
}

void console_toHome(void)
{
    CallScilabBridge::toHome(getScilabJavaVM());
}

void console_linesUpdate(void)
{
    CallScilabBridge::scilabLinesUpdate(getScilabJavaVM());
}

void console_setPrompt(const char* promptToSet)
{
    CallScilabBridge::setPrompt(getScilabJavaVM(), promptToSet);
}

BOOL console_isWaitingForInput(void)
{
    return booltoBOOL(CallScilabBridge::isWaitingForInput(getScilabJavaVM()));
}
