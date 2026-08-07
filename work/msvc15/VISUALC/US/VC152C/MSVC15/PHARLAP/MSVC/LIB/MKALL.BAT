@echo off
if "%1" == "" goto usage

command /c mklib l e %1
command /c mklib l 7 %1
command /c mklib l a %1

command /c mklib s e %1
command /c mklib s 7 %1
command /c mklib s a %1

command /c mklib m e %1
command /c mklib m 7 %1
command /c mklib m a %1

command /c mklib c e %1
command /c mklib c 7 %1
command /c mklib c a %1

goto end
:err
echo *
echo * Directory '%1' does not exist.
echo *
goto end
:usage
echo *
echo * Usage: mkall [path]
echo *
echo * Make all combinations of ?LIBP?.LIB libraries.
echo *
:end
