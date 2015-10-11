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

=head1 NAME

RegisterAndConvergeNode.pl

=head1 DESCRIPTION


Creates a Chef node and converges based on the given run-list using chef-client.

=head1 METHODS

=cut

use strict;
use warnings;
use File::Temp;
use ElectricCommander;
use ElectricCommander::PropDB;
use Sys::Hostname;

$|=1;

main();

sub main {
    my $ec = ElectricCommander->new();

    #Setting abort on error before looking up parameter values
    #through property references as some parameters are optional.
    #Don't want commander to fail in that case. We are already
    #checking for required parameters explicitly.
    $ec->abortOnError(0);

    #This step could be running on a dynamically provisioned agent
    #some where on some cloud. So, before doing anything else,
    #we do a sanity check to make sure the agent can communicate
    #with the commander server.
    checkConnectionToCommanderServer($ec);

    #Get input parameters for the procedure
    my $configName      = checkRequiredParam("config", $ec->getPropertyValue("config"));
    my $chefClientPath  = checkRequiredParam("chef_client_path", $ec->getPropertyValue("chef_client_path"));
    my $runList         = checkRequiredParam("run_list", $ec->getPropertyValue("run_list"));
    my $useSudo         = $ec->getPropertyValue("use_sudo");
    my $nodeName        = $ec->getPropertyValue("node_name");
    my $additionalArgs  = $ec->getPropertyValue("additional_arguments");

    #Get strict again
    $ec->abortOnError(1);
    #Get associated credentials and chef configuration
    my %configValues = getConfiguration($ec, $configName);
    my $chefServerUrl = $configValues{"server"};
    my $validatorClientName = $configValues{"validator_client_name"};
    my $validatorPem = $configValues{"validator_pem"};

    if ($^O eq 'MSWin32') {
	   $ENV{HOME} = $ENV{COMMANDER_WORKSPACE};
	   $useSudo = 0;
    }

    my $workingDir = $ENV{"HOME"} . "/chef";
    mkdir $workingDir;

    #Create validator PEM file
    my $validatorPemFileHandle = createValidatorPEM($validatorPem, $workingDir);

    #If no value is provided for the node name by the user, we assign a nodename so we know
    #how to reference it for termination later.
    if (!$nodeName) {
        my $resourceName = $ec->getProperty("/myJobStep/assignedResourceName")->findvalue('//value')->string_value;
        $nodeName = $resourceName . "_" . getRandomValue();
    }

    #Create client.rb file
    my $clientRBFile = createClientRBFile($validatorClientName, $nodeName, $chefServerUrl, $workingDir);

    #Finally, construct and run chef-client command

    # We default to sudo unless explicitly told not to.
    my $cmdPrefix = "";
    if ($useSudo ne 0) {
        $useSudo = 1; #explicitly set useSudo since we set it as a property on the resource later
        $cmdPrefix = "sudo ";
    }

    #strip out any spaces from the run-list comma-separated values
    my @arr = split /\s*,\s*/, $runList;
    $runList = join(",", @arr);

    my $chefClientCmd = $cmdPrefix . $chefClientPath . " --server " . $chefServerUrl .
        " -K " . $validatorPemFileHandle->filename() .
        " -c " . $clientRBFile .
        " -r " . $runList .
        " " . $additionalArgs;

    print "Invoking chef-client using command: $chefClientCmd \n";
    my $commandResult = system($chefClientCmd);
    if ($commandResult) {
	   my $exit_code = $? >> 8;
	   die "chef-client invocation failed with error: $exit_code";
    }

    #Finally, set properties on  myresource in order to aid the teardown of the chef client.
    my $configMgmtPropPath = "/myResource/ec_configurationmanagement_details";

    my $pdb = ElectricCommander::PropDB->new($ec, "");
    $pdb->setProp("$configMgmtPropPath/chef_client_path", "$chefClientPath");
    $pdb->setProp("$configMgmtPropPath/node_name", "$nodeName");
    $pdb->setProp("$configMgmtPropPath/client_rb_path", "$clientRBFile");
    $pdb->setProp("$configMgmtPropPath/run_as_sudo", "$useSudo");
}

