@ECHO OFF
color 0A
TITLE - UnifL Installation Assistant -

Set Unifl.Reg.Key=HKEY_LOCAL_MACHINE\SOFTWARE\UnifL\History
Set General.Reg.Val=GeneralInstallPath
Set AMD.Reg.Val=AMDInstallPath
Set Intel.Reg.Val=IntelInstallPath
Set Anchor.Reg.Val=BoolAnchor

set i=1

Set First.start.Reg.Val=FirstStart
Set Automode.Reg.Val=Automode

Set Is.Legacy.Reg.Val=IsLegacy

Set Autoinstall.app.name=Unifl_Installation_Assistant.bat

Set RunOncePath=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce

NET SESSION >nul 2>&1
IF %ERRORLEVEL% EQU 0 (
    GOTO :polling
) ELSE (
    ECHO.
    ECHO UIA requires Superuser or Administrator rights.
	ECHO.	
	ECHO Please run/re-run it with respective permissions.
	ECHO.
	ECHO Exiting...
    ECHO.
	ECHO.
    Pause
    EXIT /B 1
) 

:polling
(For /F "Tokens=2*" %%A In ('Reg Query "%Unifl.Reg.Key%" /v "%General.Reg.Val%" ^| Find /I "%General.Reg.Val%"' ) Do Call Set gendir=%%B)> NUL 2>&1 
(For /F "Tokens=2*" %%A In ('Reg Query "%Unifl.Reg.Key%" /v "%AMD.Reg.Val%" ^| Find /I "%AMD.Reg.Val%"' ) Do Call Set amddir=%%B)> NUL 2>&1 
(For /F "Tokens=2*" %%A In ('Reg Query "%Unifl.Reg.Key%" /v "%Intel.Reg.Val%" ^| Find /I "%Intel.Reg.Val%"' ) Do Call Set inteldir=%%B)> NUL 2>&1 

(For /F "Tokens=2*" %%A In ('Reg Query "%Unifl.Reg.Key%" /v "%Automode.Reg.Val%" ^| Find /I "%Automode.Reg.Val%"' ) Do Call Set automode=%%B)> NUL 2>&1

(For /F "Tokens=2*" %%A In ('Reg Query "%Unifl.Reg.Key%" /v "%First.start.Reg.Val%" ^| Find /I "%First.start.Reg.Val%"' ) Do Call Set firststart=%%B)> NUL 2>&1

(For /F "Tokens=2*" %%A In ('Reg Query "%Unifl.Reg.Key%" /v "%Is.Legacy.Reg.Val%" ^| Find /I "%Is.Legacy.Reg.Val%"' ) Do Call Set islegacy=%%B)> NUL 2>&1

IF "%firststart%."=="." (

(REG ADD "%Unifl.Reg.Key%" /v "%First.start.Reg.Val%" /t REG_SZ /d 0 /f)> NUL 2>&1
goto ask

) ELSE (

IF "%firststart%"=="0" (

IF "%automode%"=="1" (

goto automode

) ELSE (

IF "%automode%"=="0" (

goto manualmode

) ELSE (

goto ask

)
)
)

:ask
CLS
ECHO.
ECHO ***************************************************************
ECHO *********** - UnifL Installation Assistant - v2.0.2 ***********
ECHO ***************************************************************
ECHO.
ECHO ***************************************************************
ECHO                 Please, select option (S or E)
ECHO ***************************************************************
ECHO *                                                             *
ECHO *  [S]tart Installation (You guide the process)               *
ECHO *  [E]xit.                                                    *
ECHO *                                                             *
ECHO ***************************************************************

REM if "%islegacy%"=="yes" (
REM 
REM ECHO.
REM ECHO *********************** IMPORTANT *************************
REM ECHO IMPORTANT: 
REM ECHO IF you have Generation 1 Intel Card, outdated Intel 
REM ECHO installer won't allow installation on Windows 8/8.1.
REM ECHO Therefore, you should use "Have Disk Method" like:
REM ECHO http://tinyurl.com/kzwtghg
REM ECHO.
REM ECHO *********************** IMPORTANT *************************
REM ECHO.
REM )

REM ECHO.

REM ECHO Getting General UnifL path...

IF "NONE%gendir%"=="NONE" (

for /L %%n in (1,1,1) do goto polling

CLS
ECHO No set is unpacked. Aborting.
ECHO.
ECHO Perhaps Installation Assistant is missing Registry Rights?
ECHO.
ECHO Press "Enter" to continue...
echo.
PAUSE > NUL

goto prematureend;

) ELSE (

ECHO.
ECHO General Paths for UIA:
ECHO.
ECHO "%gendir%"
ECHO "%amddir%"
ECHO "%inteldir%"

)

REM ) ELSE (

REM ECHO "%gendir%"
REM )

