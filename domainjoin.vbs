' JoinDomain.vbs
' VBScript program to join a computer to a domain.
' The computer account is created in Active Directory.
' The computer must have XP or above.
' The AD must be W2k3 or above.

Dim strDomain, strUser, strPassword
Dim objNetwork, strComputer, objComputer, lngReturnValue
Dim strOU

Const JOIN_DOMAIN = 1
Const ACCT_CREATE = 2
Const ACCT_DELETE = 4
Const WIN9X_UPGRADE = 16
Const DOMAIN_JOIN_IF_JOINED = 32
Const JOIN_UNSECURE = 64
Const MACHINE_PASSWORD_PASSED = 128
Const DEFERRED_SPN_SET = 256
Const INSTALL_INVOCATION = 262144

'delete existing account
Const NETSETUP_ACCT_DELETE = 2 'Disables computer account in domain.
Set objNetwork = CreateObject("WScript.Network")
strComputer = objNetwork.ComputerName

Set objComputer = GetObject("winmgmts:{impersonationLevel=Impersonate}!\\" & _
 strComputer & "\root\cimv2:Win32_ComputerSystem.Name='" & strComputer & "'")
strDomain1 = objComputer.Domain
intReturn = objComputer.UnjoinDomainOrWorkgroup _
 (strPassword, strDomain1 & "\" & strUser, NETSETUP_ACCT_DELETE)

' add new account on new domain
' Read domain from file
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objDomainFile = objFSO.OpenTextFile("C:\DeploymentScripts\domain.txt", 1)
strDomain = objDomainFile.ReadLine
objDomainFile.Close

' Read OU from file
Set objOUFile = objFSO.OpenTextFile("C:\DeploymentScripts\OU.txt", 1)
strOU = objOUFile.ReadLine
objOUFile.Close

' Get credentials as arguments
strDomain = WScript.Arguments(0)
strUser = WScript.Arguments(1)
strPassword = WScript.Arguments(2)

Set objNetwork = CreateObject("WScript.Network")
strComputer = objNetwork.ComputerName

Set objComputer = GetObject("winmgmts:" _
& "{impersonationLevel=Impersonate,authenticationLevel=Pkt}!\\" & _
strComputer & "\root\cimv2:Win32_ComputerSystem.Name='" & _
strComputer & "'")

lngReturnValue = objComputer.JoinDomainOrWorkGroup(strDomain, _
strPassword, strDomain & "\" & strUser, strOU, _
JOIN_DOMAIN + ACCT_CREATE)

' Check the return value and display a message
If lngReturnValue = 0 Then
    WScript.Echo "Computer successfully joined to the domain."
Else
    WScript.Echo "Failed to join the domain. Error code: " & lngReturnValue
End If
