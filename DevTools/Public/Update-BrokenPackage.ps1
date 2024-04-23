function Update-BrokenPackage
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $Key,
        [Parameter(Mandatory = $true)]
        [string] $Version,
        [string] $Path = "."
    )

    $directories = Get-ChildItem -Recurse -Filter "$Path\*.csproj" | ForEach-Object $_.Directory

    foreach($directory in $directories) 
    {
        $packagesFile = Get-ChildItem -Path $directory -Filter "*packages.config";
        $csprojFile = Get-ChildItem -Path $directory -Filter "*.csproj";

        $oldVersion = $null

        if($packagesFile.Exists)
        {
            $doc = [XML](Get-Content $packagesFile.FullName)
            $item = Select-Xml -Xml $doc -XPath "//package[@id='$Key']/@version"

            if($null -ne $item.Node)
            {
                $oldVersion = $item.Node.Value
                $item.Node.Value = $Version
                $doc.Save($packagesFile.FullName)
                Write-Host "Upgraded package ${Key}: $oldVersion -> $Version"
            }
        }

        if($csprojFile.Exists -and $null -ne $oldVersion)
        {
            $doc = [XML](Get-Content $csprojFile.FullName)

            # Remove <import ... />

            $item = Select-Xml -Xml $doc -XPath "//*[local-name()='Import'][starts-with(@Project, '..\packages\${Key}.${oldVersion}')]"

            if($null -ne $item.Node)
            {
                $item.Node.ParentNode.RemoveChild($item.Node) > $null
                $doc.Save($csprojFile.FullName)
                Write-Host "Removed Import $Key.$oldVersion"
            }

            # Remove <Reference... />

            $item = Select-Xml -Xml $doc -XPath "//*[local-name()='Reference'][*[local-name()='HintPath' and starts-with(text(), '..\packages\${Key}.${oldVersion}')]]"

            if($null -ne $item.Node)
            {
                $item.Node.ParentNode.RemoveChild($item.Node) > $null
                $doc.Save($csprojFile.FullName)
                Write-Host "Removed Reference $Key.$oldVersion"
            }
        }
    }
}
