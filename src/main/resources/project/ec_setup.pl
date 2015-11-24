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

my %DownloadCookbookFromRepository = (
    label       => "Chef - Download Cookbook From Repository",
    procedure   => "DownloadCookbookFromRepository",
    description => "Download a specific cookbook from the Opscode repository",
    category    => "Resource Management"
);

my %InstallCookbookOnClient = (
    label       => "Chef - Install Cookbooks On Client",
    procedure   => "InstallCookbookOnClient",
    description => "Install a specific cookbook on a Chef client",
    category    => "Resource Management"
);

my %UploadCookbooksToServer = (
    label       => "Chef - Upload Cookbooks To Server",
    procedure   => "UploadCookbooksToServer",
    description => "Upload cookbooks to the Chef server",
    category    => "Resource Management"
);

my %CreateNode = (
    label       => "Chef - Create node",
    procedure   => "Createnode",
    description => "Run the create node command",
    category    => "Resource Management"
);

my %EditNode = (
    label       => "Chef - Edit node",
    procedure   => "EditNode",
    description => "Run the edit node command",
    category    => "Resource Management"
);

my %DeleteSingleNode = (
    label       => "Chef - Delete node",
    procedure   => "DeleteSingleNode",
    description => "Run the delete node command",
    category    => "Resource Management"
);

my %ListNode = (
    label       => "Chef - List node",
    procedure   => "ListNode",
    description => "Run the list node command",
    category    => "Resource Management"
);

my %ShowNode = (
    label       => "Chef - Show node",
    procedure   => "ShowNode",
    description => "Run the show node command",
    category    => "Resource Management"
);

my %AddRecipesToNodeRunList = (
    label       => "Chef - Add Recipes To Node RunList",
    procedure   => "AddRecipesToNodeRunList",
    description => "Add recipes to a node run-list",
    category    => "Resource Management"
);

my %RemoveRecipesFromNodeRunList = (
    label       => "Chef - Remove Recipes from Node RunList",
    procedure   => "RemoveRecipesFromNodeRunList",
    description => "Remove recipes from a node run-list",
    category    => "Resource Management"
);

my %RunChefClient = (
    label       => "Chef - Run Chef Client",
    procedure   => "RunChefClient",
    description => "Run the chef-client command",
    category    => "Resource Management"
);

my %CreateDataBag = (
    label       => "Chef - CreateDataBag",
    procedure   => "CreateDataBag",
    description => "Create Data Bag",
    category    => "Resource Management"
);
my %EditDataBag = (
    label       => "Chef - EditDataBag",
    procedure   => "EditDataBag",
    description => "Edit Data Bag",
    category    => "Resource Management"
);
my %DeleteDataBag = (
    label       => "Chef - DeleteDataBag",
    procedure   => "DeleteDataBag",
    description => "Delete Data Bag",
    category    => "Resource Management"
);
my %ListDataBag = (
    label       => "Chef - ListDataBag",
    procedure   => "ListDataBag",
    description => "Displays all the data bags present",
    category    => "Resource Management"
);
my %ShowDataBag = (
    label       => "Chef - ShowDataBag",
    procedure   => "ShowDataBagContent",
    description => "Dispays the content of data bag",
    category    => "Resource Management"
);
my %Bootstrap = (
    label       => "Chef - Bootstrap",
    procedure   => "Bootstrap",
    description => "Bootstrap a Chef Node",
    category    => "Resource Management"
);
my %CreateRole = (
    label       => "Chef - Create Role",
    procedure   => "CreateRole",
    description => "Run the create role command",
    category    => "Resource Management"
);
my %EditRole = (
    label       => "Chef - Edit Role",
    procedure   => "EditRole",
    description => "Run the edit role command",
    category    => "Resource Management"
);
my %DeleteRole = (
    label       => "Chef - Delete Role",
    procedure   => "DeleteRole",
    description => "Run the delete role command",
    category    => "Resource Management"
);
my %ShowRole = (
    label       => "Chef - Show Role",
    procedure   => "ShowRole",
    description => "Run the show role command",
    category    => "Resource Management"
);
my %ListRole = (
    label       => "Chef - List Roles",
    procedure   => "ListRole",
    description => "Run the list role command",
    category    => "Resource Management"
);
my %CreateClientKey = (
    label       => "Chef - CreateClientKey",
    procedure   => "CreateClientKey",
    description => "Client Key Create",
    category    => "Resource Management"
);
my %DeleteClientKey = (
    label       => "Chef - DeleteClientKey",
    procedure   => "DeleteClientKey",
    description => "Client Key Delete",
    category    => "Resource Management"
);
my %EditClientKey = (
    label       => "Chef - EditClientKey",
    procedure   => "EditClientKey",
    description => "Client Key Edit",
    category    => "Resource Management"
);
my %ListClientKey = (
    label       => "Chef - ListClientKey",
    procedure   => "ListClientKey",
    description => "Client Key List",
    category    => "Resource Management"
);
my %ShowClientKey = (
    label       => "Chef - ]ShowClientKey",
    procedure   => "]ShowClientKey",
    description => "Client Key Show",
    category    => "Resource Management"
);
my %CreateClient = (
    label       => "Chef - CreateClient",
    procedure   => "CreateClient",
    description => "Create Client",
    category    => "Resource Management"
);
my %ListClient = (
    label       => "Chef - ListClient",
    procedure   => "ListClient",
    description => "List Clients",
    category    => "Resource Management"
);
my %ShowClient = (
    label       => "Chef - ShowClient",
    procedure   => "ShowClient",
    description => "Show Client",
    category    => "Resource Management"
);
my %DeleteClient = (
    label       => "Chef - DeleteClient",
    procedure   => "DeleteClient",
    description => "Delete Client",
    category    => "Resource Management"
);