sub checkConnectionToCommanderServer {
    my ($ec) = @_;
    my $originalPrintErrors = $ec->{printErrorsFromPost};
    #Turning on printErrorsFromPost to let getServerStatus
    #print any errors encountered while connecting to the
    #server.
    $ec->{printErrorsFromPost} = 1;
    my $result = $ec->getServerStatus();
    if(!defined($result)) {
        my $agentHostName = hostname;
        print "The agent on $agentHostName failed to communicate with the server on $ec->{server}\n";
    }
    $ec->{printErrorsFromPost} = $originalPrintErrors;
}

sub checkRequiredParam {
    my ($paramName,$paramValue) = @_;
    if ($paramValue eq "") {
        print "Error: '$paramName' is a required parameter\n";
        exit 1;
    }
    return $paramValue;
}

sub getConfiguration {
    my ($ec,$configName) = @_;

    my %configValues;

    my $proj = "@PLUGIN_NAME@";
    my $pluginConfigs = new ElectricCommander::PropDB($ec,"/projects/$proj/chef_cfgs");

    my %configRow = $pluginConfigs->getRow($configName);

    # Check that configuration exists
    unless(keys(%configRow)) {
        print "Error: EC-Chef Configuration $configName does not exist\n";
        exit 1;
    }

    #Get the configuration values and the credentials values
    foreach my $c (keys %configRow) {
        #getting all values except the credential which
        # will read separately
        if($c ne "credential"){
            $configValues{$c} = $configRow{$c};
        }
    }

    my $xpath = $ec->getFullCredential($configRow{credential});
    $configValues{"validator_client_name"} = $xpath->findvalue("//userName");
    $configValues{"validator_pem"} = $xpath->findvalue("//password");

    return %configValues;
}


sub createValidatorPEM() {
    my ($validatorPem, $dir) = @_;

    print "Creating validator PEM in $dir\n";

    #Create the validator PEM file
    my $validatorPemFile = File::Temp->new(
        TEMPLATE=>"validator.pem.XXXXXX",
        DIR => $dir
    );

    my $validatorPemFileName = $validatorPemFile->filename();
    chmod 0600, $validatorPemFileName;

    # Write the validator PEM contents to the file
    print $validatorPemFile $validatorPem;

    # Returning the file handle here because we want
    # this file to be accessible by the chef-client
    # which gets launched as a child process. If we
    # do not return the file handle, the handle is
    # scoped to this function and does not lend itself
    # to getting passed to the child process if the
    # file is set to be unlinked (default with File::temp)
    return $validatorPemFile;
}


sub createClientRBFile() {
    my ($validatorClientName, $nodeName, $chefServerUrl, $dir) = @_;

    my $clientRB = File::Temp->new(
        TEMPLATE=>"client.rb.XXXXXX",
        DIR => $dir,
        UNLINK => 0 #Keep the client.rb file after the run
    );

    #Configure the client.pem file location. We convey this
    #location to the chef-client through the client.rb file
    my $now = time();
    my $clientPemFile = $dir . "/client.pem." . $now;
    print "Client.pem file will be created at $clientPemFile\n";

    my $nodeNameClause = "node_name '$nodeName'";

    my $clientRBContents = <<"EOF";
validation_client_name '$validatorClientName'
client_key '$clientPemFile'
chef_server_url '$chefServerUrl'
$nodeNameClause
EOF

    my $clientRBFileName = $clientRB->filename();
    chmod 0600, $clientRBFileName;

    #Write the contents of the client.rb file
    print $clientRB $clientRBContents;

    return $clientRBFileName;
}

sub getRandomValue() {
    my $now = time();
    #adding two levels of randomization with time and rand
    #since this value is used to generate a unique name for
    #the node name on a shared chef server.
    return int(rand(9999999)) . $now;
}
