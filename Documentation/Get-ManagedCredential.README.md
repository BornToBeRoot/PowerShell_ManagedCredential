# Get-ManagedCredential

Secure decryption of encrypted credentials.

* [view function](https://github.com/BornToBeRoot/PowerShell_ManagedCredential/blob/master/Module/ManagedCredential/Get-ManagedCredential.ps1)
* [view script](https://github.com/BornToBeRoot/PowerShell_ManagedCredential/blob/master/Scripts/Get-ManagedCredential.ps1)

## Description

Secure decryption of encrypted credentials, which have been stored in an xml-file or variable. 

If user "A" encrypt the credentials on computer "A", user "B" cannot decrypt the credentials on computer "A" and also user "A" cannot decrypt the credentials on Computer "B".

--- add screenshot here ---

## Syntax

### Function

```powershell
Get-ManagedCredential [[-EncryptedCredentials] <Object>] [[-FilePath] <String>] [[-PasswordAsPlainText]] [<CommonParameters>]
```

### Script

```powershell
.\Get-ManagedCredential.ps1 [[-EncryptedCredentials] <Object>] [[-FilePath] <String>] [[-PasswordAsPlainText]] [<CommonParameters>]
```

## Example

### Function

```powershell
PS> Get-ManagedCredential -EncryptedCredentials $EncryptedCredentials

UserName                Password
--------                --------
Admin                   System.Security.SecureString
 ```

### Script

```powershell
PS> .\Get-ManagerdCredential.ps1 -FilePath E:\Temp\EncryptedCredentials.xml -PasswordAsPlainText

Username                Password
--------                --------
Admin                   PowerShell
```

### Encrypted xml-file

![Screenshot](https://github.com/BornToBeRoot/PowerShell_ManagedCredential/blob/master/Documentation/Encrypted_XML-File.png?raw=true "Encrypted XML-File")
