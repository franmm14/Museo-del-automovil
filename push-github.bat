@echo off
REM Script para subir el proyecto a GitHub
REM Asegúrate de haber creado el repositorio en GitHub primero

cd /d "%~dp0"

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║          SUBIR PROYECTO A GITHUB - Museo del Automóvil VR     ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

REM Pedir información al usuario
set /p username="Ingresa tu usuario de GitHub: "
set /p repo_name="Ingresa el nombre del repositorio (ej: museo-autos-vr): "

REM Confirmar la URL
echo.
echo La URL será: https://github.com/%username%/%repo_name%.git
set /p confirm="¿Es correcta? (s/n): "

if /i not "%confirm%"=="s" (
    echo Operación cancelada.
    pause
    exit /b
)

echo.
echo Conectando repositorio remoto...
git remote set-url origin https://github.com/%username%/%repo_name%.git

echo.
echo Verificando estado...
git status

echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                    SUBIENDO A GITHUB...                       ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

REM Hacer push
git push -u origin main

if errorlevel 1 (
    echo.
    echo ⚠️  ERROR en el push. Posibles soluciones:
    echo.
    echo 1. Asegúrate de haber creado el repositorio en GitHub:
    echo    https://github.com/new
    echo.
    echo 2. Verifica tu usuario y contraseña/token
    echo.
    echo 3. Si es SSH, verifica que tu clave está configurada
    echo.
    echo Para más información, lee GITHUB_SETUP.txt
    echo.
) else (
    echo.
    echo ✅ ¡ÉXITO! El proyecto ha sido subido a GitHub
    echo.
    echo Accede a: https://github.com/%username%/%repo_name%
    echo.
)

pause
