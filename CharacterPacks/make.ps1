$ConfigFile = "config.json"
$TemplateDir = "CharacterPackTemplate"
$AssetsDir = "assets"
$TargetDir = ".."

# Reading keys from the JSON config file
$ConfigData = Get-Content $ConfigFile | ConvertFrom-Json
$ModNames = $ConfigData.PSObject.Properties.Name
foreach ($ModName in $ModNames) {
    $CallSign = $ConfigData.$ModName.call_sign
    $Units = $ConfigData.$ModName.units -join '","'

    $ModTargetDir = Join-Path $TargetDir "Character-Pack-$ModName"

    # Recreate mod directory and copy template
    Remove-Item $ModTargetDir -Recurse -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force -Path $ModTargetDir | Out-Null
    Copy-Item (Join-Path $TemplateDir "*") $ModTargetDir -Recurse

    # Step 2: Copy images and description for the mods
    $sourcePath = Join-Path $AssetsDir $ModName
    if (Test-Path $sourcePath) {
        Copy-Item -Path "$sourcePath\*" -Destination $ModTargetDir -Recurse
    } else {
        Write-Host "No assets found for $ModName, skipping asset copy."
    }

    # Step 3: Replace call sign in Utilities.lua
    $TargetFile = Join-Path $ModTargetDir "Utilities.lua"
    if (Test-Path $TargetFile) {
        $LuaCode = @"
`nfunction modSign(mode)
    if mode == 0 then
        return `"$CallSign`"
    elseif mode == 1 then
        return {
            `"$Units`"
        }
    end
end
"@

        $LuaCode = $LuaCode.Replace("`"", '"').Replace('",', '",').Replace('.trim()', '') # Correcting for Lua syntax
        Add-Content $TargetFile $LuaCode
    } else {
        Write-Host "Target file $TargetFile not found."
    }

    Write-Host "Setup done for $ModTargetDir."
}
Write-Host "Setup complete."
