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
use ElectricCommander::PropMod;
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
    $::g_knife_path =
      ( $ec->getProperty("knife_path") )->findvalue('//value')->string_value;
    $::g_databag =
      ( $ec->getProperty("databag_name") )->findvalue('//value')->string_value;
    $::g_databag_item_content =
      ( $ec->getProperty("data_bag_item_content") )->findvalue('//value')
      ->string_value;
    $::g_secret_key =
      ( $ec->getProperty("secret_key") )->findvalue('//value')->string_value;
    $::g_secret_file =
      ( $ec->getProperty("secret_key_path") )->findvalue('//value')
      ->string_value;
    $::g_additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')
      ->string_value;

    #Write to file
    my $file = "/tmp/databagitem.json";
    if ( $::g_databag_item_content && $::g_databag_item_content ne '' ) {
        open my $fh, '>', $file or die "can't open $file: $!";
        print $fh $::g_databag_item_content;
        close $fh;
    }

    #Variable that stores the command to be executed

    $::g_command = $::g_knife_path . " data bag from file";
    if ( $::g_databag && $::g_databag ne '' ) {
        $::g_command = $::g_command . " " . $::g_databag;
    }
    $::g_command = $::g_command . " " . $file;

    if ( $::g_secret_key && $::g_secret_key ne '' ) {
        $::g_command = $::g_command . " --secret " . $::g_secret_key;
    }

    if ( $::g_secret_file && $::g_secret_file ne '' ) {
        $::g_command = $::g_command . " --secret-file " . $::g_secret_file;
    }
    if ( $::g_additional_options && $::g_additional_options ne '' ) {
        $::g_command = $::g_command . " " . $::g_additional_options;
    }

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure EditDataBag\n";

    #Print out the command to be executed
    print "\nCommand to be executed: \n$::g_command \n\n";

    #Executes the command
    system("$::g_command");
    unlink $file;
}

main();
