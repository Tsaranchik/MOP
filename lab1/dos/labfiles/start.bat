@echo off

cls
echo Comilation of main file...
tasm /l mopl1.asm
pause
if errorlevel 1 goto compilation_error_1

echo Compilation of lib file...
tasm mopl1l.asm
pause
if errorlevel 1 goto compilation_error_2

echo Linking...
tlink mopl1.obj mopl1l.obj, lab1
pause
if errorlevel 1 goto linking_error

cls
lab1.exe
echo ^
pause
if errorlevel 1 goto runtime_error
goto end

:compilation_error_1
echo Compilation error of main file
goto end

:compilation_error_2
echo Compilation error of lib file
goto end

:linking_error
echo Linking error
goto end

:runtime_error
echo Runtime error
goto end

:end
cls

