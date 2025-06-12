function Add-AppComponent
{
    param (
        [Parameter(Mandatory = $true)]
        [string] $Name,
        [Parameter(Mandatory = $true)]
        [string] $ResourceKey,
        [switch]
        [bool] $SkipModel = $false
    )

    # Add Folder
    New-Item -Path $Name -ItemType Directory

    # Create tag
    $tag = $ResourceKey -replace "\.", "-"

    # Add Files
    foreach($templateFile in Get-ChildItem -Path "$PSScriptRoot/Templates/AppComponent")
    {
        if($SkipModel -eq $true -and $templateFile.Name -eq "AppComponentModel.js") 
        {
            continue
        }

        $contents = Get-Content $templateFile.FullName

        $contents = $contents -replace "<# Name #>", $Name
        $contents = $contents -replace "<# Tag #>", $tag
        $contents = $contents -replace "<# ResourceKey #>", $ResourceKey

        if($SkipModel)
        {
            $contents = $contents | Where-Object { -not $_.Contains('>>> Model') }
            $contents = $contents -replace "<# Model #>", ""
        }
        else
        {
            $contents = $contents -replace ">>> Model", "`"./$($Name)Model.js`","
            $contents = $contents -replace "<# Model #>", " $($Name)Model,"
        }

        $fileName = $templateFile.Name -replace 'AppComponent', $Name
        New-Item -Path "$Name/$fileName" -ItemType File
        Set-Content -Path "$Name/$fileName" -Value $contents
    }
}