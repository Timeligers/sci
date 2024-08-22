/*
* Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
* Copyright (C) 2010-2011 - Calixte DENIZET
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

#include "context.hxx"
#include "struct.hxx"
#include "tlist.hxx"
#include "overload.hxx"
#include "string.hxx"
#include "callable.hxx"
#include "types_tools.hxx"
#include "user.hxx"


extern "C"
{
#include <string.h> /* strcmp */
#include <stdlib.h> /* qsort */
#include "Scierror.h"
#include "api_scilab.h"
#include "sci_malloc.h"
#include "getfieldsdictionary.h"
#include "getPartLine.h"
#include "completion.h"
#include "freeArrayOfString.h"
#include "charEncoding.h"
#include "getfields.h"
}

static int isInitialized = 0;

/*--------------------------------------------------------------------------*/
static int cmpNames(const void *a, const void *b)
{
    return strcmp(*(const char **)a, *(const char **)b);
}
/*--------------------------------------------------------------------------*/
char **getfieldsdictionary(char *lineBeforeCaret, char *pattern, int *size)
{
    int rc = 0;
    wchar_t **pstData = NULL;
    char **fields = NULL;
    char *pstVar = NULL;
    wchar_t* pwstVar = NULL;
    int iXlist = 0;

    char *lineBeforePoint = NULL;
    int pos = (int)(strlen(lineBeforeCaret) - strlen(pattern) - 1);

    if (!isInitialized)
    {
        initializeFieldsGetter();
        isInitialized = 1;
    }

    if (pos <= 0 || lineBeforeCaret[pos] != '.')
    {
        return NULL;
    }

    lineBeforePoint = (char*)MALLOC(sizeof(char) * (pos + 1));
    if (lineBeforePoint == NULL)
    {
        return NULL;
    }

    memcpy(lineBeforePoint, lineBeforeCaret, pos);
    lineBeforePoint[pos] = '\0';
    pstVar = getPartLevel(lineBeforePoint);

    pwstVar = to_wide_string(pstVar);
    FREE(pstVar);

    FREE(lineBeforePoint);
    lineBeforePoint = NULL;

    symbol::Context* pCtx = symbol::Context::getInstance();

    types::InternalType* pIT = pCtx->get(symbol::Symbol(pwstVar));
    FREE(pwstVar);
    if (pIT == NULL)
    {
        return NULL;
    }

    int iSize = 0;
    types::String* pFields = nullptr;
    switch (pIT->getType())
    {
        case types::InternalType::ScilabHandle:
        {
            types::typed_list in,out;
            types::Callable::ReturnValue ret;

            pIT->IncreaseRef();
            in.push_back(pIT);
            ret = Overload::call(L"%h_fieldnames", in, 1, out);
            pIT->DecreaseRef();
            if (ret == types::Callable::OK_NoResult)
            {
                return NULL;
            }
            pFields = out[0]->getAs<types::String>();
            iSize = pFields->getSize();
            pstData = pFields->get();
            iXlist = 0;
            break;            
        }
        case types::InternalType::ScilabStruct:
        {
            types::Struct* pStr = pIT->getAs<types::Struct>();
            pFields = pStr->getFieldNames();
            if (pFields == 0)
            {
                return NULL;
            }

            iSize = pFields->getSize();
            pstData = pFields->get();
            break;
        }
        case types::InternalType::ScilabTList:
        case types::InternalType::ScilabMList:
        {
            types::typed_list in,out;
            types::Callable::ReturnValue ret;

            pIT->IncreaseRef();
            in.push_back(pIT);
            ret = Overload::generateNameAndCall(L"fieldnames", in, 1, out, false, false);
            pIT->DecreaseRef();
            if (ret == types::Callable::OK_NoResult)
            {
                pFields = pIT->getAs<types::TList>()->getFieldNames();

                //bypass the value, is the (t/m)list type
                iSize = pFields->getSize() - 1;
                if (iSize == 0)
                {
                    return NULL;
                }

                pstData = pFields->get();
                iXlist = 1;                
            }
            else
            {
                if (out.size() != 1 || out[0]->isString() == false)
                {
                    return NULL;
                }
                pFields = out[0]->getAs<types::String>();
                iSize = pFields->getSize();
                pstData = pFields->get();
                iXlist = 0;
            }
            break;
        }
        case types::InternalType::ScilabUserType:
        {
            types::UserType* pUT = pIT->getAs<types::UserType>();
            if (pUT->hasGetFields() == false)
            {
                return NULL;
            }

            pFields = pIT->getAs<types::UserType>()->getFields();
            if (pFields == NULL)
            {
                return NULL;
            }

            iSize = pFields->getSize();

            pstData = pFields->get();
            break;
        }
        default:
            return NULL;
    }

    int iLast = 0;
    char** _fields = (char**)MALLOC(sizeof(char*) * (iSize + 1));
    wchar_t* wpattern = to_wide_string(pattern);
    for (int i = iXlist; i < (iSize + iXlist); ++i)
    {
        if (!std::isspace(pstData[i][0]) && wcsstr(pstData[i], wpattern) == pstData[i])
        {
            _fields[iLast++] = wide_string_to_UTF8(pstData[i]);
        }

    }

    FREE(wpattern);

    _fields[iLast] = NULL;
    *size = iLast;
    qsort(_fields, *size, sizeof(char*), cmpNames);

    pFields->killMe();
    return _fields;
}
/*--------------------------------------------------------------------------*/
