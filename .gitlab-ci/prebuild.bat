@echo off

set ARCH=x64

if "%1" == "" (
    echo This script compiles dependencies of Scilab for Windows x64.
    echo.
    echo Syntax: %~n0 ^<dependency^> with dependency equal to:
    echo  - 'version': display versions of dependencies,
    echo  - 'download': download all dependencies,
    echo  - 'copy': download all dependencies,
    echo  - 'fromscratch': 'download' + 'copy'.
    echo.
    exit(42)
)

echo Scilab prerequirements for Windows %ARCH% in branch %BRANCH%

rem ################################
rem ##### DEPENDENCIES VERSION #####
rem ################################
set SVN_REVISION=30092

rem ###############################
rem ##### ARGUMENT MANAGEMENT #####
rem ###############################
:loop
    if "%1" == "" goto :done
    if "%1" == "version" (
        call :make_versions
    )
    if "%1" == "fromscratch" (
        call :download_prereqs
        call :copy
    )
    if "%1" == "download" (
        call :download_prereqs
    )
    if "%1" == "copy" (
        call :copy
    )
    shift
goto :loop

rem #####################
rem ##### FUNCTIONS #####
rem #####################

:make_versions
    echo SVN_REVISION = %SVN_REVISION%
    goto :eof

:download_prereqs
    curl.exe -k -o prereq.zip https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements/prerequirements-scilab-svn-revision-%SVN_REVISION%-windows_x64.zip
    goto :eof

:copy
    copy /Y prereq.zip prerequirements-%SCI_VERSION_STRING%-windows_x64.zip
    goto :eof

:done
