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
    my $client_name =
      ( $ec->getProperty("client_name") )->findvalue('//value')->string_value;
    my $key_name =
      ( $ec->getProperty("key_name") )->findvalue('//value')->string_value;
    my $new_key_name =
      ( $ec->getProperty("new_key_name") )->findvalue('//value')->string_value;
    my $save_to_file =
      ( $ec->getProperty("save_to_file") )->findvalue('//value')->string_value;
    my $key_from_file =
      ( $ec->getProperty("key_from_file") )->findvalue('//value')->string_value;
    my $expiration_date =
      ( $ec->getProperty("expiration_date") )->findvalue('//value')
      ->string_value;
    my $replace_key =
      ( $ec->getProperty("replace_key") )->findvalue('//value')->string_value;
    my $additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')
      ->string_value;

    $ec->abortOnError(1);

    #Variable that stores the command to be executed
    my $command = $knife_path . " client key edit ";

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure EditClientKey\n";

    #Parameters are checked to see which should be included
    if ( $client_name && $client_name ne '' ) {
        $command = $command . " " . $client_name;
    }

    if ( $key_name && $key_name ne '' ) {
        $command = $command . " " . $key_name;
    }

    if ( $new_key_name && $new_key_name ne '' ) {
        $command = $command . " --key-name " . $new_key_name;
    }

    if ( $save_to_file && $save_to_file ne '' ) {
        $command = $command . " --file " . $save_to_file;
    }

    if ( $key_from_file && $key_from_file ne '' ) {
        $command = $command . " --public-key " . $key_from_file;
    }

    if ( $expiration_date && $expiration_date ne '' ) {
        $command = $command . " --expiration-date " . $expiration_date;
    }

    if ( $replace_key && $replace_key ne '' ) {
        $command = $command . " --create-key";
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
