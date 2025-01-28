```
az login --tenant 899419d1-88f6-4690-bd9d-d93dd6df2317

az account set -s 'Azure Sponsorship'
```

RGs:
bicep-pres-iac
bicep-pres-iac-repo
```
az group create --resource-group bicep-pres-iac --location canadacentral --tags owner=stephane.lap@outlook.com department=mvp costCenter=mvp environment=dev

az group create --resource-group bicep-pres-iac-repo --location canadacentral --tags owner=stephane.lap@outlook.com department=mvp costCenter=mvp environment=dev
```

// Cleaning up
```
az deployment group create --resource-group bicep-pres-iac --template-file ./empty.bicep --mode complete  --verbose
````

## DEMO 1
```
az deployment group create --resource-group bicep-pres-iac --template-file ./1-simple/main.bicep --verbose
```
### Explain main.bicep

```
az deployment group create --resource-group bicep-pres-iac --template-file ./1-simple/main-modules.bicep --verbose
```
### Explain main-modules.bicep

## DEMO 2
### Explain loops.bicep
```
az deployment group create --resource-group bicep-pres-iac --template-file ./2-intermediate/loops.bicep --verbose
```
### Explain loops-dictionary.bicep
```
az deployment group create --resource-group bicep-pres-iac --template-file ./2-intermediate/loops-dictionary.bicep --verbose
```
### Explain interesting-functions.bicep

#### on RG level
```
az deployment group create --resource-group bicep-pres-iac --template-file ./2-intermediate/interesting-functions.bicep --verbose
```
#### on MG level
```
az deployment mg create --management-group-id moamg --location canadacentral --template-file ./2-intermediate/interesting-functions.bicep --verbose
```
#### show currently signed in user info
```
az ad signed-in-user show
```

##DEMO 3
```
// private-repo-acr

az deployment group create --resource-group bicep-pres-iac-repo --template-file ./3-private-repo-acr/main.bicep --verbose

// module publish

az bicep publish --file ./_modules/appservices.bicep --target "br:acr34nvbyxcpgbta.azurecr.io/azure-coe/appservices:1.0.0"
```

### Explain cache location and usage - module cache path
```
// Windows
dir $env:USERPROFILE/.bicep/br
remove-item -Path $env:USERPROFILE/.bicep/br

// Mac
dir $env:HOME/.bicep/br
remove-item -Path $env:HOME/.bicep/br

```

## DEMO 4

#### show extension mechanism that leverage custom registry concept
```
az deployment group create --resource-group bicep-pres-iac --template-file ./4-extensions/main.bicep --verbose
```


##DEMO 5

### Explain you can execute script in Azure, during your deployment to do virtually anything non possible in templates

```
az deployment group create --resource-group bicep-pres-iac --template-file .\5-deployment_scripts\main.bicep --verbose
```