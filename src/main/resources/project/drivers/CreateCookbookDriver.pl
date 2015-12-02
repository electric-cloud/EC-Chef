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
    my $copyright =
      ( $ec->getProperty("copyright") )->findvalue('//value')->string_value;
    my $license =
      ( $ec->getProperty("license") )->findvalue('//value')->string_value;
    my $email =
      ( $ec->getProperty("email") )->findvalue('//value')->string_value;
    my $cookbook_path =
      ( $ec->getProperty("cookbook_path") )->findvalue('//value')->string_value;
    my $readme_format =
      ( $ec->getProperty("readme_format") )->findvalue('//value')->string_value;
    my $additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')
      ->string_value;

    $ec->abortOnError(1);

    #Variable that stores the command to be executed
    my $command = $knife_path . " cookbook create";

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure CreateCookbook\n";

    #Parameters are checked to see which should be included
    if ( $cookbook_name && $cookbook_name ne '' ) {
        $command = $command . " " . $cookbook_name;
    }

    if ( $copyright && $copyright ne '' ) {
        $command = $command . " --copyright " . $copyright;
    }

    if ( $license && $license ne '' ) {
        $command = $command . " --license " . $license;
    }

    if ( $email && $email ne '' ) {
        $command = $command . " --email " . $email;
    }

    if ( $cookbook_path && $cookbook_path ne '' ) {
        $command = $command . " --cookbook-path " . $cookbook_path;
    }

    if ( $readme_format && $readme_format ne '' ) {
        $command = $command . " --readme-format " . $readme_format;
    }

    if ( $additional_options && $additional_options ne '' ) {
        $command = $command . " " . $additional_options;
    }

    $command = $command . " -d";

    #Print out the command to be executed
    print "\nCommand to be executed: \n$command \n\n";

    #Execute the command
    system("$command");
    # To get exit code of process shift right by 8
    my $exitCode = $? >> 8;
    # Set outcome
    setOutcomeFromExitCode($ec, $exitCode);
}

main();