REM ECHO Getting AMD UnifL path...

REM ECHO "%amddir%"

REM ECHO Getting Intel UnifL path...

REM ECHO "%inteldir%"

ECHO.

verify >nul
CHOICE /C SE /N /M "Waiting for your command:"

IF %ERRORLEVEL%==1 (
SET DRIVENUM=1
goto manualmode
)

IF %ERRORLEVEL%==2 (
SET DRIVENUM=2
goto simpleend
)

:manualmode
CLS
echo.
echo ***************************************************************
ECHO ***********         Manual mode initialized         ***********
echo ***************************************************************
echo.

(REG ADD "%Unifl.Reg.Key%" /v "%Automode.Reg.Val%" /t REG_SZ /d 0 /f)> NUL 2>&1

(For /F "Tokens=2*" %%A In ('Reg Query "%Unifl.Reg.Key%" /v "%Anchor.Reg.Val%" ^| Find /I "%Anchor.Reg.Val%"' ) Do Call Set anchor=%%B)> NUL 2>&1

IF "%anchor%"=="" (

echo ***************************************************************
echo          Phase 1 - Initializing Driver Installation...
echo ***************************************************************
echo.

echo 1. Performing preparations for 2-nd Installation phase:
echo  * Enabling 2-nd phase autostart...
(REG ADD "%RunOncePath%" /v "%Autoinstall.app.name%" /t REG_SZ /d "%gendir%\%Autoinstall.app.name%" /f)> NUL 2>&1
echo  * Releasing Anchor for 2-nd phase...
(REG ADD "%Unifl.Reg.Key%" /v "%Anchor.Reg.Val%" /t REG_SZ /d 1 /f)> NUL 2>&1
echo.

echo 2. Launching Intel Installer...
START /WAIT %inteldir%\Setup.exe

echo.

goto manualend_phase1;

) ELSE (

IF "%anchor%"=="1" (

echo ***************************************************************
echo          Phase 2 - Initializing Driver Installation...
echo ***************************************************************
echo. 

echo 1. Performing Cleanup:
echo * Removing Anchor...
(REG DELETE "%Unifl.Reg.Key%" /v "%Anchor.Reg.Val%" /f)> NUL 2>&1

echo * Removing Firststart key...
(REG DELETE "%Unifl.Reg.Key%" /v "%First.start.Reg.Val%" /f)> NUL 2>&1

echo * Removing Automode key...
(REG DELETE "%Unifl.Reg.Key%" /v "%Automode.Reg.Val%" /f)> NUL 2>&1

echo * Removing Autostart key...
(REG DELETE "%RunOncePath%" /v "%Autoinstall.app.name%" /f)> NUL 2>&1

echo.

echo 2. Launching AMD Installer...
START /I %amddir%\Bin64\InstallManagerApp.exe
echo.

goto manualend_phase2
)
)

:prematureend
echo.
PAUSE
exit

:manualend_phase1
CLS
echo ***************************************************************
echo ***********            COMPLETED PHASE 1            ***********
echo ***************************************************************
echo.
echo Installation Assistant completed its work. 
echo.
echo Please RESTART your laptop if wasn't prompted by Intel Installer.
echo.
echo You can now safely close this window. Hit "Enter" to close it.
echo.
PAUSE > NUL
goto simpleend

:manualend_phase2
CLS
echo ***************************************************************
echo ***********            COMPLETED PHASE 2            ***********
echo ***************************************************************
echo.
echo Installation Assistant completed its work. 
echo.
echo Follow AMD Installer Instructions. 
echo.
echo !!DONT FORGET TO REBOOT AFTERWARDS!!
echo.
echo This Window will auto-close in:
timeout 15
echo.
goto simpleend

:simpleend
exit