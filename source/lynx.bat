@echo off
if "%1" == "" (
	echo you can download any library for Nx with lynx
	echo --help has to be the first parameter, shows all the options
	echo --list has to be the first parameter, shows the name of all the libraries and frameworks
	echo --download has to be the first parameter, downloads the library or framewrok, you have to write the name of the library or framework in the second parameter
)

if "%1" == "--help" (
	echo you can download any library for Nx with lynx
	echo --help has to be the first parameter, shows all the options
	echo --list has to be the first parameter, shows the name of all the libraries and frameworks
	echo --download has to be the first parameter, downloads the library or framewrok, you have to write the name of the library or framework in the second parameter
)

if "%1" == "--list" (
	echo 1. download
	echo 2. unzip
)

if "%1" == "--download" (
	cd libraries
	if "%2" == "download" (
		powershell -Command "Invoke-WebRequest https://download1075.mediafire.com/t4k9ksabuirg/bebd8qm5z900kr7/download.bat -Outfile download.bat"
	)
	if "%2" == "unzip" (
		powershell -Command "Invoke-Webrequest https://download1643.mediafire.com/jyr4x8acngfg/naahrjuldp5rm9j/unzip.bat -Outfile unzip.bat"
	)
)