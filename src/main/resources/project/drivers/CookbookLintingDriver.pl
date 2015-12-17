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
    my $cookbook_path =
      ( $ec->getProperty("cookbook_path") )->findvalue('//value')->string_value;
    my $failure_tags =
      ( $ec->getProperty("failure_tags") )->findvalue('//value')->string_value;
    my $rules_path =
      ( $ec->getProperty("rules_path") )->findvalue('//value')->string_value;
    my $grammer_path =
      ( $ec->getProperty("grammer_path") )->findvalue('//value')->string_value;
    my $checked_tags =
      ( $ec->getProperty("checked_tags") )->findvalue('//value')->string_value;
    my $version =
      ( $ec->getProperty("version") )->findvalue('//value')->string_value;
    my $context =
      ( $ec->getProperty("context") )->findvalue('//value')->string_value;
    my $repl = ( $ec->getProperty("REPL") )->findvalue('//value')->string_value;
    my $additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')
      ->string_value;

    #Variable that stores the command to be executed
    my $command = "foodcritic ";

    $ec->abortOnError(1);

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure CookbookLinting\n";

    #Parameters are checked to see which should be included
    if ( $cookbook_path && $cookbook_path ne '' ) {
        $command = $command . " " . $cookbook_path;
    }

    if ( $failure_tags && $failure_tags ne '' ) {
        $command = $command . " --epic-fail " . $failure_tags;
    }

    if ( $rules_path && $rules_path ne '' ) {
        $command = $command . " --include " . $rules_path;
    }

    if ( $grammer_path && $grammer_path ne '' ) {
        $command = $command . " --search-grammar " . $grammer_path;
    }

    if ( $checked_tags && $checked_tags ne '' ) {
        $command = $command . " --tags " . $checked_tags;
    }

    if ( $version && $version ne '' ) {
        $command = $command . " --version";
    }

    if ( $context && $context ne '' ) {
        $command = $command . " --context";
    }
    if ( $repl && $repl ne '' ) {
        $command = $command . " --repl";
    }
    if ( $additional_options && $additional_options ne '' ) {
        $command = $command . " " . $additional_options;
    }

    #Print out the command to be executed
    print "\nCommand to be executed: \n$command \n\n";

    #Executes the command
    system("$command");
    # To get exit code of process shift right by 8
    my $exitCode = $? >> 8;
    # Set outcome
    setOutcomeFromExitCode($ec, $exitCode);
}

main();
