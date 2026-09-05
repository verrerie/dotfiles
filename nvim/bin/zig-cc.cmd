@echo off
setlocal enabledelayedexpansion
set ARGS=
set SKIP=0
for %%A in (%*) do (
	set "TOK=%%~A"
	if "!SKIP!"=="1" (
		set SKIP=0
	) else if "!TOK!"=="-target" (
		set SKIP=1
	) else if "!TOK!"=="--target" (
		set SKIP=1
	) else if "!TOK:~0,8!"=="-target=" (
		rem combined form, value is embedded -- nothing more to skip
	) else if "!TOK:~0,9!"=="--target=" (
		rem combined form, value is embedded -- nothing more to skip
	) else (
		set ARGS=!ARGS! "%%~A"
	)
)
zig cc !ARGS!
