###############################################################################################################
# Language     :  PowerShell 4.0
# Filename     :  ManagedCredentials.psm1
# Autor        :  BornToBeRoot (https://github.com/BornToBeRoot)
# Description  :  Secure encryption and decryption of credentials
# Repository   :  https://github.com/BornToBeRoot/PowerShell_ManagedCredential
###############################################################################################################

# Include functions which are outsourced in .ps1-files
Get-ChildItem -Path "$PSScriptRoot\Functions" -Recurse | Where-Object {$_.Name.EndsWith(".ps1")} | ForEach-Object {. $_.FullName}