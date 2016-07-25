@echo off
setlocal EnableDelayedExpansion
setlocal EnableExtensions

set "gpo_dir=%systemroot%\system32\GroupPolicy"
set "secdb_dir=%systemroot%\security\database"

if "%1"=="get" (
    for %%g in (Machine, User) do (
        mkdir %%g 2> nul
        copy !gpo_dir!\%%g\Registry.pol %%g > nul
    )
    secedit /export /cfg SecurityPolicy.inf
) else if "%1"=="put" (
    for %%g in (Machine, User) do (
        copy %%g\Registry.pol !gpo_dir!\%%g > nul
    )
    copy !secdb_dir!\secedit.sdb %temp% > nul
    rem FIXME: condition true in case of inaccessible file!
    if %errorlevel% equ 0 (
        secedit /import /db %temp%\secedit.sdb /cfg SecurityPolicy.inf > nul
        secedit /configure /db %temp%\secedit.sdb /cfg SecurityPolicy.inf
        del %temp%\secedit.sdb
    ) else (
        echo Error accessing secedit.sdb, close Security Policy app ^(secpol.msc^)^! >&2
    )
) else (
    echo Usage: %~nx0 get^|put
)




