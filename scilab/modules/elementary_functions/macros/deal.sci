// Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
//
// Copyright (C) 2023-2023 - Dassault Systemes - Bruno JOFRET
//
// For more information, see the COPYING file which you should have received
// along with this program.

function varargout=deal(varargin)
   if nargin <> 1 && nargin <> nargout then
      error(msprintf(gettext("%s: Wrong number of output argument(s): %d expected.\n"), "deal", nargin));
   end

   if nargin == 1 then
      for i = 1:nargout
         varargout(i) = varargin(1)
      end
   else
      varargout = varargin
   end
 endfunction
