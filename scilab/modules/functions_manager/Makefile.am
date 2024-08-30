##
##  Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
##  Copyright (C) 2008-2008 - INRIA - Bruno JOFRET
##
# Copyright (C) 2012 - 2016 - Scilab Enterprises
#
# This file is hereby licensed under the terms of the GNU GPL v2.0,
# pursuant to article 5.3.4 of the CeCILL v.2.1.
# This file was originally licensed under the terms of the CeCILL v2.1,
# and continues to be available under such terms.
# For more information, see the COPYING file which you should have received
# along with this program.
##
##

FUNCTION_MANAGER_CPP_SOURCES = \
    src/cpp/funcmanager.cpp \
    src/cpp/dynamic_modules.cpp \
    src/cpp/functions_manager.cpp


if MAINTAINER_MODE
pkglib_LTLIBRARIES = libscifunctions_manager.la
else
noinst_LTLIBRARIES = libscifunctions_manager.la
endif # MAINTAINER_MODE


libscifunctions_manager_la_SOURCES = \
    $(FUNCTION_MANAGER_CPP_SOURCES)

libscifunctions_manager_la_CPPFLAGS = \
    -I$(srcdir)/includes/ \
    -I$(top_srcdir)/modules/ast/includes/ast/ \
    -I$(top_srcdir)/modules/ast/includes/exps/ \
    -I$(top_srcdir)/modules/ast/includes/operations/ \
    -I$(top_srcdir)/modules/ast/includes/parse/ \
    -I$(top_srcdir)/modules/ast/includes/symbol/ \
    -I$(top_srcdir)/modules/ast/includes/system_env/ \
    -I$(top_srcdir)/modules/ast/includes/types/ \
    -I$(top_srcdir)/modules/dynamic_link/includes \
	-I$(top_srcdir)/modules/api_scilab/includes/ \
	-I$(top_srcdir)/modules/console/includes/ \
    -I$(top_srcdir)/modules/core/includes/ \
	-I$(top_srcdir)/modules/elementary_functions/includes/ \
	-I$(top_srcdir)/modules/fileio/includes/ \
	-I$(top_srcdir)/modules/jvm/includes/ \
	-I$(top_srcdir)/modules/localization/includes/ \
	-I$(top_srcdir)/modules/output_stream/includes/ \
    -I$(top_srcdir)/modules/signal_processing/includes/ \
	-I$(top_srcdir)/modules/string/includes/ \
	-I$(top_srcdir)/modules/threads/includes/ \
	$(AM_CPPFLAGS) \
	$(XML_FLAGS)

libscifunctions_manager_la_includedir=$(pkgincludedir)

libscifunctions_manager_la_include_HEADERS =
    
include $(top_srcdir)/Makefile.incl.am    
