# PowerShell Manage Credentials

Module and Script to encrypt/decrypt credentials (username and password) and save them as variable or xml-file using SecureStrings.

## Description

With this script, you can encrypt your credentials (username and password) as SecureStrings and save them as a variable or xml-file. You can also decrypt the variable or xml-file and return a PSCredential-Object or username and password in plain text.
The encrypted credentials can only be decrypted on the same computer and under the same user, which encrypted them.

For exmaple: If user "A" encrypt the credentials on computer "A", user "B" cannot decrypt the credentials on computer "A" and also user "A" cannot decrypt the credentials on Computer "B".

Module and Script:
![Screenshot of Module and Script Result](https://github.com/BornToBeRoot/PowerShell_Manage-Credentials/blob/master/Images/Module_and_Script.png?raw=true)

Encrypted credentials as xml-file:
![Screenshot of Module and Script Result](https://github.com/BornToBeRoot/PowerShell_Manage-Credentials/blob/master/Images/Encrypted_Credentials_XML-File.png?raw=true)

## Install the Module

1) Copy the folder named "Module/ManageCredentials" in your profile under C:\Users\%username%\Documents\WindowsPowerShell\Modules

2) Open a PowerShell-Console and import the module with the command `Import-Module ManageCredentials`

>_On workstations i would recommended using the module. For servers, i would prefer using the script, because you don't need to install anything._

## Syntax

### Module

#### Encrypt

```powershell
New-ManagedCredential [[-Credentials] <PSCredential>] [[-OutFile] <String>] [<CommonParameters>]
``` 

#### Decrypt

```powershell
Get-ManagedCredential [[-EncryptedCredentials] <Object>] [[-FilePath] <String>] [[-PasswordAsPlainText]] [<CommonParameters>]
```

### Script

#### Encrypt

```powershell
.\Manage-Credentials.ps1 [-Encrypt] [[-Credentials] <PSCredential>] [[-OutFile] <String>] [<CommonParameters>]
```

#### Decrypt

```powershell
.\Manage-Credentials.ps1 [-Decrypt] [[-EncryptedCredentials] <Object>] [[-FilePath] <String>] [[-PasswordAsPlainText]] [<CommonParameters>]
```

## Example

### Module

#### Encrypt

Save encrypted credentials as variable

```powershell
$example_encrypted_credentials = New-ManagedCredential
# (Get-Credentials)-Window is shown to enter username and password. You don't need to type the password as plain text.
```

Encrypt credentials and save as xml-file. 

```powershell
New-ManagedCredential -OutFile E:\Scripts\example_credentials.xml
# (Get-Credentials)-Window is shown to enter username and password. You don't need to type the password as plain text. 
```

#### Decrypt

Decrypt credentials and return PSCredentials-Object

```powershell
Get-ManagedCredential -EncryptedCredentials $example_encrypted_credentials
```

Decrypt credentials and return password as plain text (custom object)

```powershell
Get-ManagedCredential -FilePath E:\Scripts\example_credentials.xml -PasswordAsPlainText
```
### Script

#### Encrypt

Save encrypted credentials as variable

```powershell
$example_encrypted_credentials = .\Manage-Credentials.ps1 -Encrypt
# (Get-Credentials)-Window is shown to enter username and password. You don't need to type the password as plain text.
```

Encrypt credentials and save as xml-file. 

```powershell
.\Manage-Credentials.ps1 -Encrypt -OutFile E:\Scripts\example_credentials.xml
# (Get-Credentials)-Window is shown to enter username and password. You don't need to type the password as plain text. 
```

#### Decrypt

Decrypt credentials and return PSCredentials-Object

```powershell
.\Manage-Credentials.ps1 -Decrypt -EncryptedCredentials $example_encrypted_credentials
```

Decrypt credentials and return password as plain text (custom object)

```powershell
.\Manage-Credentials.ps1 -Decrypt -FilePath E:\Scripts\example_credentials.xml -PasswordAsPlainText
```

## Output

### Encrypted xml-file

```xml
<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04">
  <Obj RefId="0">
    <TN RefId="0">
      <T>System.Management.Automation.PSCustomObject</T>
      <T>System.Object</T>
    </TN>
    <MS>
      <S N="UsernameAsSecureString">01000000d08c9ddf0115d1118c7a00c04fc297eb01000000faec5f3ad40df2498d630e9470b6b6b90000000002000000000003660000c000000010000000b254f04ff8c8949640d5cd5b6b0a5be40000000004800000a00000001000000041b1a2035c2177b4c01a94c67a75f09910000000f69942c9e05916f84029a6fef84717ad140000006797b236e32a3156c52022d0e32bc99a37e9cbce</S>
      <S N="PasswordAsSecureString">01000000d08c9ddf0115d1118c7a00c04fc297eb01000000faec5f3ad40df2498d630e9470b6b6b90000000002000000000003660000c00000001000000005059aad09ca77d9f0ac5b2abfe487790000000004800000a000000010000000f1c8b367f6bb2a871b6cd39bc5dd699b180000004237ca2fd9c54dcf2f7c7966ce97dab4483ef73380ecbf2314000000cbc6f8a52814fdd53ae237892b540ff9abdd3ee2</S>
    </MS>
  </Obj>
</Objs>
```

### PSCredentials

```powershell
UserName                                                             Password
--------                                                             --------
Admin                                                                System.Security.SecureString
```

### Custom-PSObject (with password in plain text)

```powershell
Username                                                             Password
--------                                                             --------
Admin                                                                PowerShell
```
