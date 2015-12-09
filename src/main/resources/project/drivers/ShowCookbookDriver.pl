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

# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use Cwd;
use Carp;
use strict;
use Data::Dumper;
use utf8;
use Encode;
use warnings;
use diagnostics;
use open IO => ':encoding(utf8)';
use File::Basename;
use ElectricCommander;
use ElectricCommander::PropDB;
use ElectricCommander::PropMod qw(/myProject/libs);
use ChefHelper;

$| = 1;

# -------------------------------------------------------------------------
# Main functions
# -------------------------------------------------------------------------

###########################################################################

=head2 main
 
  Title    : main
  Usage    : main();
  Function : Performs a Chef run
  Returns  : none
  Args     : named arguments: none
=cut

###########################################################################

sub main {
    my $ec = ElectricCommander->new();
    $ec->abortOnError(0);

    # -------------------------------------------------------------------------
    # Parameters
    # -------------------------------------------------------------------------
    my $knife_path =
      ( $ec->getProperty("knife_path") )->findvalue('//value')->string_value;
    my $cookbook_name =
      ( $ec->getProperty("cookbook_name") )->findvalue('//value')->string_value;
    my $cookbook_version =
      ( $ec->getProperty("cookbook_version") )->findvalue('//value')
      ->string_value;
    my $fqdn = ( $ec->getProperty("FQDN") )->findvalue('//value')->string_value;
    my $file_name =
      ( $ec->getProperty("file_name") )->findvalue('//value')->string_value;
    my $platform =
      ( $ec->getProperty("platform") )->findvalue('//value')->string_value;
    my $part = ( $ec->getProperty("part") )->findvalue('//value')->string_value;
    my $platform_version =
      ( $ec->getProperty("platform_version") )->findvalue('//value')
      ->string_value;
    my $with_uri =
      ( $ec->getProperty("with_uri") )->findvalue('//value')->string_value;
    my $additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')
      ->string_value;
    my $result_property =
      ( $ec->getProperty("result_property") )->findvalue('//value')
      ->string_value;

    #Variable that stores the command to be executed
    my $command = $knife_path . " cookbook show";

    $ec->abortOnError(0);

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure ShowCookbookInfo\n";

    #Parameters are checked to see which should be included
    if ( $cookbook_name && $cookbook_name ne '' ) {
        $command = $command . " " . $cookbook_name;
    }

    if ( $cookbook_version && $cookbook_version ne '' ) {
        $command = $command . " " . $cookbook_version;
    }

    if ( $part && $part ne '' ) {
        $command = $command . " " . $part;
    }

    if ( $file_name && $file_name ne '' ) {
        $command = $command . " " . $file_name;
    }

    if ( $fqdn && $fqdn ne '' ) {
        $command = $command . " --fqdn " . $fqdn;
    }

    if ( $platform && $platform ne '' ) {
        $command = $command . " --platform " . $platform;
    }

    if ( $platform_version && $platform_version ne '' ) {
        $command = $command . " --platform-version " . $platform_version;
    }

    if ( $with_uri && $with_uri ne '' ) {
        $command = $command . " --with-uri " . $with_uri;
    }

    if ( $fqdn && $fqdn ne '' )

    {
        $command = $command . " --fqdn " . $fqdn;
    }
    if ( $additional_options && $additional_options ne '' ) {
        $command = $command . " " . $additional_options;
    }

    my $storage;
    if ( $result_property && $result_property ne '' ) {
        $storage = $result_property;
    }
    else {
        $storage = "/myJob/result";
    }

    #Print out the command to be executed
    $command = $command . " -F json";
    print "\nCommand to be executed: \n$command \n\n";

    #Executes the command
    my $cmdLog = `$command`;
    print $cmdLog;
    $ec->setProperty( $storage, $cmdLog );
    # To get exit code of process shift right by 8
    my $exitCode = $? >> 8;
    # Set outcome
    setOutcomeFromExitCode($ec, $exitCode);
}

main();
