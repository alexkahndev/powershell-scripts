function Sexy {
  Write-Host "Formatting all PowerShell scripts in the current directory with PowerShell Beautifier."

  # Get all the PowerShell script files in the current directory
  $files = Get-ChildItem -Path .\*.ps1

  foreach ($file in $files) {
    # Get the current time before formatting the file
    $startTime = Get-Date

    # Format the file with PowerShell Beautifier
    Edit-DTWBeautifyScript -SourcePath $file.FullName

    # Get the current time after formatting the file
    $endTime = Get-Date

    # Calculate how long it took to format the file
    $duration = $endTime - $startTime

    # Log out the file that was changed and how long it took
    Write-Host "Formatted $($file.FullName) in $($duration.TotalSeconds) seconds."
  }

  Write-Host "All PowerShell scripts in the current directory have been formatted."
}
