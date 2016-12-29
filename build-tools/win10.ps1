Write-Host $HOME

# md -Force $HOME\Downloads\

Set-Location $HOME\Downloads\

ls

# LOL PowerShell
[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

if (-NOT (Test-Path python-2.7.8.msi)) {

    # works
    #Invoke-WebRequest -Uri http://www.google.com/ -OutFile google.html -TimeoutSec 600

    # does not work due to https
    #Invoke-WebRequest -Uri https://www.python.org/ftp/python/2.7.8/python-2.7.8.msi -OutFile python-2.7.8.msi -TimeoutSec 600

    $webClient = new-object System.Net.WebClient
    $webClient.DownloadFile("https://www.python.org/ftp/python/2.7.8/python-2.7.8.msi", "c:\Users\user\Downloads\python-2.7.8.msi")
}

ls

if (-NOT (Test-Path PyQt4-4.11.4-gpl-Py2.7-Qt4.8.7-x32.exe)) {
    $webClient = new-object System.Net.WebClient
    $webClient.DownloadFile("http://nchc.dl.sourceforge.net/project/pyqt/PyQt4/PyQt-4.11.4/PyQt4-4.11.4-gpl-Py2.7-Qt4.8.7-x32.exe", "c:\Users\user\Downloads\PyQt4-4.11.4-gpl-Py2.7-Qt4.8.7-x32.exe")
}

ls

if (-NOT (Test-Path lxml-2.3.win32-py2.7.exe)) {
    $webClient = new-object System.Net.WebClient
    $webClient.DownloadFile("https://pypi.python.org/packages/3d/ee/affbc53073a951541b82a0ba2a70de266580c00f94dd768a60f125b04fca/lxml-2.3.win32-py2.7.exe#md5=9c02aae672870701377750121f5a6f84", "c:\Users\user\Downloads\lxml-2.3.win32-py2.7.exe")
}

# msiexec /a "c:\Users\user\Downloads\python-2.7.8.msi"

