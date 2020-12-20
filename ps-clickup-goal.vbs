Set objShell = CreateObject("Shell.Application")
d = CreateObject("Scripting.FileSystemObject").GetParentFolderName(WScript.ScriptFullName)
objShell.ShellExecute "powershell", "-Command ""& {Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force ; . """ + d + "\ps-clickup-goal.ps1""}""", "", "", 0