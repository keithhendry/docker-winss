FROM microsoft/windowsservercore

RUN powershell -command \
    $ErrorActionPreference = 'Stop'; \
    $VerbosePreference = 'Continue'; \
    iwr -usebasicparsing 'https://download.microsoft.com/download/9/3/F/93FCF1E7-E6A4-478B-96E7-D4B285925B00/vc_redist.x64.exe' -outfile vcredist.exe; \
    start-process vcredist.exe -ArgumentList '/quiet' -wait ; \
    rm vcredist.exe

RUN powershell -command \
    $ErrorActionPreference = 'Stop'; \
    $VerbosePreference = 'Continue'; \
    (iwr -usebasicparsing 'http://api.github.com/repos/Morgan-Stanley/winss/releases/latest').content -match 'https://github.com/Morgan-Stanley/winss/releases/download/ms/[0-9\.\-]+/winss.zip'; \
    iwr -usebasicparsing $Matches[0] -outfile winss.zip; \
    expand-archive winss.zip -destinationpath 'c:\program files\winss'; \
    New-Item c:\services -type directory; \
    [Environment]::SetEnvironmentVariable('PATH', $env:Path + ';c:\program files\winss', [EnvironmentVariableTarget]::Machine); \
    rm winss.zip

WORKDIR 'c:\services'
CMD winss-svscan.exe
