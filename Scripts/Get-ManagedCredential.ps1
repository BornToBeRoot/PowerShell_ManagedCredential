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
    .\Get-ManagedCredential.ps1 -EncryptedCredentials $EncryptedCredentials

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
        Position=1,
        Mandatory=$true,
        HelpMessage='PSObject with encrypted credentials')]
    [System.Object]$EncryptedCredentials,

    [Parameter(
        Position=2,
        HelpMessage='Return password as plain text')]
    [Switch]$PasswordAsPlainText
)

Begin{

}

Process
{
    if($PSCmdlet.ParameterSetName -eq 'File')
    {			
        if(-not(Test-Path -Path $FilePath))
        {
            Write-Host "FilePath ($FilePath) does not exists. Check your Input!" -ForegroundColor Yellow
            return	
        }

        if((Get-Item -Path $FilePath) -is [System.IO.DirectoryInfo])
        {
            Write-Host "FilePath ($FilePath) is a directory, but an xml-file is required. Check your input!" -ForegroundColor Yellow				
            return
        }				
        
        try {
            $EncryptedCredentials = Import-Clixml -Path $FilePath -ErrorAction Stop				
        }
        catch [System.Exception] {
            Write-Host "Import-Clixml: $($_.Exception.Message)" -ForegroundColor Red
            return
        }		
    }
    
    if($EncryptedCredentials -eq $null)
    {			
        Write-Host 'Nothing to decrypt. Try "Get-Help" for more details' -ForegroundColor Yellow
        return
    }
    
    try {
        $SecureString_Password = $EncryptedCredentials.PasswordAsSecureString | ConvertTo-SecureString -ErrorAction Stop
        $SecureString_Username = $EncryptedCredentials.UsernameAsSecureString | ConvertTo-SecureString -ErrorAction Stop

        $BSTR_Username = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString_Username)
        $Username = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR_Username) 
        
        if($PasswordAsPlainText) 
        {
            $BSTR_Password = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString_Password)
            $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR_Password)

            $PlainText_Credentials = New-Object -TypeName PSObject
            Add-Member -InputObject $PlainText_Credentials -MemberType NoteProperty -Name Username -Value $Username
            Add-Member -InputObject $PlainText_Credentials -MemberType NoteProperty -Name Password -Value $Password

            return $PlainText_Credentials
        }
        else
        {
            $Credentials = New-Object System.Management.Automation.PSCredential($Username, $SecureString_Password)

            return $Credentials
        }
    }
    catch [System.Exception] {
        Write-Host "$($_.Exception.Message)" -ForegroundColor Red
        return	
    }
}

End{

}