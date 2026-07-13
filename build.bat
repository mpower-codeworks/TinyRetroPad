@echo off
setlocal

rem Build TRPad with Microsoft MASM and LINK.EXE.
set "SOURCE=trpad.asm"
set "OBJECT=trpad.obj"
set "OUTPUT=trpad.exe"
set "MASM_INCLUDE=C:\masm32\include"
set "SDK_LIB=C:\Program Files (x86)\Windows Kits\10\Lib\10.0.20348.0\um\x86"

ml /nologo /c /coff /Cp /I"%MASM_INCLUDE%" "%SOURCE%"
if errorlevel 1 goto :assemble_failed

link /nologo ^
  /OUT:"%OUTPUT%" ^
  /ENTRY:MainEntry ^
  /SUBSYSTEM:WINDOWS ^
  /MACHINE:X86 ^
  /INCREMENTAL:NO ^
  /OPT:REF ^
  /OPT:ICF ^
  /LIBPATH:"%SDK_LIB%" ^
  "%OBJECT%" ^
  kernel32.lib user32.lib shell32.lib comdlg32.lib gdi32.lib

if errorlevel 1 goto :link_failed

del /q "%OBJECT%" 2>nul
echo Built %OUTPUT% 
exit /b 0

:assemble_failed
echo Assembly failed. No executable was produced.
exit /b 1

:link_failed
echo Link failed. Keeping %OBJECT% for diagnosis.
exit /b 1
