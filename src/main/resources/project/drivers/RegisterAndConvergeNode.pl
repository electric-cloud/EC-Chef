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

$|=1;

main();

sub main {
    my $ec = ElectricCommander->new();

    #Get input parameters for the procedure
    my $configName      = checkRequiredParam("config", q{$[config]});
    my $chefClientPath  = checkRequiredParam("chef_client_path", q{$[chef_client_path]});
    my $runList         = checkRequiredParam("run_list", q{$[run_list]});
    my $useSudo         = q{$[use_sudo]};
    my $nodeName        = q{$[node_name]};
    my $additionalArgs  = q{$[additional_arguments]};

    #Get associated credentials and chef configuration
    my %configValues = getConfiguration($ec, $configName);
    my $chefServerUrl = $configValues{"server"};
    my $validatorClientName = $configValues{"validator_client_name"};
    my $validatorPem = $configValues{"validator_pem"};

    my $workingDir = $ENV{"HOME"} . "/chef";
    mkdir $workingDir;

    #Create validator PEM file
    my $validatorPemFileHandle = createValidatorPEM($validatorPem, $workingDir);

    #Create client.rb file
    my $clientRBFile = createClientRBFile($validatorClientName, $nodeName, $workingDir);

    #Finally, construct and run chef-client command

    # We default to sudo unless explicitly told not to.
    my $cmdPrefix = "";
    if ($useSudo ne 0) {
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
    system($chefClientCmd) == 0 or die "chef-client invocation failed with error: $?";
}


sub checkRequiredParam {
    my ($paramName,$paramValue) = @_;
    if ($paramValue eq "") {
        mesg(0,"$paramName is a required parameter\n");
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
        print "EC-Chef Configuration $configName does not exist";
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
    my ($validatorClientName, $nodeName, $dir) = @_;

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

    #We let chef assign the node name if no value is provided for the
    #node name by the user
    my $nodeNameClause = "";
    if ($nodeName ne "") {
        $nodeNameClause = "node_name '$nodeName'";
    }

    my $clientRBContents = <<"EOF";
validation_client_name '$validatorClientName'
client_key '$clientPemFile'
$nodeNameClause
EOF

    my $clientRBFileName = $clientRB->filename();
    chmod 0600, $clientRBFileName;

    #Write the contents of the client.rb file
    print $clientRB $clientRBContents;

    return $clientRBFileName;
}

