# Opsole App Registration Test (minimal output)

$TenantId = Read-Host "Tenant ID"
$ClientId = Read-Host "Client ID"
$SecretSecure = Read-Host "Client Secret (hidden)" -AsSecureString

# Convert SecureString -> plain only for the token request (not printed)
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecretSecure)
$SecretPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)
[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)

$TokenUri = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"
$Body = @{
  client_id     = $ClientId
  client_secret = $SecretPlain
  grant_type    = "client_credentials"
  scope         = "https://graph.microsoft.com/.default"
}

try {
  $Token = Invoke-RestMethod -Method Post -Uri $TokenUri -Body $Body -ContentType "application/x-www-form-urlencoded" -ErrorAction Stop
}
catch {
  Write-Host "FAIL: Token request failed." -ForegroundColor Red
  Write-Host ""
  Write-Host "Common causes:" -ForegroundColor Yellow
  Write-Host "- Wrong Tenant ID"
  Write-Host "- Wrong Client ID"
  Write-Host "- Invalid or expired secret"
  Write-Host "- App not configured for client credentials"
  Write-Host "- Conditional Access blocking"
  exit 1
}
finally {
  # Clear secret from memory variable
  Remove-Variable SecretPlain -ErrorAction SilentlyContinue
}

try {
  $Headers = @{ Authorization = "Bearer $($Token.access_token)" }
  $Org = Invoke-RestMethod -Method Get -Uri "https://graph.microsoft.com/v1.0/organization" -Headers $Headers -ErrorAction Stop
  Write-Host "PASS: App registration verified." -ForegroundColor Green
  Write-Host ("Tenant: {0}" -f $Org.value[0].displayName)
  exit 0
}
catch {
  Write-Host "FAIL: Token OK, but Graph access failed (permissions/consent/policy)." -ForegroundColor Yellow
  exit 2
}
