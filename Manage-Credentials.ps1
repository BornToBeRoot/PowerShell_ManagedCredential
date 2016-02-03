###############################################################################################################
# Language     :  PowerShell 4.0
# Script Name  :  Manage-Credentials.ps1
# Autor        :  BornToBeRoot (https://github.com/BornToBeRoot)
# Description  :  Script to Encrypt/Decrypt Credentials and save them as Xml-File
# Repository   :  https://github.com/BornToBeRoot/PowerShell-Manage-Credentials
###############################################################################################################




[CmdletBinding()]
Param(
	[Parameter(
		ParameterSetName='Encrypt',
		HelpMessage='Encrypt Credentials')]
	[switch]$Encrypt,

    [Parameter(
		ParameterSetName='Encrypt',
		Position=0,
		HelpMessage='PSCredential-Object (e.g. Get-Credentials)')]
	[System.Management.Automation.PSCredential]$Credentials,
	
    [Parameter(
		ParameterSetName='Encrypt',
		Position=1,
		HelpMessage='Path to the Xml-File where the encrypted credentials will be saved')]
	[String]$OutFile,
		
	[Parameter(
		ParameterSetName='Decrypt',
		HelpMessage='Decrypt Credentials')]
	[switch]$Decrypt,
	
    [Parameter(
		ParameterSetName='Decrypt',
		Position=0,
		HelpMessage='PSObject with encrypted credentials to decrypt them')]
	[System.Object]$EncryptedCredentials,	

    [Parameter(
		ParameterSetName='Decrypt',
		Position=1,
		HelpMessage='Path to the Xml-File where the encrypted credentials are saved')]
	[String]$FilePath,

    [Parameter(
        ParameterSetName='Decrypt',
        Position=2,
        HelpMessage='Return password as plain text')]
    [switch]$PasswordAsPlainText
)

if($Encrypt)
{
    if($Credentials -eq $null)
    {
        try{
            $Credentials = Get-Credential $null 
        } catch {
            Write-Host "Canceled by User." -ForegroundColor Yellow
            return
        }      
    }
            
    $EncryptedCredentials = New-Object -Type PSObject
    Add-Member -InputObject $EncryptedCredentials -MemberType NoteProperty -Name UsernameAsSecureString -Value ($Credentials.Username | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString)
	Add-Member -InputObject $EncryptedCredentials -MemberType NoteProperty -Name PasswordAsSecureString -Value ($Credentials.Password | ConvertFrom-SecureString)
    
    if(-not[String]::IsNullOrEmpty($OutFile))
    {
        $FilePath = $OutFile.Replace(".\","").Replace("\","") 
                
        if(-not([System.IO.Path]::IsPathRooted($FilePath))) 
        { 
            $ScriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

            $FilePath = Join-Path -Path $ScriptPath -ChildPath $FilePath
        }
	    
        if(-not($FilePath.ToLower().EndsWith(".xml"))) 
        { 
            $FilePath += ".xml" 
        }

        if([System.IO.File]::Exists($FilePath))
        {
            Write-Host "Overwriting existing file ($FilePath)" -ForegroundColor Yellow
        }           
        
        $FilePath

        $EncryptedCredentials | Export-Clixml -Path $FilePath
    }
    else
    {
        return $EncryptedCredentials   
    }    
}
elseif($Decrypt)
{
    if(-not([String]::IsNullOrEmpty($FilePath)))
    {
         $EncryptedCredentials = Import-Clixml -Path $FilePath
    }
    
    if($EncryptedCredentials -eq $null)
    {
        Write-Host 'Nothing to decrypt! Try "-EncryptedCredentials" or "-FilePath"' -ForegroundColor Yellow
        Write-Host 'Try "Get-Help .\Manage-Credentials.ps1" for more details'
        return
    }    

    $BSTR_Username = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(($EncryptedCredentials.UsernameAsSecureString | ConvertTo-SecureString))
    $Username = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR_Username)
       
    if($PasswordAsPlainText) 
    {
        $BSTR_Password = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR(($EncryptedCredentials.PasswordAsSecureString | ConvertTo-SecureString))
        $Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR_Password)

        $PlainText_Credentials = New-Object -Type PSObject
        Add-Member -InputObject $PlainText_Credentials -MemberType NoteProperty -Name Username -Value $Username
	    Add-Member -InputObject $PlainText_Credentials -MemberType NoteProperty -Name Password -Value $Password

        return $PlainText_Credentials
    }
    else
    {
        $Password = $EncryptedCredentials.PasswordAsSecureString | ConvertTo-SecureString
        
        return New-Object System.Management.Automation.PSCredential($Username , $Password)
    }
}