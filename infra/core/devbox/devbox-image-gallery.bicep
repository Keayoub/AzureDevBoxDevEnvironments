param location string = resourceGroup().location
param imageGalleryName string = ''
param imageTemplateName string = ''
param imageDefinitionName string
param imageDefinitionProperties object
param userdIdentity string = ''

// use https://learn.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az-vm-image-list
// to find the publisher, offer, sku, version
var imageSource = {
  type: 'PlatformImage'
  publisher: 'MicrosoftWindowsDesktop'
  offer: 'windows-11'
  sku: 'win11-21h2-avd'
  version: 'latest'
  baseOs: 'win11multi'
}

// var imageSourceWSL = {
//   type: 'PlatformImage'
//   publisher: 'Canonical'
//   offer: '0001-com-ubuntu-server-jammy'
//   sku: '22_04-lts'
//   version: 'latest'
// }

module devboxImageGallery '../compute/galleries.bicep' = {
  name: 'imageGallery'
  params: {
    name: imageGalleryName
    location: location
  }
}

module imageGalleryDefinition '../compute/galleries-images.bicep' = {
  name: 'imageGalleryDefinition'
  params: {
    name: imageDefinitionName
    location: location
    galleryName: devboxImageGallery.outputs.name
    osType: 'Windows'
    imageDefinitionProperties: imageDefinitionProperties
  }
}

module CustomImageDef '../virtual-machine-images/virtualmachineimages.bicep' = {
  name: 'CustomImageDef'
  params: {
    imageTemplateName: imageTemplateName
    location: location
    userImageBuilderName: userdIdentity
    // see the type of object (for the definition), here
    // https://learn.microsoft.com/en-us/azure/templates/microsoft.virtualmachineimages/imagetemplates?pivots=deployment-language-bicep#imagetemplatecustomizer    
    imageSource: imageSource
    sigImageDefinitionId: imageGalleryDefinition.outputs.id
    sigImageVersion: imageDefinitionProperties.version
    customizationSteps: [
      {
        type: 'PowerShell'
        name: 'customscript'
        scriptUri: 'https://raw.githubusercontent.com/Keayoub/AzureDevBoxDevEnvironments/main/scripts/imageBuilderScripts/installDevToolsImage.ps1'
        runElevated: true
        runAsSystem: true
      }
      {
        type: 'WindowsRestart'
      }
      {
        type: 'PowerShell'
        name: 'customscript'
        scriptUri: 'https://raw.githubusercontent.com/Keayoub/AzureDevBoxDevEnvironments/main/scripts/imageBuilderScripts/Run-app.ps1'
        runElevated: true
        runAsSystem: true
      }
    ]
  }
}


