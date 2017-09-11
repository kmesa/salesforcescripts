# Reason: Encrypts and Decrypts data

<#
.SYNOPSIS
    Function to encrypt data

.OUTPUTS
    No return
#>
function setPassword($pass, $name){
    # Save Location
    $encryptedFile = "C:\Users\kmesa\fullstack\Powershell script\Keys\"+ $name
    $KeyFile = "C:\Users\kmesa\fullstack\Powershell script\Keys\MasterKey.key"
    #creates key file
    #$key = New-Object Byte[] 16
    #[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($Key)
    #$key | out-file $KeyFile
    # Creates pass file using encryption key
    $key = Get-Content $KeyFile
    $pass | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString -key $key | Out-File $encryptedFile
}

<#
.SYNOPSIS
    Function to decrypt data

.OUTPUTS
    Returns decrypted password
#>
function getPassword($scriptName) {
    $key = Get-Content "C:\Users\kmesa\fullstack\Powershell script\Keys\MasterKey.key"
    $passFile = Get-content (Get-ChildItem -Path "C:\Users\kmesa\fullstack\Powershell script\Keys\$scriptName") | ConvertTo-SecureString -Key $key
    #$pass =(Get-Content $passPath )
    return [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passFile))
}
