# The following code was sourced from https://github.com/puppetlabs/Puppet.Dsc/blob/main/extras/profile.ps1!

Function New-LocalGemfile {
    Param (
        [string]$Path
    )
    $Gems = @'
  gem 'fuubar'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
'@
    if ([string]::IsNullOrEmpty($Path)) {
        $Path = Join-Path -Path (Get-Location) -ChildPath 'gemfile.local'
    }
    [IO.File]::WriteAllLines($Path, $Gems)
}

# The following line should be updated so that the PDK_PUPPET_VERSION value matches the latest Puppet version bundled with PDK
Set-Item -Path Env:\PDK_PUPPET_VERSION -Value '7.28.0'
Set-Item -Path Env:\PATH -Value "$ENV:PATH;C:\Program Files\Git\cmd"
Import-Module posh-git
Set-Location -Path $env:userprofile\code
