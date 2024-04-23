function Remove-BinObj
{
    Get-ChildItem bin,obj -r | Remove-Item -r
}