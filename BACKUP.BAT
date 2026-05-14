@echo off
echo Deleting *.$$$; *.BAK
del *.$$$
del *.bak
echo Zipping Files...
pkzip -ex -u -P backup\backup.zip *.* vsps\*.*
echo Backup Completed.
