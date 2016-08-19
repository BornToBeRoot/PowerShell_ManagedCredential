###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  ManagedCredentials.psm1
# Autor        :  BornToBeRoot (https://github.com/BornToBeRoot)
# Description  :  Secure decryption of encrypted credentials
# Repository   :  https://github.com/BornToBeRoot/PowerShell_ManagedCredential
###############################################################################################################

<#
    .SYNOPSIS
	Secure decryption of encrypted credentials

    .DESCRIPTION
   	Secure decryption of encrypted credentials, which have been stored in an xml-file or variable.

    If user "A" encrypt the credentials on computer "A", user "B" cannot decrypt the credentials on 
    computer "A" and also user "A" cannot decrypt the credentials on Computer "B".

    .EXAMPLE
    .\Get-ManagedCredential.ps1 -EncryptedCredential $EncryptedCredentials

	UserName                Password
	--------                --------
	Admin                   System.Security.SecureString
    
    .EXAMPLE
   	.\Get-ManagerdCredential.ps1 -FilePath E:\Temp\EncryptedCredentials.xml -PasswordAsPlainText

	Username                Password
	--------                --------
	Admin                   PowerShell	
	        
    .LINK
    https://github.com/BornToBeRoot/PowerShell_ManagedCredential/blob/master/Documentation/Get-ManagedCredential.README.md
#>

[CmdletBinding(DefaultParameterSetName='File')]
Param(
    [Parameter(
        ParameterSetName='File',
        Position=0,
        Mandatory=$true,
        HelpMessage='Path to the xml-file where the encrypted credentials are saved')]
    [String]$FilePath,
    
    [Parameter(
        ParameterSetName='Variable',
        Position=0,
        Mandatory=$true,
        HelpMessage='Encrypted credential')]
    [pscustomobject]$EncryptedCredential,

    [Parameter(
        Position=2,
        HelpMessage='Return password as plain text')]
    [Switch]$AsPlainText
)

Begin{

}

Process
{
    if($PSCmdlet.ParameterSetName -eq 'File')
    {			
        if(-not(Test-Path -Path $FilePath))
        {
            throw "FilePath ($FilePath) does not exists. Check your Input!"
        }

        if((Get-Item -Path $FilePath) -is [System.IO.DirectoryInfo])
        {
            throw "FilePath ($FilePath) is a directory, but an xml-file is required. Check your input!"				
        }				
        
        try {
            $EncryptedCredential = Import-Clixml -Path $FilePath -ErrorAction Stop				
        }
        catch {
            throw
        }		
    }
    
    if($null -eq $EncryptedCredential)
    {			
        throw 'Nothing to decrypt. Try "Get-Help" for more details'
    }
    
    try {
        $SecureString_Username = $EncryptedCredential.UsernameAsSecureString | ConvertTo-SecureString -ErrorAction Stop
        $SecureString_Password = $EncryptedCredential.PasswordAsSecureString | ConvertTo-SecureString -ErrorAction Stop
        

        $BSTR_Username = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString_Username)
        $Username = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR_Username) 
        
        if($AsPlainText) 
        {
            $BSTR_Password = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString_Password)
            $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR_Password)

            [pscustomobject] @{
                Username = $Username
                Password = $Password
            }
        }
        else
        {
            New-Object System.Management.Automation.PSCredential($Username, $SecureString_Password)
        }
    }
    catch {
        throw	
    }
}

End{

}