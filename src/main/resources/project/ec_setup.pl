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


$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - DownloadCookbookFromRepository");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Download Cookbooks From Repository");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - InstallCookbookOnClient");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Install Cookbook On Client");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - UploadCookbooksToServer");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Upload Cookbooks To Server");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - CreateNode");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Create node");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - DeleteSingleNode");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Delete single node");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - EditNode");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Edit node");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - ListNode");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - List node");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - ShowNode");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Show node");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - AddRecipesToNodeRunList");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Add Recipes To Node RunList");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - RemoveRecipesFromNodeRunList");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Remove Recipes From Node RunList");

$batch->deleteProperty("/server/ec_customEditors/pickerStep/EC-Chef - RunChefClient");
$batch->deleteProperty("/server/ec_customEditors/pickerStep/Chef - Run Chef Client");

@::createStepPickerSteps = (\%DownloadCookbookFromRepository, \%InstallCookbookOnClient, \%UploadCookbooksToServer, \%CreateNode , \%DeleteSingleNode, \%EditNode, \%ListNode, \%ShowNode, \%AddRecipesToNodeRunList, \%RemoveRecipesFromNodeRunList, \%RunChefClient);

if ($upgradeAction eq "upgrade") {
    $commander->{abortOnError} = 0;
    my $query = $commander->newBatch();
    my $newcfg = $query->getProperty(
        "/plugins/$pluginName/project/chef_cfgs");
    my $oldcfgs = $query->getProperty(
        "/plugins/$otherPluginName/project/chef_cfgs");
        
    my $creds = $query->getCredentials(
        "\$[/plugins/$otherPluginName]");

    $query->submit();

    # if new plugin does not already have cfgs
    if ($query->findvalue($newcfg,"code") eq "NoSuchProperty") {
        # if old cfg has some cfgs to copy
        if ($query->findvalue($oldcfgs,"code") ne "NoSuchProperty") {
            $batch->clone({
                path => "/plugins/$otherPluginName/project/chef_cfgs",
                cloneName => "/plugins/$pluginName/project/chef_cfgs"
            });
        }
    }
    
    # Copy configuration credentials and attach them to the appropriate steps
    my $nodes = $query->find($creds);
    if ($nodes) {
        my @nodes = $nodes->findnodes('credential/credentialName');
        for (@nodes) {
            
            my $cred = $_->string_value;

            # Clone the credential
            $batch->clone({
                path => "/plugins/$otherPluginName/project/credentials/$cred",
                cloneName => "/plugins/$pluginName/project/credentials/$cred"
            });

            # Make sure the credential has an ACL entry for the new project principal
            my $xpath = $commander->getAclEntry("user", "project: $pluginName", {
                projectName => $otherPluginName,
                credentialName => $cred
            });
            if ($xpath->findvalue("//code") eq "NoSuchAclEntry") {
                $batch->deleteAclEntry("user", "project: $otherPluginName", {
                    projectName => $pluginName,
                    credentialName => $cred
                });
                $batch->createAclEntry("user", "project: $pluginName", {
                    projectName => $pluginName,
                    credentialName => $cred,
                    readPrivilege => 'allow',
                    modifyPrivilege => 'allow',
                    executePrivilege => 'allow',
                    changePermissionsPrivilege => 'allow'
                });
            }

            # Attach credentials to appropriate steps            
            $batch->attachCredential("\$[/plugins/$pluginName/project]", $cred, {
                procedureName => 'DownloadCookbookFromRepository',
                stepName => 'runChef'
            });

            $batch->attachCredential("\$[/plugins/$pluginName/project]", $cred, {
                procedureName => 'InstallCookbookOnClient',
                stepName => 'runChef'
            });

            $batch->attachCredential("\$[/plugins/$pluginName/project]", $cred, {
                procedureName => 'CreateNode',
                stepName => 'runChef'
            });

            $batch->attachCredential("\$[/plugins/$pluginName/project]", $cred, {
                procedureName => 'DeleteSingleNode',
                stepName => 'runChef'
            });

            $batch->attachCredential("\$[/plugins/$pluginName/project]", $cred, {
                procedureName => 'EditNode',
                stepName => 'runChef'
            });

            $batch->attachCredential("\$[/plugins/$pluginName/project]", $cred, {
                procedureName => 'ListNode',
                stepName => 'runChef'
            });

            $batch->attachCredential("\$[/plugins/$pluginName/project]", $cred, {
                procedureName => 'ShowNode',
                stepName => 'runChef'
            });

            $batch->attachCredential("\$[/plugins/$pluginName/project]", $cred, {
                procedureName => 'AddRecipesToNodeRunList',
                stepName => 'runChef'
            });

            $batch->attachCredential("\$[/plugins/$pluginName/project]", $cred, {
                procedureName => 'RemoveRecipesFromNodeRunList',
                stepName => 'runChef'
            });

            $batch->attachCredential("\$[/plugins/$pluginName/project]", $cred, {
                procedureName => 'RunChefClient',
                stepName => 'runChef'
            });

            $batch->attachCredential("\$[/plugins/$pluginName/project]", $cred, {
                procedureName => '_RegisterAndConvergeNode',
                stepName => 'runChef'
            });
        }
    }
}
