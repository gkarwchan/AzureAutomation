$ErrorActionPreference = "Stop"
New-AzResourceGroup -Name 'ReferenceGroup' -Location 'CentralUS' -Force -Tag @{'RG'='APP'}
New-AzKeyVault -Name "dev-keyvault-gkar" -ResourceGroupName "ReferenceGroup" -Location "CentralUS" -EnabledForTemplateDeployment
#//https://dev-keyvault-gkar.vault.azure.net/
$secretvalue = ConvertTo-SecureString "....." -AsPlainText -Force
Set-AzKeyVaultSecret -VaultName "dev-keyvault-gkar" -Name "sqlPassword" -SecretValue $secretvalue
New-AzResourceGroup -Name 'DevGroup' -Location 'CentralUS' -Force -Tag @{'RG'='APP'}

$servicePrincipal = New-AzADServicePrincipal -DisplayName gkar-pipeline-dev
$serviceSecret = $servicePrincipal.PasswordCredentials.SecretText

Write-Output "Service Principal application ID: $($servicePrincipal.AppId)"
Write-Output "Service Principal ID: $($serviceSecret)"
Write-Output "Azure Tenant ID: $((Get-AzContext).Tenant.Id)"

New-AzRoleAssignment `
    -ApplicationId $servicePrincipal.AppId `
    -RoleDefinitionName Contributor `
    -Scope '/subscriptions/f0750bbe-ea75-4ae5-b24d-a92ca601da2c/resourceGroups/DevGroup' `
    -Description "The deployment pipeline for the company's website needs to be able to create resources within the resource group."

    $servicePrincipal = New-AzADServicePrincipal -DisplayName MyPipeline -Role Contributor -Scope '/subscriptions/f0750bbe-ea75-4ae5-b24d-a92ca601da2c/resourceGroups/ToyWebsite'
    
# Get-AzKeyVaultSecret -VaultName "dev-keyvault-gkar" -Name "sqlPassword" -AsPlainText

# $keyVaultName = 'YOUR-KEY-VAULT-NAME'
# $login = Read-Host "Enter the login name" -AsSecureString
# $password = Read-Host "Enter the password" -AsSecureString

# New-AzKeyVault -VaultName $keyVaultName -Location westus3 -EnabledForTemplateDeployment
# Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorLogin' -SecretValue $login
# Set-AzKeyVaultSecret -VaultName $keyVaultName -Name 'sqlServerAdministratorPassword' -SecretValue $password