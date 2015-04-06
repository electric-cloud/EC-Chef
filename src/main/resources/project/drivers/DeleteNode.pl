=head1 NAME

DeleteNode.pl

=head1 DESCRIPTION

Delete a previously created chef node and chef client on the given dynamic resource.

=head1 METHODS

=cut

use strict;
use warnings;
use File::Spec;
use ElectricCommander;

$|=1;

main();

sub main {
    my $ec = ElectricCommander->new();

    #Retrieve the properties set earlier on the resource by _RegisterAndConvergeNode procedure
    my $xpath = $ec->getProperties({path=>"/myResource/ec_configurationmanagement_details"});

    my $nodeName = $xpath->find("//response/propertySheet/property[propertyName='node_name']/value");
    my $chefClientPath = $xpath->find("//response/propertySheet/property[propertyName='chef_client_path']/value");
    my $clientRBFilePath = $xpath->find("//response/propertySheet/property[propertyName='client_rb_path']/value");
    my $runAsSudo = $xpath->find("//response/propertySheet/property[propertyName='run_as_sudo']/value");

    #validate that the values are set and are valid
    checkRequiredProperty("ec_configurationmanagement_details/node_name", $nodeName);
    checkRequiredProperty("ec_configurationmanagement_details/chef_client_path", $chefClientPath);
    checkRequiredProperty("ec_configurationmanagement_details/client_rb_path", $clientRBFilePath);
    if(! -e $clientRBFilePath) {
        die "'$clientRBFilePath' file does not exist\n";
    }

    #Deducing knife path based on the chef-client path
    my($volume,$parentDir,$file) = File::Spec->splitpath($chefClientPath);
    my $knifePath = File::Spec->catpath($volume, $parentDir, "knife");

    if(! -e $knifePath) {
        die "'$knifePath' file does not exist. The knife executable should be in the same location as the chef-client executable that was used to converge this resource.\n";
    }

    my $cmdPrefix = "";
    if ($runAsSudo) {
        $cmdPrefix = "sudo ";
    }

    #Construct knife command to delete node
    my $knifeCmd = $cmdPrefix . $knifePath . " node delete " . $nodeName .
        " --yes -c " . $clientRBFilePath;

    print "Invoking command: $knifeCmd \n";
    my $commandResult = system($knifeCmd);
    if ($commandResult) {
       my $exit_code = $? >> 8;
       die "knife invocation failed with error: $exit_code. \nChef node $nodeName will need to be manually deleted.";
    }

    #Construct knife command to delete Chef API client
    $knifeCmd = $cmdPrefix . $knifePath . " client delete " . $nodeName .
        " --yes -c " . $clientRBFilePath;

    print "Invoking command: $knifeCmd \n";
    $commandResult = system($knifeCmd);
    if ($commandResult) {
       my $exit_code = $? >> 8;
       die "knife invocation failed with error: $exit_code. \nChef API client $nodeName will need to be manually deleted.";
    }

}

sub checkRequiredProperty {
    my ($name,$value) = @_;
    if (!$value) {
        print "Error: No value found for resource property '$name'.\n";
        exit 1;
    }
}