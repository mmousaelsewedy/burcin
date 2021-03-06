[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)][string]$ConfigFile,
    [Parameter(Mandatory = $true)][string]$Source,
    [Parameter(Mandatory = $true)][string]$Username,
    [Parameter(Mandatory = $true)][string]$Password
)
$doc = New-Object System.Xml.XmlDocument
$filename = (Get-Item $ConfigFile).FullName
$doc.Load($filename)

$creds = $doc.DocumentElement.SelectSingleNode("packageSourceCredentials")
if ($null -eq $creds)
{
    $creds = $doc.CreateElement("packageSourceCredentials")
    $doc.DocumentElement.AppendChild($creds) | Out-Null
}

$sourceElement = $creds.SelectSingleNode($Source)
if ($null -eq $sourceElement)
{
    $sourceElement = $doc.CreateElement($Source)
    $creds.AppendChild($sourceElement) | Out-Null
}

$usernameElement = $sourceElement.SelectSingleNode("add[@key='Username']")
if ($null -eq $usernameElement)
{
    $usernameElement = $doc.CreateElement("add")
    $usernameElement.SetAttribute("key", "Username")
    $sourceElement.AppendChild($usernameElement) | Out-Null
}
$usernameElement.SetAttribute("value", $Username)

$passwordElement = $sourceElement.SelectSingleNode("add[@key='ClearTextPassword']")
if ($null -eq $passwordElement)
{
    $passwordElement = $doc.CreateElement("add")
    $passwordElement.SetAttribute("key", "ClearTextPassword")
    $sourceElement.AppendChild($passwordElement) | Out-Null
}
$passwordElement.SetAttribute("value", $Password)

$doc.Save($filename)



# - name: Set NuGet credentials
# shell: pwsh
# env:
#   NUGET_AUTH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
# run: ./tools/Set-NuGetCredentials.ps1 -ConfigFile ../nuget.config -Source github -Username USERNAME -Password $env:NUGET_AUTH_TOKEN
# # waiting for https://github.com/NuGet/Home/issues/4126
