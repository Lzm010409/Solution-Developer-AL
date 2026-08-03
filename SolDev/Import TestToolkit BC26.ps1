# Installiert das Microsoft-Test-Toolkit auf einer BC-26-Instanz.
# Angepasst aus "Import TestToolkit BC27.ps1" auf Serverinstanz und DVD-Pfad
# dieser Umgebung. Beide Werte vor dem ersten Lauf pruefen.

$si      = 'Cronus'
$version = '260'
$dvdpath = 'C:\Dynamics.365.BC.33876.DE.DVD'   # <-- an die vorhandene DVD anpassen

Import-Module "C:\Program Files\Microsoft Dynamics 365 Business Central\$version\Service\NavAdminTool.ps1" -Force | Out-Null

# Die Mock-Assembly muss neben dem Dienst liegen, sonst startet der Test Runner nicht.
Copy-Item "$dvdpath\Test Assemblies\Mock Assemblies\MockTest.dll" `
          "C:\Program Files\Microsoft Dynamics 365 Business Central\$version\Service\Add-ins" -Force

# Reihenfolge ist bindend: jede App setzt die vorherigen voraus.
$apps = @(
    @{ Name = 'Library Assert';                    Path = "$dvdpath\applications\testframework\testlibraries\assert\Microsoft_Library Assert.app" }
    @{ Name = 'Library Variable Storage';          Path = "$dvdpath\applications\testframework\testlibraries\variable storage\Microsoft_Library Variable Storage.app" }
    @{ Name = 'Any';                               Path = "$dvdpath\applications\testframework\testlibraries\any\Microsoft_Any.app" }
    @{ Name = 'Test Runner';                       Path = "$dvdpath\applications\testframework\TestRunner\Microsoft_Test Runner.app" }
    @{ Name = 'System Application Test Library';   Path = "$dvdpath\applications\System Application\Test\Microsoft_System Application Test Library.app" }
    @{ Name = 'Business Foundation Test Libraries'; Path = "$dvdpath\applications\BusinessFoundation\Test\Microsoft_Business Foundation Test Libraries.app" }
    @{ Name = 'Business Foundation Tests';         Path = "$dvdpath\applications\BusinessFoundation\Test\Microsoft_Business Foundation Tests.app" }
    @{ Name = 'Tests-TestLibraries';               Path = "$dvdpath\applications\BaseApp\Test\Microsoft_Tests-TestLibraries.app" }
)

foreach ($app in $apps) {
    if (-not (Test-Path $app.Path)) {
        Write-Warning "Nicht gefunden, uebersprungen: $($app.Path)"
        continue
    }
    Write-Host "Installiere $($app.Name) ..."
    Publish-NAVApp -ServerInstance $si -Path $app.Path -SkipVerification
    Sync-NAVApp    -ServerInstance $si -Name $app.Name -Mode ForceSync
    Install-NAVApp -ServerInstance $si -Name $app.Name
}

# Die tatsaechlich installierten Versionen ausgeben - genau diese gehoeren
# als Mindestversion in die dependencies der app.json.
Write-Host "`nInstalliert:"
Get-NAVAppInfo -ServerInstance $si |
    Where-Object { $_.Name -in $apps.Name } |
    Select-Object Name, Version, IsInstalled | Format-Table -AutoSize
