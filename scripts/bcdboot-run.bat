@echo off

echo :: As a quick recap after copying windows system to new HDD:
echo.
echo :: 1. If you have EFI no need to fiddle with diskpart for setting "active" 
echo ::    partition (this is normally called bootable flag);
echo.
echo :: 2. mount your new windows partition as G: and your new EFI partition as J:
echo.
setlocal

:askInput
set winpart=G
set /p "winpart=What is windows new partition (default: %winpart%)? "
dir %winpart%:
if ERRORLEVEL 1 (
    goto askInput
)
:askEfipart
set efipart=J
set /p "efipart=What is EFI new partition (default: %efipart%)? "
dir %efipart%:
if ERRORLEVEL 1 (
    goto askEfipart
)

echo.
echo :: 3. I will execute now:
echo bcdboot %winpart%:\windows /s %efipart%: /d /addlast
echo.

set right=Y
set /p "right=Right (Y)? "

if not "%right%"=="Y" (
    goto askInput
)

echo.
bcdboot %winpart%:\windows /s %efipart%: /d /addlast
echo.

echo :: 4. replace HDD;
echo.
echo :: 5. boot into new HDD, select first boot option Windows 8.1, it should boot fine.
echo.
echo :: 6. remove any non-current boot loader entries with bcdedit (if not needed):
echo ::    bcdedit /delete  {82889745-b2e5-4fd5-ba8d-f8e7bcb29100}
echo.
echo :: 7. you may add some boot menu description:
echo ::
echo ::    bcdedit /set {current} description "Windows on Samsung 4TB"
