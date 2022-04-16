@echo off
set cnt=0
for /R Valid %%F in (*.db) do set /a cnt+=1
for /R Curr %%F in (*.db) do set /a cnt+=1
echo %cnt% | Clip