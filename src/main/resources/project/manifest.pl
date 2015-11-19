#
#  Copyright 2015 Electric Cloud, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#

@files = (
 ['//procedure[procedureName="DownloadCookbookFromRepository"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/DownloadCookbookFromRepository.xml'],
 ['//procedure[procedureName="InstallCookbookOnClient"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/InstallCookbookOnClient.xml'],
 ['//procedure[procedureName="UploadCookbooksToServer"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/UploadCookbooksToServer.xml'],
 ['//procedure[procedureName="CreateNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/CreateNode.xml'],
 ['//procedure[procedureName="EditNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/EditNode.xml'],
 ['//procedure[procedureName="DeleteSingleNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/DeleteSingleNode.xml'],
 ['//procedure[procedureName="ListNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/ListNode.xml'],
 ['//procedure[procedureName="ShowNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/ShowNode.xml'],
 ['//procedure[procedureName="AddRecipesToNodeRunList"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/AddRecipesToNodeRunList.xml'],
['//procedure[procedureName="RemoveRecipesFromNodeRunList"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/RemoveRecipesFromNodeRunList.xml'],
 ['//procedure[procedureName="RunChefClient"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/RunChefClient.xml'],
 ['//procedure[procedureName="_RegisterAndConvergeNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value','forms/RegisterAndConvergeNode.xml'],
 ['//procedure[procedureName="_DeleteNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value','forms/DeleteNode.xml'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="DownloadCookbookFromRepository"]/value','drivers/DownloadCookbookFromRepositoryDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="InstallCookbookOnClient"]/value','drivers/InstallCookbookOnClientDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="UploadCookbooksToServer"]/value','drivers/UploadCookbooksToServerDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="CreateNode"]/value','drivers/CreateNodeDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="EditNode"]/value','drivers/EditNodeDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="DeleteSingleNode"]/value','drivers/DeleteiSingleNodeDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="ListNode"]/value','drivers/ListNodeDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="ShowNode"]/value','drivers/ShowNodeDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="AddRecipesToNodeRunList"]/value','drivers/AddRecipesToNodeRunListDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="RemoveRecipesFromNodeRunList"]/value','drivers/RemoveRecipesFromNodeRunListDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="RunChefClient"]/value','drivers/RunChefClientDriver.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="_RegisterAndConvergeNode"]/value','drivers/RegisterAndConvergeNode.pl'],
 ['//property[propertyName="scripts"]/propertySheet/property[propertyName="_DeleteNode"]/value','drivers/DeleteNode.pl'],
 ['//property[propertyName="ec_setup"]/value', 'ec_setup.pl'],
 ['//property[propertyName="postp_matchers"]/value', 'postp_matchers.pl'],

 ['//procedure[procedureName="CreateConfiguration"]/propertySheet/property[propertyName="ec_parameterForm"]/value', 'forms/createConfigForm.xml'],
 ['//property[propertyName="forms"]/propertySheet/property[propertyName="CreateConfigForm"]/value',              'forms/createConfigForm.xml'],
 ['//property[propertyName="forms"]/propertySheet/property[propertyName="EditConfigForm"]/value',                'forms/editConfigForm.xml'],

 ['//procedure[procedureName="CreateConfiguration"]/step[stepName="CreateConfiguration"]/command',                 'config/createcfg.pl'],
 ['//procedure[procedureName="CreateConfiguration"]/step[stepName="CreateAndAttachCredential"]/command',           'config/createAndAttachCredential.pl'],
 ['//procedure[procedureName="DeleteConfiguration"]/step[stepName="DeleteConfiguration"]/command',                 'config/deletecfg.pl']
);


