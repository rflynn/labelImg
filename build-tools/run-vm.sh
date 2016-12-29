#!/bin/bash

set -xe -o pipefail

VBOX_VM=${VBOX_VM:-Windows 10}
VBOX_SNAPSHOT=${VBOX_SNAPSHOT:-set password}
VBOX_USER=${VBOX_USER:-user}
VBOX_PASS=${VBOX_PASS:-password}

function finish {
    VBoxManage controlvm "$VBOX_VM" poweroff
}
trap finish EXIT

echo ensure vm powered off to start...
VBoxManage controlvm "$VBOX_VM" poweroff || true

#VBoxManage snapshot "$VBOX_VM" list --machinereadable
#VBoxManage snapshot "$VBOX_VM" restore 'guest additions installed'

#echo reset vm to known snapshot...
#VBoxManage snapshot "$VBOX_VM" restore "$VBOX_SNAPSHOT"  #  'post-install'
VBoxManage snapshot "$VBOX_VM" restore 'post-install'

echo start vm...
VBoxManage startvm "$VBOX_VM" --type headless

echo wait for the network.........
sleep 10

echo copy script from host to guest
VBoxManage guestcontrol "$VBOX_VM" \
    --verbose --username "$VBOX_USER" --password "$VBOX_PASS" \
    copyto --target-directory '../../../../../Users/user/Downloads' /home/rf/src/labelImg/build-tools/win10.ps1

VBoxManage guestcontrol "$VBOX_VM" \
    --verbose --username "$VBOX_USER" --password "$VBOX_PASS" \
    run --timeout 60000 --wait-stdout -- \
    cmd.exe --arguments '/C ping.exe -n 1 -w 3000 8.8.8.8'

echo run script on guest
VBoxManage guestcontrol "$VBOX_VM" \
    --verbose --username "$VBOX_USER" --password "$VBOX_PASS" \
    run --timeout 6000000 --wait-stdout -- \
    cmd.exe --arguments '/C powershell.exe -NoLogo -NonInteractive -ExecutionPolicy ByPass -File c:\Users\user\Downloads\win10.ps1'

VBoxManage snapshot "$VBOX_VM" take 'post-install' --live

exit $?



<<'EOS'

VBoxManage guestcontrol     <uuid|vmname> [--verbose|-v] [--quiet|-q]
                              [--username <name>] [--domain <domain>]
                              [--passwordfile <file> | --password <password>]
                              copyto [common-options]
                              [--dryrun] [--follow] [-R|--recursive]
                              <host-src0> [host-src1 [...]] <guest-dst>

                              copyto [common-options]
                              [--dryrun] [--follow] [-R|--recursive]
                              [--target-directory <guest-dst>]
                              <host-src0> [host-src1 [...]]





                              run [common-options]
                              [--exe <path to executable>] [--timeout <msec>]
                              [-E|--putenv <NAME>[=<VALUE>]] [--unquoted-args]
                              [--ignore-operhaned-processes] [--no-profile]
                              [--no-wait-stdout|--wait-stdout]
                              [--no-wait-stderr|--wait-stderr]
                              [--dos2unix] [--unix2dos]
                              -- <program/arg0> [argument1] ... [argumentN]]

  snapshot                  <uuid|vmname>
                            take <name> [--description <desc>] [--live]
                                 [--uniquename Number,Timestamp,Space,Force] |
                            delete <uuid|snapname> |
                            restore <uuid|snapname> |
                            restorecurrent |
                            edit <uuid|snapname>|--current
                                 [--name <name>]
                                 [--description <desc>] |
                            list [--details|--machinereadable]
                            showvminfo <uuid|snapname>
EOS

<<'EOS'
if [ ! -e "python-2.7.8.msi" ]; then
    wget "https://www.python.org/ftp/python/2.7.8/python-2.7.8.msi"
fi

if [ ! -e "pywin32-218.win32-py2.7.exe" ]; then
    wget "http://nchc.dl.sourceforge.net/project/pywin32/pywin32/Build%20218/pywin32-218.win32-py2.7.exe"
fi

if [ ! -e "PyQt4-4.11.4-gpl-Py2.7-Qt4.8.7-x32.exe" ]; then
    wget "http://nchc.dl.sourceforge.net/project/pyqt/PyQt4/PyQt-4.11.4/PyQt4-4.11.4-gpl-Py2.7-Qt4.8.7-x32.exe"
fi

if [ ! -e "lxml-2.3.win32-py2.7.exe" ]; then
    wget "https://pypi.python.org/packages/3d/ee/affbc53073a951541b82a0ba2a70de266580c00f94dd768a60f125b04fca/lxml-2.3.win32-py2.7.exe#md5=9c02aae672870701377750121f5a6f84"
fi

wine msiexec -i python-2.7.8.msi
wine pywin32-218.win32-py2.7.exe
wine PyQt4-4.11.4-gpl-Py2.7-Qt4.8.7-x32.exe
wine lxml-2.3.win32-py2.7.exe
EOS

