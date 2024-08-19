;
; Scilab ( https://www.scilab.org/ ) - This file is part of Scilab
; Copyright (C) INRIA - Allan CORNET
; Copyright (C) DIGITEO - 2010 - Allan CORNET
;
; Copyright (C) 2012 - 2016 - Scilab Enterprises
;
; This file is hereby licensed under the terms of the GNU GPL v2.0,
; pursuant to article 5.3.4 of the CeCILL v.2.1.
; This file was originally licensed under the terms of the CeCILL v2.1,
; and continues to be available under such terms.
; For more information, see the COPYING file which you should have received
; along with this program.
;
;--------------------------------------------------------------------------------------------------------------
; Inno Setup Script (5.3 and more) for Scilab (UNICODE version required)
;
;--------------------------------------------------------------------------------------------------------------
; helptools module
;--------------------------------------------------------------------------------------------------------------
;
#define HELPTOOLS "helptools"

Source: bin\{#HELPTOOLS}.dll; DestDir: {app}\bin; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\jar\org.scilab.modules.helptools.jar; DestDir: {app}\modules\{#HELPTOOLS}\jar; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\jar\scilab_*_*_help.jar; DestDir: {app}\modules\{#HELPTOOLS}\jar; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\jar\scilab_images.jar; DestDir: {app}\modules\{#HELPTOOLS}\jar; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\inline\*.*; DestDir: {app}\modules\{#HELPTOOLS}\inline; Flags: recursesubdirs; Components: {#COMPN_SCILAB}

;
Source: modules\{#HELPTOOLS}\sci_gateway\{#HELPTOOLS}_gateway.xml; DestDir: {app}\modules\{#HELPTOOLS}\sci_gateway; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
;
Source: thirdparty\docbook\*.*;DestDir: {app}\thirdparty\docbook; Flags: recursesubdirs; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
;
Source: thirdparty\jhall-2.0.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\avalon-framework-4.1.4.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\commons-io-2.11.0.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
;Source: thirdparty\docbook-xsl-saxon.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
;Source: thirdparty\fop-2.9.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\fop-core-2.9.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\fop-events-2.9.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\fop-util-2.9.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\fontbox-2.0.27.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\jeuclid-core-3.1.14.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\Saxon-HE-12.4.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\httpcore5-5.1.3.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\httpclient5-5.1.3.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\xmlresolver-6.0.4.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\xml-apis-1.4.01.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\xml-apis-ext-1.3.04.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\xmlgraphics-commons-2.9.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\batik-all-1.17.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\lucene-analysis-common-9.10.0.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\lucene-core-9.10.0.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\lucene-queryparser-9.10.0.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: thirdparty\jakarta.activation-2.0.1.jar;DestDir: {app}\thirdparty; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
;
Source: modules\{#HELPTOOLS}\license.txt; DestDir: {app}\modules\{#HELPTOOLS}; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
;
Source: modules\{#HELPTOOLS}\etc\fopconf.xml; DestDir: {app}\modules\{#HELPTOOLS}\etc; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\etc\SciDocConf.xml; DestDir: {app}\modules\{#HELPTOOLS}\etc; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\help.dtd; DestDir: {app}\modules\{#HELPTOOLS}; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
;
Source: modules\{#HELPTOOLS}\schema\*.*; DestDir: {app}\modules\{#HELPTOOLS}\schema; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\xsl\*.*; DestDir: {app}\modules\{#HELPTOOLS}\xsl; Flags: recursesubdirs; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\data\*.*; DestDir: {app}\modules\{#HELPTOOLS}\data; Flags: recursesubdirs; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
;
Source: modules\{#HELPTOOLS}\etc\{#HELPTOOLS}.quit; DestDir: {app}\modules\{#HELPTOOLS}\etc; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\etc\{#HELPTOOLS}.start; DestDir: {app}\modules\{#HELPTOOLS}\etc; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\etc\MAIN_CHAPTERS; DestDir: {app}\modules\{#HELPTOOLS}\etc; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
;
Source: modules\{#HELPTOOLS}\macros\buildmacros.sce; DestDir: {app}\modules\{#HELPTOOLS}\macros; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\macros\buildmacros.bat; DestDir: {app}\modules\{#HELPTOOLS}\macros; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\macros\cleanmacros.bat; DestDir: {app}\modules\{#HELPTOOLS}\macros; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\macros\lib; DestDir: {app}\modules\{#HELPTOOLS}\macros; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\macros\*.sci; DestDir: {app}\modules\{#HELPTOOLS}\macros; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
Source: modules\{#HELPTOOLS}\macros\*.bin; DestDir: {app}\modules\{#HELPTOOLS}\macros; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
;
Source: modules\{#HELPTOOLS}\examples\*.*; DestDir: {app}\modules\{#HELPTOOLS}\examples; Flags: recursesubdirs; Components: {#COMPN_SCILAB} and {#COMPN_JVM_MODULE}
;
Source: modules\{#HELPTOOLS}\tests\*.*; DestDir: {app}\modules\{#HELPTOOLS}\tests; Flags: recursesubdirs; Components: {#COMPN_SCILAB} and {#COMPN_TESTS} and {#COMPN_JVM_MODULE}
;
;--------------------------------------------------------------------------------------------------------------
