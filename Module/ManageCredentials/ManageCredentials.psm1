###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  ManagedCredentials.psm1
# Autor        :  BornToBeRoot (https://github.com/BornToBeRoot)
# Description  :  Module to Encrypt/Decrypt Credentials and save them as variable or xml-file
# Repository   :  https://github.com/BornToBeRoot/PowerShell_Manage-Credentials
###############################################################################################################

<#
    .SYNOPSIS
    Function to encrypt credentials as SecureString

    .DESCRIPTION
    With this function, you can encrypt your crendentials (username and password) as SecureString and save them
	as a variable or xml-file. 

	The encrypted credentials can only be decrypted on the same computer and under the same user, which encrypted
    them. 
    For exmaple: 
    If user A encrypt the credentials on computer A, user B cannot decrypt the credentials on 
    computer A and also user A cannot decrypt the credentials on Computer B.

    .EXAMPLE
    $Encrypted_Credentials = New-ManagedCredential    

    .EXAMPLE
    New-ManagedCredential -OutFile E:\Scripts\Credentials.xml
	      
    .LINK
    Github Profil:         https://github.com/BornToBeRoot
    Github Repository:     https://github.com/BornToBeRoot/PowerShell_Manage-Credentials
#>

function New-ManagedCredential()
{
    [CmdletBinding()]
    Param(
        [Parameter(
            Position=0,
			HelpMessage='PSCredential-Object (e.g. Get-Credentials)')]
        [System.Management.Automation.PSCredential]$Credentials,
        
        [Parameter(
            Position=1,
            HelpMessage='Path to the xml-file where the encrypted credentials will be saved')]
        [String]$OutFile
    )

    Begin{}
	Process{
		if($Credentials -eq $null)
        {
            try{
                $Credentials = Get-Credential $null 
            } 
			catch{
                Write-Host "Canceled by User." -ForegroundColor Yellow
                return
            }      
        }
	
		$EncryptedCredentials = New-Object -TypeName PSObject
		Add-Member -InputObject $EncryptedCredentials -MemberType NoteProperty -Name UsernameAsSecureString -Value ($Credentials.UserName | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString)
		Add-Member -InputObject $EncryptedCredentials -MemberType NoteProperty -Name PasswordAsSecureString -Value ($Credentials.Password | ConvertFrom-SecureString)
		
		if(-not([String]::IsNullOrEmpty($OutFile)))
        {               
			if(-not([System.IO.Path]::IsPathRooted($OutFile))) 
            { 	
				$FilePath = Join-Path -Path $PSScriptRoot -ChildPath $OutFile.Replace(".\","")
            }
			else
			{
				$FilePath = $OutFile
			}
	    
            if(-not($FilePath.ToLower().EndsWith(".xml"))) 
            { 
                $FilePath += ".xml" 
            }

            if([System.IO.File]::Exists($FilePath))
            {
                Write-Host "Overwriting existing file ($FilePath)" -ForegroundColor Yellow
            }           
			
            $EncryptedCredentials | Export-Clixml -Path $FilePath
		}
		else
		{
			return $EncryptedCredentials
		}
	}
	End{}
}

<#
    .SYNOPSIS
    Function to decrypt encrypted credentials (SecureString to plain text)

    .DESCRIPTION
    With this function, you can decrypt encrypted credentials and return them as SecureStringplain text.
	
	The encrypted credentials can only be decrypted on the same computer and under the same user, which encrypted
    them. 
    For exmaple: 
    If user A encrypt the credentials on computer A, user B cannot decrypt the credentials on 
    computer A and also user A cannot decrypt the credentials on Computer B.

    .EXAMPLE
	Get-ManagedCredential -EncryptedCredentials $Encrypted_Credentials
        
    .EXAMPLE
    $Creds = Get-ManagedCredential -FilePath E:\Scripts\Credentials.xml -PasswordAsPlainText
	        
    .LINK
    Github Profil:         https://github.com/BornToBeRoot
    Github Repository:     https://github.com/BornToBeRoot/PowerShell_Manage-Credentials
#>

function Get-ManagedCredential()
{
	[CmdletBinding()]
	Param(
		[Parameter(
			Position=0,			
			HelpMessage='PSObject with encrypted credentials')]
		[System.Object]$EncryptedCredentials,

		[Parameter(
			Position=1,
			HelpMessage='Path to the xml-file where the encrypted credentials are stored')]
		[String]$FilePath,

		[Parameter(
			Position=2,
			HelpMessage='Return password as plain text')]
		[Switch]$PasswordAsPlainText
	)

	Begin{}
	Process
	{
		if(-not([String]::IsNullOrEmpty($FilePath)))
		{
			if($EncryptedCredentials -ne $null)
			{
				Write-Host 'Both parameters ("-EncryptedCredentials" and "-FilePath") are not allowed. Using parameter "-FilePath"' -ForegroundColor Yellow
			}
		
			$EncryptedCredentials = Import-Clixml -Path $FilePath
		}

		if($EncryptedCredentials -eq $null)
		{
			Write-Host 'Nothing to decrypt! Use the parameter "-EncryptedCredentials" or "-FilePath"' -ForegroundColor Yellow
			Write-Host 'Try "Get-Help .\Manage-Credentials.ps1" for more details'
			return
		}
		
		$SecureString_Password = $EncryptedCredentials.PasswordAsSecureString | ConvertTo-SecureString 
		$SecureString_Username = $EncryptedCredentials.UsernameAsSecureString | ConvertTo-SecureString
    
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
	End{}
}