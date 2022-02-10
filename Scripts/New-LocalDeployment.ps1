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


# ID: 0202e533-85b6-4338-960f-4544070775c3