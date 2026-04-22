# Build rapier-rs for Windows and deploy to paclet
$env:WSTP_COMPILER_ADDITIONS_DIRECTORY = "C:\Program Files\Wolfram Research\Wolfram\15.0\SystemFiles\Links\WSTP\DeveloperKit\Windows-x86-64\CompilerAdditions"

Push-Location "$PSScriptRoot\..\rapier-rs"
cargo build --release 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "cargo build failed"
    Pop-Location
    exit 1
}
Pop-Location

$dest = "$PSScriptRoot\..\PhysicsModelLink\LibraryResources\Windows-x86-64"
New-Item -ItemType Directory -Force -Path $dest | Out-Null
Copy-Item "$PSScriptRoot\..\rapier-rs\target\release\rapier_rs.dll" "$dest\rapier_rs.dll" -Force
Write-Host "Deployed rapier_rs.dll to $dest"
