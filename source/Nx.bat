@echo off
setlocal enabledelayedexpansion
if "%1" == "" (
	echo Usage: Nx {option/name} {option}
	echo Options:
	echo  --help     :Have to be the first parameter, shows all options
	echo  --version  :Have to be the first parameter, shows the current version of the DevKit.
	echo  --compile  :Have to be the second parameter, compile the file only.
	echo [Leave the second {option} blank if you want to both compile and run the file]
	exit /b
)
set constlist=
set proctar=java
if "%1" == "--help" (
	echo Usage: Nx {option/name} {option}
	echo Options:
	echo  --help     :Have to be the first parameter, shows all options
	echo  --version  :Have to be the first parameter, shows the current version of the DevKit.
	echo  --compile  :Have to be the second parameter, compile the file only.
	echo [Leave the second {option} blank if you want to both compile and run the file]
	exit /b
)
if "%1" == "--version" goto version
if "%2" == "--compile" (
	set fccompile=true
) 
set fccompilename=%1
set a=%fccompilename:.nx=%
set fccomment=false
set wloopnum=0
set wloopnum2=0
echo @echo off>%a%.bat
echo ::Compiled by Nx compiler>>%a%.bat
for /f "tokens=* delims= " %%x in (%a%.nx) do (
	set deniedToken=false
	set printString=%%x
	for %%a in (%%x) do (
		set ch=%%a
		if "!ch:~-4!" == "[..]" (
			set ch=!ch:[..]=!
			for %%i in (!ch!) do set printString=!printString:%%a=call %%i!
		)
		if "!ch:~-4!" == "[::]" (
			set ch=!ch:[::]=!
			for %%i in (!ch!) do set printString=!printString:%%a=call :%%i!
		)
		if "%%a" == "/*" (
			set fccomment=true
			set printString=!printString:/*=!
		)
		if "%%a" == "*/" (
			set fccomment=false
			set printString=!printString:*/=!
		)
		if %%a == #include (
			set targetFile=!printString:#include =!
			if exist !targetFile!.nx (
				call createFile.bat "!targetFile!"
				type !targetFile!.bat>>%a%.bat
			)
			set deniedToken=true
		)
		if %%a == import (
			set lib=!printString:import =!
			if "!lib!" == "float" (
				echo for /f %%%%i in ('powershell %%~2'^) DO set %%~1=%%%%i> float.bat
				set deniedToken=true
				set floatimp=true
			) else if "!lib!" == "array" (
				(
				echo set /a len=%%~3-1
				echo setlocal enabledelayedexpansion
				echo set max=^^!%%~2[0]^^!
				echo for %%%%i in (0,1,%%len%%^) do if ^^!%%~2[%%%%i]^^! GTR %%max%% set max=^^!%%~2[%%%%i]^^!
				echo (endlocal ^& set %%~1=%%max%%^)
				)>array_max.bat
				(
				echo set /a len=%%~3-1
				echo setlocal enabledelayedexpansion
				echo set min=^^!%%~2[0]^^!
				echo for %%%%i in (0,1,%%len%%^) do if ^^!%%~2[%%%%i]^^! LSS %%max%% set min=^^!%%~2[%%%%i]^^!
				echo (endlocal ^& set %%~1=%%min%%^)
				)>array_min.bat
				(
				echo set /a len=%%~3-1
				echo set sum=0
				echo setlocal enabledelayedexpansion
				echo for %%%%i in (0,1,%%len%%^) do set /a sum+=^^!%%~2[%%%%i]^^!
				echo (endlocal ^& set %%~1=%%sum%%^)
				)>array_sum.bat
				(
				echo set res_len=0
				echo :loop
				echo if not defined %%~2[%%res_len%%] (
				echo	set %%~1=%%res_len%%
				echo	exit /b
				echo ^)
				echo set /a res_len+=1
				echo goto :loop
				)>array_len.bat
				set deniedToken=true
			) else if "!lib!" == "math" (
				(
				echo set tar=%%~2
				echo set %%~1=%%tar:-=%%
				)>math_abs.bat
				(
				echo set /a res=%%~2 %%%% 2
				echo if %%res%% == 0 (
				echo 	set %%~1=true
				echo ^) else (
				echo 	set %%~1=false
				echo ^)
				)>math_even.bat
				(
				echo set /a res=%%~2 %%%% 2
				echo if %%res%% == 0 (
				echo 	set %%~1=false
				echo ^) else (
				echo 	set %%~1=true
				echo ^)
				)>math_odd.bat
				(
				echo set res=%%~2
				echo set /a t=%%~3 - 1
				echo for /l %%%%i in (1,1,%%t%%^) do (
				echo 	set /a res*=%%res%%
				echo ^)
				echo set %%~1=%%res%%
				)>math_pow.bat
				(
				echo set mul=1
				echo for /l %%%%i in (1,1,%%~2^) do set /a mul*=%%%%i
				echo set %%~1=%%mul%%
				)>math_fact.bat
				set deniedToken=true
			) else if "!lib!" == "string" (
				(
				echo set lower=%%~2
				echo set lower=%%lower:A=a%%
				echo set lower=%%lower:B=b%%
				echo set lower=%%lower:C=c%%
				echo set lower=%%lower:D=d%%
				echo set lower=%%lower:E=e%%
				echo set lower=%%lower:F=f%%
				echo set lower=%%lower:G=g%%
				echo set lower=%%lower:H=h%%
				echo set lower=%%lower:I=i%%
				echo set lower=%%lower:J=j%%
				echo set lower=%%lower:K=k%%
				echo set lower=%%lower:L=l%%
				echo set lower=%%lower:M=m%%
				echo set lower=%%lower:N=n%%
				echo set lower=%%lower:O=o%%
				echo set lower=%%lower:P=p%%
				echo set lower=%%lower:Q=q%%
				echo set lower=%%lower:R=r%%
				echo set lower=%%lower:S=s%%
				echo set lower=%%lower:T=t%%
				echo set lower=%%lower:U=u%%
				echo set lower=%%lower:V=v%%
				echo set lower=%%lower:W=w%%
				echo set lower=%%lower:X=x%%
				echo set lower=%%lower:Y=y%%
				echo set lower=%%lower:Z=z%%
				echo set %%~1=%%lower%%
				)>string_lower.bat
				(
				echo set upper=%%~2
				echo set upper=%%upper:a=A%%
				echo set upper=%%upper:b=B%%
				echo set upper=%%upper:c=C%%
				echo set upper=%%upper:d=D%%
				echo set upper=%%upper:e=E%%
				echo set upper=%%upper:f=F%%
				echo set upper=%%upper:g=G%%
				echo set upper=%%upper:h=H%%
				echo set upper=%%upper:i=I%%
				echo set upper=%%upper:j=J%%
				echo set upper=%%upper:k=K%%
				echo set upper=%%upper:l=L%%
				echo set upper=%%upper:m=M%%
				echo set upper=%%upper:n=N%%
				echo set upper=%%upper:o=O%%
				echo set upper=%%upper:p=P%%
				echo set upper=%%upper:q=Q%%
				echo set upper=%%upper:r=R%%
				echo set upper=%%upper:s=S%%
				echo set upper=%%upper:t=T%%
				echo set upper=%%upper:u=U%%
				echo set upper=%%upper:v=V%%
				echo set upper=%%upper:w=W%%
				echo set upper=%%upper:x=X%%
				echo set upper=%%upper:y=Y%%
				echo set upper=%%upper:z=Z%%
				echo set %%~1=%%upper%%
				)>string_upper.bat
				(
				echo setlocal enabledelayedexpansion
				echo set len=0
				echo set str=%%~2
				echo :loop
				echo if not "^!str:^~%%len%%^!" == "" set /a len+=1 ^& goto loop
				echo (endlocal ^& set %%~1=%%len%%^)
				)>string_length.bat
				(
				echo setlocal enabledelayedexpansion
				echo set len=0
				echo set str=%%~2
				echo set newstr=
				echo :loop
				echo if not "^!str:^~%%len%%^!" == "" set /a len+=1 ^& goto loop
				echo set /a strlen=%%len%%-1
				echo for /l %%%%i in (%%strlen%%,-1,0^) do set newstr=^^!newstr^^!^^!str:^~%%%%i,1^^!
				echo (endlocal ^& set %%~1=%%newstr%%^)
				)>string_reverse.bat
				set deniedToken=true
			) else if "!lib!" == "list" (
				(
				echo set max=1
				echo for %%%%i in ^(%%~2^) DO (
				echo 	set max=%%%%i
				echo 	goto fcmaxend
				echo ^)
				echo :fcmaxend
				echo for %%%%i in (%%~2^) DO (
				echo 	if %%%%i GTR %%max%% (
				echo 		set max=%%%%i
				echo 	^)
				echo ^)
				echo set %%~1=%%max%%
				)>list_max.bat
				(
				echo set min=1
				echo for %%%%i in ^(%%~2^) DO (
				echo 	set min=%%%%i
				echo 	goto fcminend
				echo ^)
				echo :fcminend
				echo for %%%%i in (%%~2^) DO (
				echo 	if %%%%i LSS %%min%% (
				echo 		set min=%%%%i
				echo 	^)
				echo ^)
				echo set %%~1=%%min%%
				)>list_min.bat
				(
				echo set sum=0
				echo for %%%%i in ^(%%~2^) DO set /a sum+=%%%%i
				echo set %%~1=%%sum%%
				)>list_sum.bat
				set deniedToken=true
			) else (
				set deniedToken=true
			)
		)
		if %%a == func (
			set procval=0
			set procadd=true
			set proctar=!printString:func =!
			set deniedToken=true
		)
		if %%a == endfunc (
			set procadd=false
			set proctar=none
			set deniedToken=true
		)
		if %%a == reverse set printString=!printString:reverse=call string_reverse.bat!
		if %%a == factorial set printString=!printString:factorial=call math_fact.bat!
		if %%a == length set printString=!printString:length=call string_length.bat!
		if %%a == toUpperCase set printString=!printString:toUpperCase=call string_upper.bat!
		if %%a == toLowerCase set printString=!printString:toLowerCase=call string_lower.bat!
		if %%a == odd set printString=!printString:odd=call math_odd.bat!
		if %%a == even set printString=!printString:even=call math_even.bat!
		if %%a == pow set printString=!printString:pow=call math_pow.bat!
		if %%a == abs set printString=!printString:abs=call math_abs.bat!
		if %%a == max set printString=!printString:max=call list_max.bat!
		if %%a == min set printString=!printString:min=call list_min.bat!
		if %%a == sum set printString=!printString:sum=call list_sum.bat!
		if %%a == arrMax set printString=!printString:arrMax=call array_max.bat!
		if %%a == arrMin set printString=!printString:arrMin=call array_min.bat!
		if %%a == arrSum set printString=!printString:arrSum=call array_sum.bat!
		if %%a == arrLength set printString=!printString:arrLength=call array_len.bat!
		if %%a == drive set printString=!printString:drive =!:
		if %%a == while (
			if "!procadd!" == "true" (
				set outtar=!proctar!.bat
			) else (
				set outtar=%a%.bat
			)
			set fccondition=!printString:while =!
			echo :WhileLoop!wloopnum!>>!outtar!
			echo if not !fccondition! goto EndLoop!wloopnum!>>!outtar!
			set deniedToken=true
		)
		if %%a == endloop (
			if "!procadd!" == "true" (
				set outtar=!proctar!.bat
			) else (
				set outtar=%a%.bat
			)
			echo goto WhileLoop!wloopnum!>>!outtar!
			echo :EndLoop!wloopnum!>>!outtar!
			set /a wloopnum=!wloopnum!+1
			set deniedToken=true
		)
		if %%a == do (
			if "!procadd!" == "true" (
				set outtar=!proctar!.bat
			) else (
				set outtar=%a%.bat
			)
			echo :repeat!wloopnum!>>!outtar!
			set deniedToken=true
		)
		if %%a == dwhile (
			if "!procadd!" == "true" (
				set outtar=!proctar!.bat
			) else (
				set outtar=%a%.bat
			)
			set fccondition2=!printString:dwhile =!
			echo if not !fccondition2! goto until!wloopnum2!>>!outtar!
			echo goto repeat!wloopnum2!>>!outtar!
			echo :until!wloopnum2!>>!outtar!
			set /a wloopnum2=!wloopnum2!+1
			set deniedToken=true
		)
		if %%a == key set printString=!printString:key =CHOICE /C:! /N
		if %%a == print set printString=!printString:print=echo!
		if %%a == #terminate set printString=!printString:#terminate=taskkill /im!
		if %%a == ll set printString=!printString:ll =echo.!
		if %%a == mdir set printString=!printString:mdir=md!
		if %%a == cdir set printString=!printString:cdir=cd!
		if %%a == delete set printString=!printString:delete=del!
		if %%a == rdir set printString=!printString:rdir=rmdir!
		if %%a == file.read set printString=!printString:file.read=type!
		if %%a == int (
			set printString=!printString:int=set /a!
			set printString=!printString:++=+=1!
			set printString=!printString:--=-=1!
		)
		if %%a == #define (
			set !printString:#define=!
			set deniedToken=true
		)
		if %%a == float set printString=!printString:float=call float.bat!
		if %%a == string set printString=!printString:string=set!
		if %%a == input set printString=!printString:input=set /p!
		if %%a == goto set printString=!printString:goto=goto!
		if %%a == call set printString=!printString:call=call!
		if %%a == callLabel set printString=!printString:callLabel =call :!
		if %%a == colour set printString=!printString:colour=color!
		if %%a == winsize set printString=!printString:winsize=mode!
		if %%a == title set printString=!printString:title=title!
		if %%a == rename set printString=!printString:rename=ren!
		if %%a == move set printString=!printString:move=move!
		if %%a == copy set printString=!printString:copy=copy!
		if %%a == run set printString=!printString:run=start!
		if %%a == exit set printString=!printString:exit=exit!
		if %%a == shutdown set printString=!printString:shutdown=shutdown -s -t 0!
		if %%a == restart set printString=!printString:restart=shutdown -r -t 0!
		if %%a == clrscr set printString=!printString:clrscr=cls!
		if %%a == wait set printString=!printString:wait=pause!
		if %%a == "{" set printString=!printString:{=SETLOCAL!
		if %%a == "}" set printString=!printString:}=ENDLOCAL!
		if %%a == date set printString=!printString:date=date /t!
		if %%a == time set printString=!printString:time=time /t!
		if %%a == file.list set printString=!printString:file.list=dir!
		if %%a == if set printString=!printString:if=if!
		if %%a == ifErrorlevel set printString=!printString:ifErrorlevel=if errorlevel!
		if %%a == ifNotErrorlevel set printString=!printString:ifNotErrorlevel=if not errorlevel!
		if %%a == ifNot set printString=!printString:ifNot=if not!
		if %%a == ifDefined set printString=!printString:ifDefined=if defined!
		if %%a == ifExist set printString=!printString:ifExist=if exist!
		if %%a == ifNotExist set printString=!printString:ifNotExist=if not exist!
		if %%a == ifNotDefined set printString=!printString:ifNotDefined=if not defined!
		if %%a == else set printString=!printString:else=else!
		if %%a == elseif set printString=!printString:elseif=else if!
		if %%a == label set printString=!printString:label =:!
		if %%a == for.list set printString=!printString:for.list=for /l!
		if %%a == file.scan set printString=!printString:file.scan=for /r!
		if %%a == str.scan set printString=!printString:str.scan=for /f!
		if %%a == for set printString=!printString:for=for!
		if %%a == dir.scan set printString=!printString:dir.scan=for /d!
		if %%a == ping set printString=!printString:ping=ping!
		if %%a == info set printString=!printString:info=systeminfo!
		if %%a == str.find set printString=!printString:string.find=findstr!
		if %%a == find set printString=!printString:find=find!
		if %%a == powershell set printString=!printString:powershell=powershell!
		if %%a == enableDelay set printString=!printString:enableDelay=setlocal enabledelayedexpansion!
	)

	if "!procadd!" == "true" (
		if !procval! == 0 (
			set procval=1
			echo.>!proctar!.bat
		) else (
			if not "!deniedToken!" == "true" echo.!printString!>>!proctar!.bat
		)
	)
	if "!fccomment!" == "false" (
		if not "!procadd!" == "true" if not "!deniedToken!" == "true" echo.!printString!>>%a%.bat
	) else (
		if not "!procadd!" == "true" echo.::!printString!>>%a%.bat
	)
)
setlocal disabledelayedexpansion
if not "%fccompile%" == "true" if not "%fcread%" == "true" call %a%.bat
exit /b
:version
echo version:0.1
exit /b
