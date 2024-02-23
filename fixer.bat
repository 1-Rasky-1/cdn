@echo off
set imgPath=C:\Windows\Web\Wallpaper\Windows\img0.jpg
set downloadURI=https://i.imgur.com/Omr8DpD.jpeg
echo * Finding Default Wallpaper File...
echo - %imgPath%
if exist "%imgPath%" (
  echo + File Found
) else (
  echo - File Not Found
  echo * Download with curl...
  curl --version >nul 2>&1 && (
     curl --output %imgPath% %downloadURI%    
  ) || (
     echo - curl not Found - using powershell..
     powershell -Command "Invoke-WebRequest -URI %downloadURI% -OutFile %imgPath%"
  )
  echo + Wallpaper Downloaded
)
echo * Setting Wallpaper...
echo * Writing Registory...
reg add "HKCU\Control Panel\Desktop" /v wallpaper /t REG_SZ /d "" /f 2>nul
reg add "HKCU\Control Panel\Desktop" /v wallpaper /t REG_SZ /d %imgPath% /f 2>nul
reg delete "HKCU\Control Panel\Desktop" /v TranscodedImageCache /f 2>nul
reg delete "HKCU\Software\Microsoft\Internet Explorer\Desktop\General" /v WallpaperStyle /f 2>nul
reg add "HKCU\control panel\desktop" /v WallpaperStyle /t REG_SZ /d 10 /f 2>nul
echo * Calling UpdatePerUserSystemParameters...
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
echo * Stoping Explorer...
taskkill /IM explorer.exe /F
echo * Starting Explorer...
start explorer.exe
echo * Recalling UpdatePerUserSystemParameters...
RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters
echo + Successfully Fixed Wallpaper!
pause