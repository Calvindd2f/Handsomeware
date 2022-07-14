# Encryption code: Encrypts files using AES256 algorithm. 
# The AES key is encrypted with X.509 public key certificate.

$Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2 ($strPublicCert)
[System.Reflection.Assembly]::LoadWithPartialName("System.Security.Cryptography")
$AesProvider = New-Object System.Security.Cryptography.AesManaged
$AesProvider.KeySize = 256
$AesProvider.BlockSize = 128
$AesProvider.Mode = [System.Security.Cryptography.CipherMode]::CNC
$KeyFormatter New-Object System.Security.Cryptography.RSAOAEPKeyExchangeFormatter ($Cert.PublicKey.Key)
