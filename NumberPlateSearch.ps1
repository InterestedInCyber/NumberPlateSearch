<#
    ===========================================================================
    .NOTES
    ===========================================================================
    Created on:   	28/03/2023 21:00
    Created by:   	Bobby Cox (InterestedInCyber)
    Organization: 	N/A
    Filename:     	NumberPlateSearch.ps1
    ===========================================================================
    .DESCRIPTION
    ===========================================================================
    Purpose: UK Number Plate Search (Government DVLA Vehicle Search API)
    ===========================================================================
#>

Clear-Host
$ErrorActionPreference = 'SilentlyContinue'

function AskForLicensePlate {

    Write-Host "(" -NoNewline; Write-Host "nps" -ForegroundColor Red -NoNewline; Write-Host ") " -NoNewline; Write-Host "> " -NoNewline
    $PlateNumber = $Host.UI.ReadLine()

    while ($PlateNumber -eq "") {
        AskForLicensePlate
    }

    while ($PlateNumber.Length -eq 7) {

        $registrationNumber = '{"registrationNumber": "' + $PlateNumber + '"}'
        $response = Invoke-WebRequest -Headers @{"x-api-key" = "Qb0lw93DmaFVozdu2fP24fxrRoP31b56CikLMOmj" } -Method POST -Body $registrationNumber -Uri https://driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles
        
        if ($response.StatusCode -eq 200) {
            $CarDetails = Invoke-RestMethod -Headers @{"x-api-key" = "Qb0lw93DmaFVozdu2fP24fxrRoP31b56CikLMOmj" } -Method POST -Body $registrationNumber -Uri https://driver-vehicle-licensing.api.gov.uk/vehicle-enquiry/v1/vehicles
            
            Write-Host ""
            Write-Host "Vehicle Found       : " -NoNewline; Write-Host ($CarDetails.registrationNumber) -ForegroundColor Yellow
            Write-Host ""

            if ($CarDetails.taxStatus -eq "Taxed") {
                Write-Host "Tax Status          : " -NoNewline; Write-Host ($CarDetails.taxStatus) -ForegroundColor Green
            }
            if ($CarDetails.taxStatus -eq "Untaxed") {
                Write-Host "Tax Status          : " -NoNewline; Write-Host ($CarDetails.taxStatus) -ForegroundColor Red
            }
            
            Write-Host "Tax Due             : " -NoNewline; Write-Host ($CarDetails.taxDueDate)
            Write-Host "MOT Status          : " -NoNewline; Write-Host ($CarDetails.motStatus)
            Write-Host "Vehicle Make        : " -NoNewline; Write-Host ($CarDetails.make)
            Write-Host "Manufacture Year    : " -NoNewline; Write-Host ($CarDetails.yearOfManufacture)
            Write-Host "Engine Capacity     : " -NoNewline; Write-Host ($CarDetails.engineCapacity)
            Write-Host "CO2 Emissions       : " -NoNewline; Write-Host ($CarDetails.co2Emissions)
            Write-Host "Fuel Type           : " -NoNewline; Write-Host ($CarDetails.fuelType)
            Write-Host "Marked for Export   : " -NoNewline; Write-Host ($CarDetails.markedForExport)
            Write-Host "Vehicle Colour      : " -NoNewline; Write-Host ($CarDetails.colour)
            Write-Host "Approval Type       : " -NoNewline; Write-Host ($CarDetails.typeApproval)
            Write-Host "Last V5C Issued     : " -NoNewline; Write-Host ($CarDetails.dateOfLastV5CIssued)
            Write-Host "MOT Expire Date     : " -NoNewline; Write-Host ($CarDetails.motExpiryDate)
            Write-Host "Wheel Plan          : " -NoNewline; Write-Host ($CarDetails.wheelplan)
            Write-Host "First Registration  : " -NoNewline; Write-Host ($CarDetails.monthOfFirstRegistration)
            Write-Host ""
            AskForLicensePlate
        }

        else {
            Write-Host "[" -NoNewline; Write-Host "!" -ForegroundColor Red -NoNewline; Write-Host "] " -NoNewline; Write-Host "Vehicle " -NoNewline; Write-Host $PlateNumber -ForegroundColor Yellow -NoNewline; Write-Host " Not Found."
            AskForLicensePlate
        }
        AskForLicensePlate
    }
    
    if ($PlateNumber -eq "q") {
        Exit(1)
    }

    if ($PlateNumber -eq "clear") {
        Clear-Host
        AskForLicensePlate
    }

    if (!($PlateNumber.Length -eq 7)) {
        Write-Host "[" -NoNewline; Write-Host "!" -ForegroundColor Red -NoNewline; Write-Host "] " -NoNewline; Write-Host "Please Enter a Valid UK License Plate."
        AskForLicensePlate
    }
}
AskForLicensePlate