function Reset-Path {
  param(
    [string]$username,
    [switch]$H,
    [switch]$Hard
  )

  if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "This function must be run as an administrator."
    $choice = Read-Host "Would you like to run this function as an administrator now? (Y/N)"
    if ($choice -eq "Y") {
      $encodedCommand = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes((Get-Command Reset-Path).Definition))
      Start-Process powershell -Verb RunAs -ArgumentList "-EncodedCommand $encodedCommand"
    }
    return
  }

  $folderPath = Read-Host -Prompt "Enter the folder path where the PATH.md will go (or press Enter to use the C drive)"

  if ([string]::IsNullOrEmpty($folderPath)) {
    $folderPath = "C:\\"
  }

  $markdownFilePath = Join-Path -Path $folderPath -ChildPath "Reset-Path-Log.md"

  $dateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

  $oldPath = [Environment]::GetEnvironmentVariable('Path','Machine')

  if (!(Test-Path -Path $markdownFilePath)) {
    $tableHeaders = "| DateTime | Old PATH | New PATH |`n| --- | --- | --- |"
    Set-Content -Path $markdownFilePath -Value $tableHeaders
  }

  $paths = @(
    "C:\\Windows\\System32\\Wbem",
    "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\"
  )

  if (!$H -and !$Hard) {
    if ([string]::IsNullOrEmpty($username)) {
      $username = Read-Host -Prompt "Username is required for full install (or press Enter to skip and use the default PATH)"
    }
    if (![string]::IsNullOrEmpty($username)) {
      $paths += "C:\\Users\\$username\\scripts",
      "C:\\Program Files\\Git\\bin",
      "C:\\Program Files\\Git\\cmd",
      "C:\\Users\\$username\\AppData\\Local\\Programs\\Microsoft VS Code\\bin",
      "C:\\Users\\$username\\.bun\\bin"
    }
  }

  $newPath = $paths -join ';'

  [Environment]::SetEnvironmentVariable('Path',$newPath,'Machine')
  Write-Host "PATH reset successfully."

  $tableRow = "| $dateTime | $oldPath | $newPath |"
  Add-Content -Path $markdownFilePath -Value $tableRow

  Write-Host "The old and new PATH have been saved to $markdownFilePath."
}
