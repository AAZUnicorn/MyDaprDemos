# This script issues and displays the correct dapr run command for running with
# local or cloud resources. To run in the clould add the -cloud switch. If the 
# script determines the infrastructure has not been deployed it will call the
# setup script first. 
[CmdletBinding()]
param (
    [Parameter(
        Position = 0,
        HelpMessage = "When provided runs demo against cloud resources"
    )]
    [switch]
    $cloud
)

# Load the sample requests file for the demo
code ./sampleRequests.http

if ($cloud.IsPresent) {
    Write-Output "Running demo with cloud resources"
    
    # If you don't find the ./azureComponents/local_secrets.json run the setup.ps1 in deploy folder
    if ($null -eq $env:VAULTNAME) {
        Write-Output "VAULTNAME environment variable not found running setup"
        Push-Location
        Set-Location -Path './deploy'
        ./setup.ps1
        Pop-Location
    }
    
    Write-Output "dapr run --app-id cloud --dapr-http-port 3500 --components-path ./azureComponents `n"
    dapr run --app-id cloud --dapr-http-port 3500 --components-path ./azureComponents
}
else {
    Write-Output "Running demo with local resources"
    Write-Output "dapr run --app-id local --dapr-http-port 3500 --components-path ./components `n"

    dapr run --app-id local --dapr-http-port 3500 --components-path ./components
}