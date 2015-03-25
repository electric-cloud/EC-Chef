@files = (
 ['//procedure[procedureName="DownloadCookbookFromRepository"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/DownloadCookbookFromRepository.xml'],
 ['//procedure[procedureName="InstallCookbookOnClient"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/InstallCookbookOnClient.xml'],
 ['//procedure[procedureName="UploadCookbooksToServer"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/UploadCookbooksToServer.xml'],
 ['//procedure[procedureName="AddRecipesToNodeRunList"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/AddRecipesToNodeRunList.xml'],
 ['//procedure[procedureName="RunChefClient"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/RunChefClient.xml'],
 ['//procedure[procedureName="_RegisterAndConvergeNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value','forms/RegisterAndConvergeNode.xml'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="DownloadCookbookFromRepository"]/value','drivers/DownloadCookbookFromRepositoryDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="InstallCookbookOnClient"]/value','drivers/InstallCookbookOnClientDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="UploadCookbooksToServer"]/value','drivers/UploadCookbooksToServerDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="AddRecipesToNodeRunList"]/value','drivers/AddRecipesToNodeRunListDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="RunChefClient"]/value','drivers/RunChefClientDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="_RegisterAndConvergeNode"]/value','drivers/RegisterAndConvergeNode.pl'],
 ['//property[propertyName="ec_setup"]/value', 'ec_setup.pl'],
 ['//property[propertyName="postp_matchers"]/value', 'postp_matchers.pl'],

 ['//procedure[procedureName="CreateConfiguration"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/createConfigForm.xml'],
 ['//property[propertyName="forms"]/propertySheet/property[propertyName="CreateConfigForm"]/value',              'forms/createConfigForm.xml'],
 ['//property[propertyName="forms"]/propertySheet/property[propertyName="EditConfigForm"]/value',                'forms/editConfigForm.xml'],

 ['//procedure[procedureName="CreateConfiguration"]/step[stepName="CreateConfiguration"]/command',                 'config/createcfg.pl'],
 ['//procedure[procedureName="CreateConfiguration"]/step[stepName="CreateAndAttachCredential"]/command',           'config/createAndAttachCredential.pl'],
 ['//procedure[procedureName="DeleteConfiguration"]/step[stepName="DeleteConfiguration"]/command',                 'config/deletecfg.pl']
);


