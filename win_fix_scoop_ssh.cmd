@echo off
reg import "%~dp0\win_fix_scoop_ssh.reg"
net stop sshd
net start sshd
