Update-SessionEnvironment

Set-PSDebug -Trace 1
$ErrorActionPreference = "Stop"

$version = '2.56.0'
$url = "https://pypi.io/packages/source/d/dvc/dvc-$version.tar.gz"
$checksum = '927dcde2ae658b434ba428a0b93247a014f23ef383c23a07a9040ad22c5bbcf7'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$tarFile = "$toolsDir\dvc-$version.tar"
$targzFile = "$tarFile.gz"
$projDir = "$toolsDir\dvc-$version"

Get-ChocolateyWebFile -PackageName 'dvc' -Url "$url" -FileFullPath "$targzFile" -ChecksumType sha256 -Checksum "$checksum"
Get-ChocolateyUnzip -FileFullPath "$targzFile" -Destination "$toolsDir"
if (Test-Path "$tarFile") {
  # ChocolateyUnzip can't handle tar.gz in one pass right now,
  # see https://github.com/chocolatey/choco/pull/1026 for more details.
  # Inspired by https://github.com/chocolatey-community/chocolatey-packages/blob/d00d111cdc6e638146359073417f9c1d57f8da84/automatic/kubernetes-cli/tools/chocolateyInstall.ps1#L15
  Get-ChocolateyUnzip -FileFullPath "$tarFile" -Destination "$toolsDir"
  Remove-Item "$tarFile"
}

Set-Location -Path "$projDir"
New-Item -Path "dvc\utils" -Name "build.py" -ItemType "file" -Value "PKG = 'choco'" -Force

python -m pip install --upgrade pip
# NOTE: not installing pyarrow, as it doesn't have wheels for Windows Server 2012,
# see https://gist.github.com/choco-bot/d72732943836c947633625b1428a3f2c#file-install-txt-L1292
python -m pip install ".[gs,s3,azure,oss,ssh,gdrive]"
