
function Add-Path {
  param(
    [string]$PathToAdd
  )

  if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "This function must be run as an administrator."
    $choice = Read-Host "Would you like to run this function as an administrator now? (Y/N)"
    if ($choice -eq "Y") {
      $encodedCommand = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes("Add-Path -PathToRemove '$PathToAdd'"))
      Start-Process powershell -Verb RunAs -ArgumentList "-EncodedCommand $encodedCommand"
    }
    return
  }


  if ([string]::IsNullOrEmpty($PathToAdd)) {
    $PathToAdd = Read-Host "Please enter the path to add"
  }

  $envPath = [Environment]::GetEnvironmentVariable('Path','Machine')
  $paths = $envPath.Split(';')

  if ($paths -notcontains $PathToAdd) {
    $newEnvPath = $envPath + ";" + $PathToAdd
    [Environment]::SetEnvironmentVariable('Path',$newEnvPath,'Machine')
    Write-Host "Path added successfully."
  } else {
    Write-Host "The path is already in the PATH environment variable."
  }
}
