###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  ManagedCredentials.psm1
# Autor        :  BornToBeRoot (https://github.com/BornToBeRoot)
# Description  :  Secure encryption of credentials as SecureString
# Repository   :  https://github.com/BornToBeRoot/PowerShell_ManagedCredential
###############################################################################################################

<#
    .SYNOPSIS
    Secure encryption of credentials as SecureString
    
    .DESCRIPTION
    Secure encryption of credentials as SecureString, which can be saved as an xml-file or variable.

    If user "A" encrypt the credentials on computer "A", user "B" cannot decrypt the credentials on 
    computer "A" and also user "A" cannot decrypt the credentials on Computer "B".
        
    .EXAMPLE
    $EncryptedCredentials = New-ManagedCredential

    $EncryptedCredentials
        
    UsernameAsSecureString : c04fc297eb01000000edade3a984d5ca...
    PasswordAsSecureString : 984d5ca4aa6c39de63b9627730000c22...

    .EXAMPLE
    New-ManagedCredential -OutFile E:\Temp\EncryptedCredentials.xml

	.LINK
	https://github.com/BornToBeRoot/PowerShell_ManagedCredential/blob/master/Documentation/New-ManagedCredential.README.md
#>

function New-ManagedCredential()
{
    [CmdletBinding()]
    Param(
        [Parameter(
            Position=0,
            HelpMessage='Path to the xml-file where the encrypted credentials will be saved')]
        [String]$OutFile,
      
        [Parameter(
            Position=1,
			HelpMessage='PSCredential-Object (e.g. Get-Credentials)')]
        [System.Management.Automation.PSCredential]$Credentials       
    )

    Begin{

	}

	Process{
		if($Credentials -eq $null)
        {
            try{
                $Credentials = Get-Credential $null 
            } 
			catch{
                throw
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
                $Title = "Overwrite existing file"
                $Info = "Do you want to overwrite the exisiting file?"
                
                $Options = [System.Management.Automation.Host.ChoiceDescription[]] @("&Yes", "&No")
                [int]$Defaultchoice = 0
                $Opt =  $host.UI.PromptForChoice($Title , $Info, $Options, $Defaultchoice)

                switch($Opt)
                {                    
                    1 { 
                        return
                    }
                }
            }           
			
            $EncryptedCredentials | Export-Clixml -Path $FilePath
		}
		else
		{
			$EncryptedCredentials
		}
	}

	End{

	}
}