#!/usr/bin/env pwsh

$regex="^\/\/.*([0-9]+.[0-9]+)"
$file=".\ext\cimgui\cimgui.h"
select-string -Path $file -Pattern $regex -AllMatches | Select-Object -ExpandProperty Matches -First 1 | % { $_.Groups[1].Value }