@echo off
setlocal enabledelayedexpansion

:: Input and output
set input_folder=.\..\..\source\ANTLR4
set output_folder=.\..\..\generated\ANTLR4

:: arguments
set antlr4_build=java org.antlr.v4.Tool -Werror

:: Empty the output directory
del /q /s "%output_folder%\*.cpp"
del /q /s "%output_folder%\*.h"
del /q /s "%output_folder%\*.interp"
del /q /s "%output_folder%\*.tokens"

:: Make the output directory
mkdir %output_folder%

:: Process the lexer
%antlr4_build% %input_folder%\PolarFrankieLexer.g4
:: Process the parser
%antlr4_build% %input_folder%\PolarFrankieParser.g4

:: Move the files to the generated files directory
move "%input_folder%\*.cpp" "%output_folder%\"
move "%input_folder%\*.h" "%output_folder%\"
move "%input_folder%\*.interp" "%output_folder%\"
move "%input_folder%\*.tokens" "%output_folder%\"
