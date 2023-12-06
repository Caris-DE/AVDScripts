Option Explicit

Dim strDomain, strOU, strComputer, strUsername, strPassword
Dim objNetwork, objComputer

' Check if the required number of command-line arguments is provided
If WScript.Arguments.Count < 2 Then
    WScript.Echo "Usage: cscript JoinDomain.vbs <Username> <Password>"
    WScript.Quit
End If

' Set the domain, OU
strDomain = "$domaintojoin"
strOU = "$targetOU"

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
