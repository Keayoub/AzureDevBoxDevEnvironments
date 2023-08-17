
Write-Host "Installing Chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Write-Host "Chocolatey Installed"

Write-Host "Installing Packages..."
choco install vscode -y
choco install 7zip -y
choco install pwsh -y
choco install adobereader -y
choco install kubernetes-cli -y
choco install kubernetes-helm -y
choco install terraform -y
choco install docker-desktop -y
choco install git -y
Write-Host "All Packages Installed"


# Clone Application from azure
# Create-folder
New-Item -Path "C:\workingdir" -ItemType "directory" -Force
Set-Location "C:\workingdir"
git clone 'https://github.com/dockersamples/example-voting-app.git' voting-app
Write-Host "Cloning Application from Azure"
# Run application
$cwd = (Get-Location)
Set-Location $cwd/voting-app
#docker compose up

# exit script
exit 0




