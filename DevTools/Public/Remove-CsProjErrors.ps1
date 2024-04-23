function Remove-CsProjErrors {
    param (
        [string] $Path = "."
    )
    
    $files = Get-ChildItem -Recurse -Filter "$Path\*.csproj" | ForEach-Object $_.FullName

    foreach($file in $files) 
    {
        $doc = [XML](Get-Content $file)
        $item = Select-Xml -Xml $doc -XPath "//*[local-name()='Target'][*[local-name()='Error']]"

        if($null -ne $item.Node)
        {
            $doc.Project.RemoveChild($item.Node) > $null
            $doc.Save($file)
            Write-Host "Removed errors from" $file
        }
    }
}