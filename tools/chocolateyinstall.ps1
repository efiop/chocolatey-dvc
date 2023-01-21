Update-SessionEnvironment

$version = '2.42.0'
$url = "https://pypi.io/packages/source/d/dvc/dvc-$version.tar.gz"
$checksum = 'd717df1f12c90e8deda15ca10ef7d30ab2c73c9fa3151afe19690943e54b7312'
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$tarFile = "$toolsDir\dvc-$version.tar.gz"
$projDir = "$toolsDir\dvc-$version"

Get-ChocolateyWebFile -PackageName 'dvc' -Url "$url" -FileFullPath "$tarFile" -ChecksumType sha256 -Checksum "$checksum"
Get-ChocolateyUnzip -FileFullPath "$tarFile" -Destination "$toolsDir"
Set-Location -Path "$projDir"
New-Item -Path "dvc\utils" -Name "build.py" -ItemType "file" -Value "PKG = 'choco'"
python -m pip install --upgrade pip
# NOTE: not installing pyarrow, as it doesn't have wheels for Windows Server 2012,
# see https://gist.github.com/choco-bot/d72732943836c947633625b1428a3f2c#file-install-txt-L1292
python -m pip install '.[gs,s3,azure,oss,ssh,gdrive]'
