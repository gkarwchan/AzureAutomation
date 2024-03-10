$ErrorActionPreference = "Stop"
New-AzResourceGroup -Name 'DevGroup' -Location 'CentralUS' -Force -Tag @{'RG'='APP'}
New-AzKeyVault -Name "dev-keyvault-gkar" -ResourceGroupName "DevGroup" -Location "CentralUS" -EnabledForTemplateDeployment
#//https://dev-keyvault-gkar.vault.azure.net/
$secretvalue = ConvertTo-SecureString "......" -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName "dev-keyvault-gkar" -Name "sqlPassword" -SecretValue $secretvalue
# Get-AzKeyVaultSecret -VaultName "dev-keyvault-gkar" -Name "sqlPassword" -AsPlainText

# $keyVaultName = 'YOUR-KEY-VAULT-NAME'
# $login = Read-Host "Enter the login name" -AsSecureString
# $password = Read-Host "Enter the password" -AsSecureString

# New-AzKeyVault -VaultName $keyVaultName -Location westus3 -EnabledForTemplateDeployment
# Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorLogin' -SecretValue $login
# Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorPassword' -SecretValue $password