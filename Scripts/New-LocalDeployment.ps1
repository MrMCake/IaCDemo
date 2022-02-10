$inputObject = @{
    Name                  = 'IaCDemo' 
    Location              = 'WestEurope' 
    TemplateParameterFile = ''
    TemplateFile          = '' 
    Verbose               = $true
    ErrorAction           = 'Stop'
}

Write-Verbose "Test Deployment" -Verbose
Test-AzDeployment @inputObject

Write-Verbose "Execute Deployment" -Verbose
New-AzDeployment @inputObject