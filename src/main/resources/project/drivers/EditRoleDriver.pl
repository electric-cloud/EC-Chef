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
use File::Temp qw/ tempfile /;

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
    my $role_name =
      ( $ec->getProperty("role_name") )->findvalue('//value')->string_value;
    my $role_data =
      ( $ec->getProperty("role_data") )->findvalue('//value')->string_value;
    my $additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')
      ->string_value;
   
    $ec->abortOnError(1);

#Use show command to populate a file which should be used to show user before edit
#Write to file
    my $dir = cwd();
    my $fh = tempfile( );
    my $template = "roleXXXX";
    my $filename;
    ($fh, $filename) = tempfile( $template, SUFFIX => ".json",DIR => $dir,UNLINK=>1);

    if ( $role_name && $role_name ne '' ) {
        open my $fh, '>', $filename or die "can't open $filename: $!";
        print $fh $role_data;
        close $fh;
    }

    #Variable that stores the command to be executed
    my $command        = $knife_path . " role";
    my $delete_command = $knife_path . " role delete";

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure EditRole\n";

    #Parameters are checked to see which should be included
    if ( $role_name && $role_name ne '' ) {
        $delete_command = $delete_command . " " . $role_name . " -y";
    }

    if ( $filename && $filename ne '' ) {
        $command = $command . " from file " . $filename;
    }
    if ( $additional_options && $additional_options ne '' ) {
        $command = $command . " " . $additional_options;
    }

    #Print out the command to be executed(Delete previous Role)
    print "\nCommand to be executed: \n$delete_command \n\n";

    #Execute the command to delete the previous role
    system("$delete_command");

    #Print out the command to be executed
    print "\nCommand to be executed: \n$command \n\n";

#Execute the command to create a new role with the same name and new configurations
    system("$command");

}

main();
