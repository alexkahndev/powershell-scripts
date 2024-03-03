function Remove-Path {
  param(
    [string]$PathToRemove
  )

  if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "This function must be run as an administrator."
    $choice = Read-Host "Would you like to run this function as an administrator now? (Y/N)"
    if ($choice -eq "Y") {
      $encodedCommand = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes("Remove-Path -PathToRemove '$PathToRemove'"))
      Start-Process powershell -Verb RunAs -ArgumentList "-EncodedCommand $encodedCommand"
    }
    return
  }



  if ([string]::IsNullOrEmpty($PathToRemove)) {
    $PathToRemove = Read-Host "Please enter the path to remove"
  }

  $envPath = [Environment]::GetEnvironmentVariable('Path','Machine')
  $paths = $envPath.Split(';')

  if ($paths -contains $PathToRemove) {
    $paths = $paths | Where-Object { $_ -ne $PathToRemove }
    $newEnvPath = $paths -join ';'
    [Environment]::SetEnvironmentVariable('Path',$newEnvPath,'Machine')
    Write-Host "Path removed successfully."
  } else {
    Write-Host "The path is not in the PATH environment variable."
  }
}
