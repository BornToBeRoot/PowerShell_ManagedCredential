# PowerShell Manage Credentials

Module and Script to encrypt/decrypt credentials (username and password) and save them as variable or xml-file using SecureStrings.

## Description

With this script, you can encrypt your credentials (username and password) as SecureStrings and save them as a variable or xml-file. You can also decrypt the variable or xml-file and return a PSCredential-Object or username and password in plain text.
The encrypted credentials can only be decrypted on the same computer and under the same user, which encrypted them.

For exmaple: If user "A" encrypt the credentials on computer "A", user "B" cannot decrypt the credentials on computer "A" and also user "A" cannot decrypt the credentials on Computer "B".

![Screenshot of Module and Script Result](https://github.com/BornToBeRoot/PowerShell_Manage-Credentials/blob/master/Documentation/Module_and_Script.png?raw=true)

## Download and Install

The Module can be installed like every other PowerShell-Module. If you don't know how... follow this steps:

* Download the latest version of the module and all scripts from GitHub ([latest release](https://github.com/BornToBeRoot/PowerShell-Manage-Credentials/releases/latest))
* Copy the folder `Module\ManageCredentials` in your profile under `C:\Users\%username%\Documents\WindowsPowerShell\Modules`
* Open up a PowerShell as an admin and set the execution policy: `Set-ExecutionPolicy RemoteSigned`
* Import the "ManageCredentials"-Module with the command `Import-Module ManageCredentials` (Maybe add this command to your PowerShell profile)

>_On workstations i would recommended using the module. For servers, i would prefer using the script, because you don't need to install anything._

## Syntax

### Module

```powershell
New-ManagedCredential [[-Credentials] <PSCredential>] [[-OutFile] <String>] [<CommonParameters>]

Get-ManagedCredential [[-EncryptedCredentials] <Object>] [[-FilePath] <String>] [[-PasswordAsPlainText]] [<CommonParameters>]
```

### Script

```powershell
.\Manage-Credentials.ps1 [-Encrypt] [[-Credentials] <PSCredential>] [[-OutFile] <String>] [<CommonParameters>]

.\Manage-Credentials.ps1 [-Decrypt] [[-EncryptedCredentials] <Object>] [[-FilePath] <String>] [[-PasswordAsPlainText]] [<CommonParameters>]
```

## Example

### Module

```powershell
PS> $example_encrypted_credentials = New-ManagedCredential	# (Get-Credentials)-Window will popup to enter credentials securely


# Variable: $example_encrypted_credentials

UserName                                                             Password
--------                                                             --------
Admin                                                                System.Security.SecureString


PS> .\New-ManagedCredential.ps1 -OutFile E:\Scripts\example_credentials.xml
```

#### Decrypt

Decrypt credentials and return PSCredentials-Object

```powershell
PS> Get-ManagedCredential -EncryptedCredentials $example_encrypted_credentials

UserName                                                             Password
--------                                                             --------
Admin                                                                System.Security.SecureString


PS> .\Get-ManagedCredential.ps1 -FilePath E:\Scripts\example_credentials.xml -PasswordAsPlainText

Username                                                             Password
--------                                                             --------
Admin                                                                PowerShell
```

### Encrypted xml-file

![Screenshot of Module and Script Result](https://github.com/BornToBeRoot/PowerShell_Manage-Credentials/blob/master/Documentation/Encrypted_Credentials_XML-File.png?raw=true)