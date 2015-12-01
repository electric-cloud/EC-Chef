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
    [
'//procedure[procedureName="DownloadCookbookFromRepository"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/DownloadCookbookFromRepository.xml'
    ],
    [
'//procedure[procedureName="InstallCookbookOnClient"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/InstallCookbookOnClient.xml'
    ],
    [
'//procedure[procedureName="UploadCookbooksToServer"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/UploadCookbooksToServer.xml'
    ],
    [
'//procedure[procedureName="CreateNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/CreateNode.xml'
    ],
    [
'//procedure[procedureName="EditNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/EditNode.xml'
    ],
    [
'//procedure[procedureName="DeleteSingleNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/DeleteSingleNode.xml'
    ],
    [
'//procedure[procedureName="ListNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/ListNode.xml'
    ],
    [
'//procedure[procedureName="ShowNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/ShowNode.xml'
    ],
    [
'//procedure[procedureName="AddRecipesToNodeRunList"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/AddRecipesToNodeRunList.xml'
    ],
    [
'//procedure[procedureName="RemoveRecipesFromNodeRunList"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/RemoveRecipesFromNodeRunList.xml'
    ],
    [
'//procedure[procedureName="RunChefClient"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/RunChefClient.xml'
    ],
    [
'//procedure[procedureName="_RegisterAndConvergeNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/RegisterAndConvergeNode.xml'
    ],
    [
'//procedure[procedureName="_DeleteNode"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/DeleteNode.xml'
    ],
    [
'//procedure[procedureName="CreateDataBag"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/CreateDataBag.xml'
    ],
    [
'//procedure[procedureName="EditDataBag"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/EditDataBag.xml'
    ],
    [
'//procedure[procedureName="DeleteDataBag"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/DeleteDataBag.xml'
    ],
    [
'//procedure[procedureName="ListDataBag"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/ListDataBag.xml'
    ],
    [
'//procedure[procedureName="ShowDataBag"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/ShowDataBag.xml'
    ],
    [
'//procedure[procedureName="Bootstrap"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/Bootstrap.xml'
    ],

    [
'//procedure[procedureName="CreateRole"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/CreateRole.xml'
    ],

    [
'//procedure[procedureName="EditRole"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/EditRole.xml'
    ],

    [
'//procedure[procedureName="DeleteRole"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/DeleteRole.xml'
    ],

    [
'//procedure[procedureName="ListRole"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/ListRole.xml'
    ],

    [
'//procedure[procedureName="ShowRole"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/ShowRole.xml'
    ],

    [
'//procedure[procedureName="CreateClient"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/CreateClient.xml'
    ],
    [
'//procedure[procedureName="DeleteClient"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/DeleteClient.xml'
    ],

    [
'//procedure[procedureName="ListClient"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/ListClient.xml'
    ],

    [
'//procedure[procedureName="ShowClient"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/ShowClient.xml'
    ],

    [
'//procedure[procedureName="CreateClientKey"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/CreateClientKey.xml'
    ],
    [
'//procedure[procedureName="DeleteClientKey"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/DeleteClientKey.xml'
    ],
    [
'//procedure[procedureName="EditClientKey"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/EditClientKey.xml'
    ],
    [
'//procedure[procedureName="ListClientKey"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/ListClientKey.xml'
    ],
    [
'//procedure[procedureName="ShowClientKey"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/ShowClientKey.xml'
    ],
    [
'//procedure[procedureName="CreateCookbook"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/CreateCookbook.xml'
    ],
    [
'//procedure[procedureName="DeleteCookbook"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/DeleteCookbook.xml'
    ],
    [
'//procedure[procedureName="ListCookbook"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/ListCookbook.xml'
    ],
    [
'//procedure[procedureName="ShowCookbook"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/ShowCookbook.xml'
    ],
    [
'//procedure[procedureName="CookbookLinting"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/CookbookLinting.xml'
    ],
    [
'//procedure[procedureName="KnifeSearch"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/KnifeSearch.xml'
    ],
    [
'//procedure[procedureName="BerksCookbook"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/BerksCookbook.xml'
    ],
    [
'//procedure[procedureName="BerksInit"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/BerksInit.xml'
    ],
    [
'//procedure[procedureName="BerksInstall"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/BerksInstall.xml'
    ],
    [
'//procedure[procedureName="BerksUpload"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/BerksUpload.xml'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="DownloadCookbookFromRepository"]/value',
        'drivers/DownloadCookbookFromRepositoryDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="InstallCookbookOnClient"]/value',
        'drivers/InstallCookbookOnClientDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="UploadCookbooksToServer"]/value',
        'drivers/UploadCookbooksToServerDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="CreateNode"]/value',
        'drivers/CreateNodeDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="EditNode"]/value',
        'drivers/EditNodeDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="DeleteSingleNode"]/value',
        'drivers/DeleteiSingleNodeDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="ListNode"]/value',
        'drivers/ListNodeDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="ShowNode"]/value',
        'drivers/ShowNodeDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="AddRecipesToNodeRunList"]/value',
        'drivers/AddRecipesToNodeRunListDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="RemoveRecipesFromNodeRunList"]/value',
        'drivers/RemoveRecipesFromNodeRunListDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="RunChefClient"]/value',
        'drivers/RunChefClientDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="_RegisterAndConvergeNode"]/value',
        'drivers/RegisterAndConvergeNode.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="_DeleteNode"]/value',
        'drivers/DeleteNode.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="CreateDataBag"]/value',
        'drivers/CreateDataBagDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="EditDataBag"]/value',
        'drivers/EditDataBagDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="DeleteDataBag"]/value',
        'drivers/DeleteDataBagDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="ListDataBag"]/value',
        'drivers/ListDataBagDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="ShowDataBag"]/value',
        'drivers/ShowDataBagDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="Bootstrap"]/value',
        'drivers/BootstrapDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="CreateRole"]/value',
        'drivers/CreateRoleDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="EditRole"]/value',
        'drivers/EditRole.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="DeleteRole"]/value',
        'drivers/DeleteRoleDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="ListRole"]/value',
        'drivers/ListRoleDriver.pl'
    ],
    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="ShowRole"]/value',
        'drivers/ShowRoleDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="CreateClient"]/value',
        'drivers/CreateClientDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="DeleteClient"]/value',
        'drivers/DeleteClientDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="ListClient"]/value',
        'drivers/ListClientDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="ShowClient"]/value',
        'drivers/ShowClientDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="CreateClientKey"]/value',
        'drivers/CreateClientKeyDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="DeleteClientKey"]/value',
        'drivers/DeleteClientKeyDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="EditClientKey"]/value',
        'drivers/EditClientKeyDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="ShowClientKey"]/value',
        'drivers/ShowClientKeyDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="ListClientKey"]/value',
        'drivers/ListClientKeyDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="CreateCookbook"]/value',
        'drivers/CreateCookbookDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="DeleteCookbook"]/value',
        'drivers/DeleteCookbookDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="ListCookbook"]/value',
        'drivers/ListCookbookDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="ShowCookbook"]/value',
        'drivers/ShowCookbookDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="CookbookLinting"]/value',
        'drivers/CookbookLintingDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="KnifeSearch"]/value',
        'drivers/KnifeSearchDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="BerksCookbook"]/value',
        'drivers/BerksCookbookDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="BerksInit"]/value',
        'drivers/BerksInitDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="BerksInstall"]/value',
        'drivers/BerksInstallDriver.pl'
    ],

    [
'//property[propertyName="scripts"]/propertySheet/property[propertyName="BerksUpload"]/value',
        'drivers/BerksUploadDriver.pl'
    ],

    [ '//property[propertyName="ec_setup"]/value',       'ec_setup.pl' ],
    [ '//property[propertyName="postp_matchers"]/value', 'postp_matchers.pl' ],

    [
'//procedure[procedureName="CreateConfiguration"]/propertySheet/property[propertyName="ec_parameterForm"]/value',
        'forms/createConfigForm.xml'
    ],
    [
'//property[propertyName="forms"]/propertySheet/property[propertyName="CreateConfigForm"]/value',
        'forms/createConfigForm.xml'
    ],
    [
'//property[propertyName="forms"]/propertySheet/property[propertyName="EditConfigForm"]/value',
        'forms/editConfigForm.xml'
    ],

    [
'//procedure[procedureName="CreateConfiguration"]/step[stepName="CreateConfiguration"]/command',
        'config/createcfg.pl'
    ],
    [
'//procedure[procedureName="CreateConfiguration"]/step[stepName="CreateAndAttachCredential"]/command',
        'config/createAndAttachCredential.pl'
    ],
    [
'//procedure[procedureName="DeleteConfiguration"]/step[stepName="DeleteConfiguration"]/command',
        'config/deletecfg.pl'
    ]
);

