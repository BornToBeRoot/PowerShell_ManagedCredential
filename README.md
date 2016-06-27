# ManagedCredential

Module and script for secure encrpytion and decryption of credentials.

## Description

Module and script for secure encrpytion and decryption of credentials. Encrypted credentials can be stored in an xml-file or variable and be decrypted from there. 

This function uses the [SecureString Class](https://msdn.microsoft.com/en-us/library/system.security.securestring(v=vs.110).aspx) from the .NET-Framework. Once encrypted credentials, can only be decrypted by the same user and on the same computer.

If user "A" encrypt the credentials on computer "A", user "B" cannot decrypt the credentials on computer "A" and also user "A" cannot decrypt the credentials on Computer "B".

## Module

| Function | Description | Help |
| :--- | :--- | :---: |
| [New-ManagedCredential](Module/ManagedCredential/New-ManagedCredential.ps1) | Secure encryption of credentials as SecureString | [:book:](Documentation/New-ManagedCredential.README.md) |
| [Get-ManagedCredential](Module/ManagedCredential/Get-ManagedCredential.ps1) | Secure decryption of encrypted credentials | [:book:](Documentation/Get-ManagedCredential.README.md) |

## How to install the module?

1. Download the [latest Release](https://github.com/BornToBeRoot/PowerShell_ManagedCredential/releases/latest) 
2. Copy the folder [Module\ManagedCredential](Module/ManagedCredential) to `C:\Users\%username%\Documents\WindowsPowerShell\Modules\`
3. Open up a PowerShell as an admin and set the execution policy: `Set-ExecutionPolicy RemoteSigned`
4. Import the Module with the command `Import-Module ManagedCredential` (Maybe add this command to your PowerShell profile)

## Script

| Function | Description | Help |
| :--- | :--- | :---: |
| [New-ManagedCredential](Scripts/New-ManagedCredential.ps1) | Secure encryption of credentials as SecureString | [:book:](Documentation/New-ManagedCredential.README.md) |
| [Get-ManagedCredential](Scripts/Get-ManagedCredential.ps1) | Secure decryption of encrypted credentials | [:book:](Documentation/Get-ManagedCredential.README.md) |

## Encrypted xml-file

![Screenshot](https://github.com/BornToBeRoot/PowerShell_ManagedCredential/blob/master/Documentation/Images/Encrypted_XML-File.png?raw=true "Encrypted XML-File")
