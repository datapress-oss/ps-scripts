# This is a basic workflow to help you get started with Actions

name: CI

# Controls when the action will run. Triggers the workflow on push or pull request
# events but only for the master branch
on:
  push:
    branches: [ master ]
  pull_request:
    branches: [ master ]

# A workflow run is made up of one or more jobs that can run sequentially or in parallel
jobs:
  #1st job
  publishToPWGallery:
    # The type of runner that the job will run on
    runs-on: windows-latest

    # Steps represent a sequence of tasks that will be executed as part of the job
    steps:
    # Checks-out your repository under $GITHUB_WORKSPACE, so your job can access it
    - uses: actions/checkout@v2

    # Runs a command using the runners shell
    - name: Publish every package in the repository into powershell gallery
      run: |
        Import-Module .\Datapress.Publish-AllModules\Datapress.Publish-AllModules.psd1
        #powershell gallery is not used yet
        #Publish-AllModules -apiKey ${{ secrets.PS_GALLERY }} -repository PSGallery
      shell: pwsh

  #2nd job
  publishToGithub:
    runs-on: windows-latest
    steps:
    - uses: actions/checkout@v2
    - name: Publish every package in the repository into github packages
      run: |
        Import-Module .\Datapress.Export-Nuspec\Datapress.Export-Nuspec.psd1
        Get-Command Export-Nuspec
        $paths = Get-ChildItem -Directory
        nuget source Add -Name "githubSrc" -Source "https://nuget.pkg.github.com/datapress-oss/index.json" -UserName "datapress-oss" -Password ${{ secrets.GITHUB_TOKEN }}
        foreach ($path in $paths.Name) {
          if (Test-Path $path\*.psd1) {
            try {
              Export-Nuspec -ManifestPath $(Resolve-Path $path\*.psd1) -GitRepositoryUrl https://github.com/datapress-oss/ps-scripts.git
              nuget pack $(Resolve-Path $path\*.nuspec) -OutputDirectory $(Resolve-Path $path\)
              nuget push $(Resolve-Path $path\*.nupkg) -ApiKey ${{ secrets.GITHUB_TOKEN }} -Source "githubSrc" -SkipDuplicate
            }
            catch {
              Write-Warning $Error[0]
            }
          }
        }
      shell: pwsh
      