# Get-ManagedCredential

Secure decryption of encrypted credentials.

* [view function](https://github.com/BornToBeRoot/PowerShell_ManagedCredential/blob/master/Module/ManagedCredential/Functions/Get-ManagedCredential.ps1)
* [view script](https://github.com/BornToBeRoot/PowerShell_ManagedCredential/blob/master/Scripts/Get-ManagedCredential.ps1)

## Description

Secure decryption of encrypted credentials, which have been stored in an xml-file or variable. 

If user "A" encrypt the credentials on computer "A", user "B" cannot decrypt the credentials on computer "A" and also user "A" cannot decrypt the credentials on Computer "B".

![Screenshot](Images/Get-ManagedCredential.png?raw=true "Get-ManagedCredential")

## Syntax

### Function

```powershell
Get-ManagedCredential [[-EncryptedCredential] <Object>] [[-FilePath] <String>] [[-AsPlainText]] [<CommonParameters>]
```

### Script

```powershell
.\Get-ManagedCredential.ps1 [[-EncryptedCredential] <Object>] [[-FilePath] <String>] [[-AsPlainText]] [<CommonParameters>]
```

## Example

### Function

```powershell
PS> Get-ManagedCredential -EncryptedCredential $EncryptedCredentials

UserName                Password
--------                --------
Admin                   System.Security.SecureString
 ```

### Script

```powershell
PS> .\Get-ManagerdCredential.ps1 -FilePath E:\Temp\EncryptedCredentials.xml -AsPlainText

Username                Password
--------                --------
Admin                   PowerShell
```

### Encrypted xml-file

![Screenshot](https://github.com/BornToBeRoot/PowerShell_ManagedCredential/blob/master/Documentation/Images/Encrypted_XML-File.png?raw=true "Encrypted XML-File")
