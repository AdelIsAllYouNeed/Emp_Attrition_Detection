# Get the name of the parent folder
$FolderName = Split-Path -Leaf (Get-Location)

# Replace spaces with underscores in the environment name to avoid issues
$FolderName = $FolderName -replace ' ', '_'

# Default Python version
$PythonVersion = "3.8"

# Check if an argument was provided for the Python version
if ($args.Count -gt 0) {
    $PythonVersion = $args[0]
}

# Log file location
$LogFile = "$PWD\setup_env_log.txt"

# Start Logging
Write-Output "=============================================" | Out-File -FilePath $LogFile -Encoding utf8
Write-Output "Setting up Conda environment for $FolderName" | Out-File -FilePath $LogFile -Append
Write-Output "Python Version: $PythonVersion" | Out-File -FilePath $LogFile -Append
Write-Output "=============================================" | Out-File -FilePath $LogFile -Append

# Check if Conda is installed
Write-Host "[DEBUG] Checking Conda version..."
conda --version | Out-File -FilePath $LogFile -Append
if ($LastExitCode -ne 0) {
    Write-Output "ERROR: Conda is not installed or not added to the system PATH." | Out-File -FilePath $LogFile -Append
    Write-Output "ERROR: Please install Conda first or add it to the PATH." | Out-File -FilePath $LogFile -Append
    exit 1
}

# Create the Conda environment
Write-Host "[DEBUG] Executing: conda create --name $FolderName python=$PythonVersion -y"
Write-Output "Executing Conda create command..." | Out-File -FilePath $LogFile -Append
conda create --name $FolderName python=$PythonVersion -y | Out-File -FilePath $LogFile -Append
if ($LastExitCode -ne 0) {
    Write-Output "ERROR: Failed to create the Conda environment." | Out-File -FilePath $LogFile -Append
    exit 1
}

# Activate the environment
Write-Host "[DEBUG] Executing: conda activate $FolderName"
Write-Output "Activating the environment..." | Out-File -FilePath $LogFile -Append
conda activate $FolderName | Out-File -FilePath $LogFile -Append
if ($LastExitCode -ne 0) {
    Write-Output "ERROR: Failed to activate the Conda environment." | Out-File -FilePath $LogFile -Append
    exit 1
}

# Check if requirements.txt exists
Write-Host "[DEBUG] Checking for requirements.txt..."
if (Test-Path -Path "requirements.txt") {
    Write-Output "Installing packages from requirements.txt..." | Out-File -FilePath $LogFile -Append
    pip install -r requirements.txt | Out-File -FilePath $LogFile -Append
    if ($LastExitCode -ne 0) {
        Write-Output "ERROR: Failed to install packages from requirements.txt." | Out-File -FilePath $LogFile -Append
        exit 1
    }
} else {
    Write-Output "WARNING: requirements.txt not found in the directory." | Out-File -FilePath $LogFile -Append
}

# Confirm environment setup
Write-Output "=============================================" | Out-File -FilePath $LogFile -Append
Write-Output "Environment $FolderName with Python $PythonVersion is ready and activated!" | Out-File -FilePath $LogFile -Append
Write-Output "=============================================" | Out-File -FilePath $LogFile -Append

# Final message to the console
Write-Host "Setup complete!"
