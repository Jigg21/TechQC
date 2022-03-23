tzutil /s "Central Standard Time"
net start w32Time
w32tm /resync /nowait
ECHO Time Set
pause