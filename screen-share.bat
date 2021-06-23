@ECHO OFF
CLS

WHERE /q adb
IF %ERRORLEVEL% NEQ 0 (
  ECHO adb is NOT defined. Install and include it in the PATH to proceed.
  PAUSE
  START https://developer.android.com/studio/releases/platform-tools
  EXIT
)

WHERE /q ffplay
IF %ERRORLEVEL% NEQ 0 (
  ECHO ffmpeg is NOT defined. Install and include it in the PATH to proceed.
  PAUSE
  START https://ffmpeg.org
  EXIT
)

:Choice
ECHO 1. Connect
ECHO 2. Share screen
ECHO 3. Disconnect
ECHO.

CHOICE /C 123 /N /M "Enter your choice:"

IF ERRORLEVEL 3 GOTO Disconnect
IF ERRORLEVEL 2 GOTO ShareScreen
IF ERRORLEVEL 1 GOTO Connect
ECHO.

:Connect
ECHO Plug phone in via USB. Make sure emulator is switched off.
PAUSE
FOR /F "tokens=*" %%g IN ('adb exec-out "ifconfig wlan0 | egrep -o '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1"') do (SET ip=%%g)
adb tcpip 5555
adb connect %ip%:5555
echo Finished - unplug USB.
PAUSE
EXIT

:ShareScreen
ECHO Make sure the phone is unlocked.
PAUSE
adb exec-out screenrecord --size 1280x720 --bit-rate 8M --output-format=h264 - | ffplay -flags low_delay -fast -framedrop -framerate 60 -probesize 32 -sync video -
EXIT

:Disconnect
adb kill-server
adb usb
ECHO Finished - ADB is reset to USB mode.
PAUSE
EXIT