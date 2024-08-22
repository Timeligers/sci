/*
 *  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 *  Copyright (C) 2010-2010 - DIGITEO - Bruno JOFRET
 *  Copyright (C) 2014-2015 - Scilab Enterprises - Cedric Delamarre
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

#ifndef __RUNNER_HXX__
#define __RUNNER_HXX__

#include "exp.hxx"

extern "C"
{
#include "dynlib_core.h"
#include "storeCommand.h" // command_origin_t
}

class CORE_IMPEXP Runner
{
public :
    Runner(ast::Exp* _theProgram) : m_theProgram(_theProgram), m_iCommandOrigin(NONE), m_isInterruptible(true)
    { }

    Runner(ast::Exp* _theProgram, command_origin_t _iCommandOrigin, bool _isInterruptible) : m_theProgram(_theProgram), m_iCommandOrigin(_iCommandOrigin), m_isInterruptible(_isInterruptible)
    { }

    ~Runner()
    {
        delete m_theProgram;
    }

    void setProgram(ast::Exp* _p)
    {
        m_theProgram = _p;
    }

    ast::Exp* getProgram()
    {
        return m_theProgram;
    }

    command_origin_t getCommandOrigin()
    {
        return m_iCommandOrigin;
    }

    bool isInterruptible()
    {
        return m_isInterruptible;
    }

private :
    ast::Exp* m_theProgram;
    command_origin_t m_iCommandOrigin;
    bool m_isInterruptible;
};

// static members to manage execution
class CORE_IMPEXP StaticRunner
{
public:
    static int launch();
    static bool execCommand(const std::string& _stCMD);

    static void sendExecDoneSignal();

    static bool isRunning(void);
    static bool isInterruptibleCommand(void);

    static void setDumpStack(bool _bValue);
    static void setExecAst(bool _bValue);
    static void setDumpAst(bool _bValue);
    static bool getDumpAst();
    static void setPrintAst(bool _bValue);
    static bool getPrintAst();
    static void printAstTask(ast::Exp *tree);
    static void dumpAstTask(ast::Exp *tree);

private:
    static void processRunner(Runner* _runner);
    static void dumpStackTask();

    static Runner* m_CurrentRunner;
    static bool m_bDumpStack;
    static bool m_bExecAst;
    static bool m_bDumpAst;
    static bool m_bPrintAst;
};

extern "C"
{
    void StaticRunner_launch(void);
    int StaticRunner_isRunning(void);
    int StaticRunner_isInterruptibleCommand(void);
    int StaticRunner_execCommand(const char* cmd);
}

#endif /* !__RUNNER_HXX__ */
