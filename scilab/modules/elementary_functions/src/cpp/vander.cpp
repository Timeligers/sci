/*
 * Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
 * Copyright (C) 2024 - 3DS - Adeline CARNIS
 *
 * For more information, see the COPYING file which you should have received
 * along with this program.
 *
 */
/*--------------------------------------------------------------------------*/

#include "vander.hxx"

int vander(types::Double* pIn, int N, types::Double* pOut)
{
    double* pdblInReal = pIn->getReal();
    double* pdblOutReal = pOut->getReal();
    double* pdblInImg   = pIn->getImg();
    double* pdblOutImg  = pOut->getImg();
    int size = pIn->getSize();

    if (pIn-> isComplex())
    {
        // first column contains only 1
        for (int i = 0; i < size; i++)
        {
            pdblOutReal[i] = 1;
            pdblOutImg[i] = 0;
        }

        // other columns contain the pdblIn^k values
        for (int k = 1; k < N; k++)
        {
            for (int i = (size * k); i < (size * (k + 1)); i++)
            {
                pdblOutReal[i] = pdblInReal[i%size] * pdblOutReal[i - size];
                pdblOutReal[i] -= pdblInImg[i%size] * pdblOutImg[i - size];
                pdblOutImg[i] = (pdblInReal[i%size] * pdblOutImg[i - size]) + (pdblInImg[i%size] * pdblOutReal[i - size]);
            }
        }
    }
    else
    {
        // first column contains only 1
        for (int i = 0; i < size; i++)
        {
            pdblOutReal[i] = 1;
        }

        // other columns contain the pdbLIn^k values
        for (int k = 1; k < N; k++)
        {
            for (int i = (size * k); i < (size * (k + 1)); i++)
            {
                pdblOutReal[i] = pdblInReal[i%size] * pdblOutReal[i - size];
            }
        }
    }

    return 0;
}