$batch->deleteProperty(
"/server/ec_customEditors/pickerStep/EC-Chef - DownloadCookbookFromRepository"
);
$batch->deleteProperty(
"/server/ec_customEditors/pickerStep/Chef - Download Cookbooks From Repository"
);

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - InstallCookbookOnClient");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Install Cookbook On Client");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - UploadCookbooksToServer");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Upload Cookbooks To Server");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - CreateNode");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Create node");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - DeleteSingleNode");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Delete single node");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - EditNode");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Edit node");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - ListNode");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - List node");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - ShowNode");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Show node");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - AddRecipesToNodeRunList");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Add Recipes To Node RunList");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - RemoveRecipesFromNodeRunList"
);
$batch->deleteProperty(
"/server/ec_customEditors/pickerStep/Chef - Remove Recipes From Node RunList"
);

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - RunChefClient");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Run Chef Client");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - CreateDataBag");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Create Data Bag");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - EditDataBag");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Edit Data Bag");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - DeleteDataBag");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Delete Data Bag");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - ListDataBag");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - List Data Bag");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - ShowDataBag");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - ShowDataBag");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - Bootstrap");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Bootstrap");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - CreateRole");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Create role");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - DeleteRole");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Delete role");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - EditRole");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Edit role");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - ListRole");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - List roles");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - ShowRole");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Show role");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - CreateClient");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Create client");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - DeleteClient");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Delete client");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - ListClient");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - List clients");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - ShowClient");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - Show client");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - CreateClientKey");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - CreateClientKey");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - EditClientKey");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - EditClientKey");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - DeleteClientKey");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - DeleteClientKey");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - ListClientKey");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - ListClientKey");

$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/EC-Chef - ShowClientKey");
$batch->deleteProperty(
    "/server/ec_customEditors/pickerStep/Chef - ShowClientKey");

@::createStepPickerSteps = (
    \%DownloadCookbookFromRepository, \%InstallCookbookOnClient,
    \%UploadCookbooksToServer,        \%CreateNode,
    \%DeleteSingleNode,               \%EditNode,
    \%ListNode,                       \%ShowNode,
    \%AddRecipesToNodeRunList,        \%RemoveRecipesFromNodeRunList,
    \%RunChefClient,                  \%CreateDataBag,
    \%EditDataBag,                    \%DeleteDataBag,
    \%ListDataBag,                    \%ShowDataBag,
    \%Bootstrap,                      \%CreateRole,
    \%DeleteRole,                     \%EditRole,
    \%ListRole,                       \%ShowRole,
    \%CreateClient,                   \%DeleteClient,
    \%ListClient,                     \%ShowClient,
    \%CreateClientKey,                \%EditClientKey,
    \%DeleteClientKey,                \%ListClientKey,
    \%ShowClientKey
);

