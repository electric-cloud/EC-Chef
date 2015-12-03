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
    my $index =
      ( $ec->getProperty("index") )->findvalue('//value')->string_value;
    my $additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')
      ->string_value;
    my $result_property =
      ( $ec->getProperty("result_property") )->findvalue('//value')
      ->string_value;
    my $query =
      ( $ec->getProperty("query") )->findvalue('//value')->string_value;
    my $attr = ( $ec->getProperty("attr") )->findvalue('//value')->string_value;
    my $filter =
      ( $ec->getProperty("filter") )->findvalue('//value')->string_value;
    my $sort = ( $ec->getProperty("sort") )->findvalue('//value')->string_value;
    my $long = ( $ec->getProperty("long") )->findvalue('//value')->string_value;
    my $medium =
      ( $ec->getProperty("medium") )->findvalue('//value')->string_value;
    my $runlist =
      ( $ec->getProperty("runlist") )->findvalue('//value')->string_value;
    my $search_query =
      ( $ec->getProperty("search_query") )->findvalue('//value')->string_value;
    my $row = ( $ec->getProperty("row") )->findvalue('//value')->string_value;
    my $row_count =
      ( $ec->getProperty("row_count") )->findvalue('//value')->string_value;
    my $id_only =
      ( $ec->getProperty("id_only") )->findvalue('//value')->string_value;
    $ec->abortOnError(1);

    #Variable that stores the command to be executed
    my $command = $knife_path . " search";

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure KnifeSearch\n";

    #Parameters are checked to see which should be included

    if ( $index && $index ne '' ) {
        $command = $command . " " . $index;
    }

    if ( $query && $query ne '' ) {
        $command = $command . " " . $query;
    }

    if ( $attr && $attr ne '' ) {
        $command = $command . " --attribute " . $attr;
    }

    if ( $row && $row ne '' ) {
        $command = $command . " --start " . $row;
    }
    if ( $filter && $filter ne '' ) {
        $command = $command . " --filter-result " . $filter;
    }
    if ( $id_only && $id_only ne '' ) {
        $command = $command . " --id-only";
    }
    if ( $long && $long ne '' ) {
        $command = $command . " --long";
    }
    if ( $medium && $medium ne '' ) {
        $command = $command . " --medium";
    }
    if ( $sort && $sort ne '' ) {
        $command = $command . " --sort " . $sort;
    }
    if ( $search_query && $search_query ne '' ) {
        $command = $command . " --query " . $query;
    }
    if ( $runlist && $runlist ne '' ) {
        $command = $command . " --run-list " . $runlist;
    }
    if ( $row_count && $row_count ne '' ) {
        $command = $command . " --rows " . $row_count;
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
    $command = $command . " -F json -d";
    print "\nCommand to be executed: \n$command \n\n";

    #Executes the command
    my $cmdLog = `$command`;
    print $cmdLog;
    $ec->setProperty( $storage, $cmdLog );

    # To get exit code of process shift right by 8
    my $exitCode = $? >> 8;

    # Set outcome
    setOutcomeFromExitCode( $ec, $exitCode );
}

main();
