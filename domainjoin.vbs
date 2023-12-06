Option Explicit

Dim strDomainFile, strOUFile
Dim objFSO, objDomainFile, objOUFile
Dim strDomain, strOU, strComputer, strUsername, strPassword
Dim objNetwork, objComputer

' Check if the required number of command-line arguments is provided
If WScript.Arguments.Count < 2 Then
    WScript.Echo "Usage: cscript JoinDomain.vbs <Username> <Password>"
    WScript.Quit
End If

' Set the paths for the text files containing domain and OU information
strDomainFile = "C:\DeploymentScripts\Domain.txt"
strOUFile = "C:\DeploymentScripts\OU.txt"

' Create a FileSystemObject
Set objFSO = CreateObject("Scripting.FileSystemObject")

' Read domain and OU from text files
Set objDomainFile = objFSO.OpenTextFile(strDomainFile, 1)
strDomain = objDomainFile.ReadLine
objDomainFile.Close

Set objOUFile = objFSO.OpenTextFile(strOUFile, 1)
strOU = objOUFile.ReadLine
objOUFile.Close

' Get the local computer name
Set objNetwork = CreateObject("WScript.Network")
strComputer = objNetwork.ComputerName

' Get the username and password from command-line arguments
strUsername = WScript.Arguments(0)
strPassword = WScript.Arguments(1)

' Create computer object
Set objComputer = GetObject("WinNT://" & strDomain & "/" & strComputer)

' Join the computer to the domain
objComputer.JoinDomainOrWorkgroup strDomain, strPassword, strOU & "\" & strUsername, strPassword, 3

' Check the result
If Err.Number = 0 Then
    WScript.Echo "Computer joined to domain successfully!"
Else
    WScript.Echo "Error joining computer to domain: " & Err.Description
End If
