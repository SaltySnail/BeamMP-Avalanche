@echo off
setlocal enabledelayedexpansion

set "output_file=trackNames.json"
echo [ > %output_file%

set "first=true"
for %%f in (C:/Users/Julian/Documents/dev/BeamMP-Avalanche/Client/art/*.prefab.json) do (
    if "!first!"=="true" (
        set "first=false"
    ) else (
        echo , >> %output_file%
    )
    set "filename=%%~nf"
    set "filename=!filename:.prefab=!"
    echo   "!filename!" >> %output_file%
)

echo ] >> %output_file%
