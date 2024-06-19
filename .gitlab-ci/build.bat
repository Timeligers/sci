REM Scilab ( http://www.scilab.org/ ) - This file is part of Scilab
REM Copyright (C) Dassault Systemes - 2022 - Clement DAVID
REM Copyright (C) Dassault Systemes - 2022 - Cedric DELAMARRE
REM
REM Builder script for building Scilab on Windows
REM
REM NOTE: log all commands to log files to avoid hitting Gitlab log limit

REM set Visual Studio environment
call "%VS2022INSTALLDIR%\Common7\Tools\VsDevCmd.bat"
echo on


REM Create log folder
set LOG_PATH=%SCI_VERSION_STRING%
if not exist %LOG_PATH% mkdir %LOG_PATH%

REM checkout pre-requirements
REM Try with custom build for this commit or tag
move /Y prerequirements-%SCI_VERSION_STRING%-windows_x64.zip prereq.zip
if errorlevel 1 (
    REM no specific prereq build, use the branch one
    curl.exe -k -o prereq.zip https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements/prerequirements-scilab-branch-%BRANCH%-windows_x64.zip
)
if errorlevel 1 (
    REM fallback to the default branch
    curl.exe -k -o prereq.zip https://oos.eu-west-2.outscale.com/scilab-releases-dev/prerequirements/prerequirements-scilab-branch-%CI_DEFAULT_BRANCH%-windows_x64.zip
)
unzip -o prereq.zip -d scilab > %LOG_PATH%\log_prereq_%CI_COMMIT_SHORT_SHA%.txt

@REM REM display svn revision
type scilab\svn-info.txt
if errorlevel 1 exit 1

REM Define environment variables if not defined
IF "%SCILAB_JDK64%"=="" set SCILAB_JDK64=%JAVA_HOME%

cd scilab

REM patch version numbers
sed -i ^
 -e "s/SCI_VERSION_STRING .*/SCI_VERSION_STRING \"%SCI_VERSION_STRING%\"/" ^
 -e "s/SCI_VERSION_WIDE_STRING .*/SCI_VERSION_WIDE_STRING L\"%SCI_VERSION_STRING%\"/" ^
 -e "s/SCI_VERSION_REVISION .*/SCI_VERSION_REVISION \"%CI_COMMIT_SHA%\"/" ^
 -e "s/SCI_VERSION_TIMESTAMP .*/SCI_VERSION_TIMESTAMP %SCI_VERSION_TIMESTAMP%/" ^
 modules\core\includes\version.h.vc
if exist modules\core\includes\version.h sed -i ^
 -e "s/SCI_VERSION_STRING .*/SCI_VERSION_STRING \"%SCI_VERSION_STRING%\"/" ^
 -e "s/SCI_VERSION_WIDE_STRING .*/SCI_VERSION_WIDE_STRING L\"%SCI_VERSION_STRING%\"/" ^
 -e "s/SCI_VERSION_REVISION .*/SCI_VERSION_REVISION \"%CI_COMMIT_SHA%\"/" ^
 -e "s/SCI_VERSION_TIMESTAMP .*/SCI_VERSION_TIMESTAMP %SCI_VERSION_TIMESTAMP%/" ^
 modules\core\includes\version.h
echo SCIVERSION=%SCI_VERSION_STRING% >Version.incl

REM build with Visual Studio and Intel compilers
devenv Scilab.sln /build "Release|x64" /project dumpexts > ..\%LOG_PATH%\log_dumpexts_%CI_COMMIT_SHORT_SHA%.txt
devenv Scilab.sln /build "Release|x64" > ..\%LOG_PATH%\log_build_%CI_COMMIT_SHORT_SHA%.txt
if errorlevel 1 tail --lines=20 ..\%LOG_PATH%\log_build_%CI_COMMIT_SHORT_SHA%.txt 1>&2 & exit 1
devenv Scilab.sln /build "Release|x64" /project buildhelp > ..\%LOG_PATH%\log_buildhelp_%CI_COMMIT_SHORT_SHA%.txt
if errorlevel 1 tail --lines=20 ..\%LOG_PATH%\log_buildhelp_%CI_COMMIT_SHORT_SHA%.txt 1>&2 & exit 1
devenv Scilab.sln /build "Release|x64" /project buildjavadoc > ..\%LOG_PATH%\log_buildjavadoc_%CI_COMMIT_SHORT_SHA%.txt
if errorlevel 1 tail --lines=20 ..\%LOG_PATH%\log_buildjavadoc_%CI_COMMIT_SHORT_SHA%.txt 1>&2 & exit 1

REM Package with Inno Setup 6
if exist "Scilab.iss" del /f "Scilab.iss"
bin\WScilex-cli.exe -nb -f "tools\innosetup\Create_ISS.sce" > ..\%LOG_PATH%\log_iss_%CI_COMMIT_SHORT_SHA%.txt
if errorlevel 1 tail --lines=20 ..\%LOG_PATH%\log_iss_%CI_COMMIT_SHORT_SHA%.txt 1>&2 & exit 1
if not exist "Scilab.iss" exit 1
set ISS_MR=0
if "%CI_PIPELINE_SOURCE%" == "merge_request_event" set ISS_MR=1
"C:\Program Files (x86)\Inno Setup 6\iscc.exe" Scilab.iss /DMR=%ISS_MR% >> ..\%LOG_PATH%\log_iss_%CI_COMMIT_SHORT_SHA%.txt
if errorlevel 1 tail --lines=20 ..\%LOG_PATH%\log_iss_%CI_COMMIT_SHORT_SHA%.txt 1>&2 & exit 1

copy "..\%SCI_VERSION_STRING%\" "%SCILAB_COMMON_PATH%\%SCI_VERSION_STRING%\log\"
if errorlevel 1 exit 1

REM artifact and persistant files
move ".\Output\%SCI_VERSION_STRING%_%ARCH%.exe" "..\%SCI_VERSION_STRING%.bin.%ARCH%.exe"
copy "..\%SCI_VERSION_STRING%.bin.%ARCH%.exe" "%SCILAB_COMMON_PATH%\%SCI_VERSION_STRING%\%SCI_VERSION_STRING%.bin.%ARCH%.exe"
if errorlevel 1 exit 1

exit 0