if ( $upgradeAction eq "upgrade" ) {
    $commander->{abortOnError} = 0;
    my $query  = $commander->newBatch();
    my $newcfg = $query->getProperty("/plugins/$pluginName/project/chef_cfgs");
    my $oldcfgs =
      $query->getProperty("/plugins/$otherPluginName/project/chef_cfgs");

    my $creds = $query->getCredentials("\$[/plugins/$otherPluginName]");

    $query->submit();

    # if new plugin does not already have cfgs
    if ( $query->findvalue( $newcfg, "code" ) eq "NoSuchProperty" ) {

        # if old cfg has some cfgs to copy
        if ( $query->findvalue( $oldcfgs, "code" ) ne "NoSuchProperty" ) {
            $batch->clone(
                {
                    path      => "/plugins/$otherPluginName/project/chef_cfgs",
                    cloneName => "/plugins/$pluginName/project/chef_cfgs"
                }
            );
        }
    }

    # Copy configuration credentials and attach them to the appropriate steps
    my $nodes = $query->find($creds);
    if ($nodes) {
        my @nodes = $nodes->findnodes('credential/credentialName');
        for (@nodes) {

            my $cred = $_->string_value;

            # Clone the credential
            $batch->clone(
                {
                    path =>
                      "/plugins/$otherPluginName/project/credentials/$cred",
                    cloneName =>
                      "/plugins/$pluginName/project/credentials/$cred"
                }
            );

       # Make sure the credential has an ACL entry for the new project principal
            my $xpath = $commander->getAclEntry(
                "user",
                "project: $pluginName",
                {
                    projectName    => $otherPluginName,
                    credentialName => $cred
                }
            );
            if ( $xpath->findvalue("//code") eq "NoSuchAclEntry" ) {
                $batch->deleteAclEntry(
                    "user",
                    "project: $otherPluginName",
                    {
                        projectName    => $pluginName,
                        credentialName => $cred
                    }
                );
                $batch->createAclEntry(
                    "user",
                    "project: $pluginName",
                    {
                        projectName                => $pluginName,
                        credentialName             => $cred,
                        readPrivilege              => 'allow',
                        modifyPrivilege            => 'allow',
                        executePrivilege           => 'allow',
                        changePermissionsPrivilege => 'allow'
                    }
                );
            }

            # Attach credentials to appropriate steps
            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'DownloadCookbookFromRepository',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'InstallCookbookOnClient',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'CreateNode',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'DeleteSingleNode',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'EditNode',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'ListNode',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'ShowNode',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'AddRecipesToNodeRunList',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'RemoveRecipesFromNodeRunList',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'RunChefClient',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => '_RegisterAndConvergeNode',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'CreateDataBag',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'EditDataBag',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'DeleteDataBag',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'ListDataBag',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'ShowDataBag',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'Bootstrap',
                    stepName      => 'runChef'
                }
            );
            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'CreateRole',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'DeleteRole',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'EditRole',
                    stepName      => 'runChef'
                }
            );
            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'ListRole',
                    stepName      => 'runChef'
                }
            );
            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'ShowRole',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'CreateClient',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'DeleteClient',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'ListClient',
                    stepName      => 'runChef'
                }
            );
            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'ShowClient',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'CreateClientKey',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'DeleteClientKey',
                    stepName      => 'runChef'
                }
            );

            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'EditClientKey',
                    stepName      => 'runChef'
                }
            );
            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'ListClientKey',
                    stepName      => 'runChef'
                }
            );
            $batch->attachCredential(
                "\$[/plugins/$pluginName/project]",
                $cred,
                {
                    procedureName => 'ShowClientKey',
                    stepName      => 'runChef'
                }
            );

        }
    }
}
