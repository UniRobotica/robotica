jb clean .
jb build .

if (Test-Path docs) { Remove-Item docs -Recurse -Force }

xcopy _build\html docs /E /I /Y

start docs\index.html