# New-ManagedCredential

Secure encryption of credentials as SecureString.

* [view function](https://github.com/BornToBeRoot/PowerShell_ManagedCredential/blob/master/Module/ManagedCredential/New-ManagedCredential.ps1)
* [view script](https://github.com/BornToBeRoot/PowerShell_ManagedCredential/blob/master/Scripts/New-ManagedCredential.ps1)

## Description

Secure encryption of credentials as SecureString, which can be saved as an xml-file or variable.

If user "A" encrypt the credentials on computer "A", user "B" cannot decrypt the credentials on computer "A" and also user "A" cannot decrypt the credentials on Computer "B".

![Screenshot](Images/New-ManagedCredential.png?raw=true "New-ManagedCredential")

To enter the credentials, the following window appears

![Screenshot](Images/Get-Credential.png?raw=true "Get-Credential")

## Syntax

### Function

```powershell
New-ManagedCredential [[-OutFile] <String>] [[-Credentials] <PSCredential>] [<CommonParameters>]
```

### Script
```powershell
.\New-ManagedCredential.ps1 [[-OutFile] <String>] [[-Credentials] <PSCredential>] [<CommonParameters>]
```

## Example

### Function

```powershell
PS> $EncryptedCredentials = New-ManagedCredential

PS> $EncryptedCredentials

UsernameAsSecureString : c04fc297eb01000000edade3a984d5ca...
PasswordAsSecureString : 984d5ca4aa6c39de63b9627730000c22...
```

### Script

```powershell
PS> .\New-ManagedCredential.ps1 -OutFile E:\Temp\EncryptedCredentials.xml
```

### Encrypted xml-file

![Screenshot](https://github.com/BornToBeRoot/PowerShell_ManagedCredential/blob/master/Documentation/Images/Encrypted_XML-File.png?raw=true "Encrypted XML-File")
