/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2024 - Dassault Systèmes - Clément DAVID
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 */

#include "functions_gw.hxx"
#include "context.hxx"
#include "function.hxx"

#define MODULE_NAME L"functions"

int FunctionsModule::Load()
{
    symbol::Context::getInstance()->addFunction(types::Function::createFunction(L"exec", &sci_exec, MODULE_NAME));
    symbol::Context::getInstance()->addFunction(types::Function::createFunction(L"execstr", &sci_execstr, MODULE_NAME));
    symbol::Context::getInstance()->addFunction(types::Function::createFunction(L"funclist", &sci_funclist, MODULE_NAME));
    symbol::Context::getInstance()->addFunction(types::Function::createFunction(L"librarieslist", &sci_librarieslist, MODULE_NAME));
    symbol::Context::getInstance()->addFunction(types::Function::createFunction(L"libraryinfo", &sci_libraryinfo, MODULE_NAME));
    symbol::Context::getInstance()->addFunction(types::Function::createFunction(L"macrovar", &sci_macrovar, MODULE_NAME));
    symbol::Context::getInstance()->addFunction(types::Function::createFunction(L"parser_idempotence", &sci_idempotence, MODULE_NAME));
    symbol::Context::getInstance()->addFunction(types::Function::createFunction(L"whereis", &sci_whereis, MODULE_NAME));

    return 1;
}

