@echo off
cd ..

scons platform=windows dev_build=True debug_symbols=True module_mono_enabled=True vsproj=True
if errorlevel 1 goto error

for %%G in (bin\godot.windows.editor.dev.*.mono.console.exe) do set GODOT_MONO_CONSOLE=%%G
if not defined GODOT_MONO_CONSOLE goto missing_godot

%GODOT_MONO_CONSOLE% --generate-mono-glue .\modules\mono\glue
if errorlevel 1 goto error

py .\modules\mono\build_scripts\build_assemblies.py --godot-output-dir .\bin
if errorlevel 1 goto error

echo.
echo Build, solution generation, and .NET assemblies completed.
pause
exit /b 0

:missing_godot
echo.
echo Could not find bin\godot.windows.editor.dev.*.mono.console.exe.
echo Make sure the C# editor build completed successfully.
pause
exit /b 1

:error
echo.
echo Build failed.
pause
exit /b 1
