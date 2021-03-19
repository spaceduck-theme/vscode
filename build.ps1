[cmdletbinding()]
param (
    [switch]$Push
)

if ($Push) {
    $Packages = Get-ChildItem (Join-Path $env:APPVEYOR_BUILD_FOLDER 'Packages') -File -Filter *.vsix

    foreach ($Package in $Packages) {
        try {
            Push-AppveyorArtifact $Package.FullName
        } catch {
            throw 'Failed to push artifact {0}.' -f $Package.Name
        }
    }
} else {
    if (-not(Test-Path .\Packages)) {
        $Null = New-Item Packages -ItemType Directory -Force
    } else {
        Get-ChildItem .\Packages -File -Filter *.vsix  | Remove-Item -Force
    }

    try {
        vsce package
    } catch {
        throw "failed to package theme $($Theme.Name)"
    }

    Get-Item *.vsix | Move-Item -Destination .\Packages
}
