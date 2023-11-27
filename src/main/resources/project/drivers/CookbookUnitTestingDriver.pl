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
    my $chef_server_url =
      ( $ec->getProperty("chef_server_url") )->findvalue('//value')
      ->string_value;
    my $spec_path =
      ( $ec->getProperty("spec_path") )->findvalue('//value')->string_value;
    my $seed = ( $ec->getProperty("seed") )->findvalue('//value')->string_value;
    my $add_to_load_path =
      ( $ec->getProperty("add_to_load_path") )->findvalue('//value')
      ->string_value;
    my $default_path =
      ( $ec->getProperty("default_path") )->findvalue('//value')->string_value;
    my $example =
      ( $ec->getProperty("example") )->findvalue('//value')->string_value;
    my $tag = ( $ec->getProperty("tag") )->findvalue('//value')->string_value;
    my $exclude_pattern =
      ( $ec->getProperty("exclude_pattern") )->findvalue('//value')
      ->string_value;
    my $pattern =
      ( $ec->getProperty("pattern") )->findvalue('//value')->string_value;
    my $profiling =
      ( $ec->getProperty("profiling") )->findvalue('//value')->string_value;
    my $deprecation_file_path =
      ( $ec->getProperty("deprecation_file_path") )->findvalue('//value')
      ->string_value;
    my $out_file_path =
      ( $ec->getProperty("out_file_path") )->findvalue('//value')->string_value;
    my $format =
      ( $ec->getProperty("format") )->findvalue('//value')->string_value;
    my $failure_exit_code =
      ( $ec->getProperty("failure_exit_code") )->findvalue('//value')
      ->string_value;
    my $require_path =
      ( $ec->getProperty("require_path") )->findvalue('//value')->string_value;
    my $drb_port =
      ( $ec->getProperty("drb_port") )->findvalue('//value')->string_value;
    my $options_path =
      ( $ec->getProperty("options_path") )->findvalue('//value')->string_value;
    my $order =
      ( $ec->getProperty("order") )->findvalue('//value')->string_value;
    my $only_failure =
      ( $ec->getProperty("only_failure") )->findvalue('//value')->string_value;
    my $next_failures =
      ( $ec->getProperty("next_failures") )->findvalue('//value')->string_value;
    my $warnings =
      ( $ec->getProperty("warnings") )->findvalue('//value')->string_value;
    my $backtrace =
      ( $ec->getProperty("backtrace") )->findvalue('//value')->string_value;
    my $colour =
      ( $ec->getProperty("colour") )->findvalue('//value')->string_value;
    my $bisect =
      ( $ec->getProperty("bisect") )->findvalue('//value')->string_value;
    my $init_with_RSpec =
      ( $ec->getProperty("init_with_RSpec") )->findvalue('//value')
      ->string_value;
    my $DRb = ( $ec->getProperty("DRb") )->findvalue('//value')->string_value;
    my $abort_on_first_failure =
      ( $ec->getProperty("abort_on_first_failure") )->findvalue('//value')
      ->string_value;
    my $dry_run =
      ( $ec->getProperty("dry_run") )->findvalue('//value')->string_value;
    my $additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')
      ->string_value;
    $ec->abortOnError(1);

    #Variable that stores the command to be executed
    my $command = "chef exec rspec " . $spec_path;

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure CookbookUnitTesting\n";

    #Parameters are checked to see which should be included

    if ( $chef_server_url && $chef_server_url ne '' ) {
        $command = $command . " --server-url " . $chef_server_url;
    }

    if ( $seed && $seed ne '' ) {
        $command = $command . " --seed " . $seed;
    }
    if ( $add_to_load_path && $add_to_load_path ne '' ) {
        $command = $command . " -I " . $add_to_load_path;
    }
    if ( $example && $example ne '' ) {
        $command = $command . " --example " . $example;
    }
    if ( $default_path && $default_path ne '' ) {
        $command = $command . " --default-path " . $default_path;
    }
    if ( $exclude_pattern && $exclude_pattern ne '' ) {
        $command = $command . " --exclude-pattern " . $exclude_pattern;
    }
    if ( $pattern && $pattern ne '' ) {
        $command = $command . " --pattern " . $pattern;
    }
    if ( $tag && $tag ne '' ) {
        $command = $command . " --tag " . $tag;
    }
    if ( $deprecation_file_path && $deprecation_file_path ne '' ) {
        $command = $command . " --deprecation-out " . $deprecation_file_path;
    }
    if ( $out_file_path && $out_file_path ne '' ) {
        $command = $command . " --out " . $out_file_path;
    }
    if ( $profiling && $profiling ne '' ) {
        $command = $command . " --profile " . $profiling;
    }
    if ( $format && $format ne '' ) {
        $command = $command . " --format " . $format;
    }
    if ( $failure_exit_code && $failure_exit_code ne '' ) {
        $command = $command . " --failure-exit-code " . $failure_exit_code;
    }
    if ( $require_path && $require_path ne '' ) {
        $command = $command . " --require " . $require_path;
    }
    if ( $drb_port && $drb_port ne '' ) {
        $command = $command . " --drb-port " . $drb_port;
    }
    if ( $options_path && $options_path ne '' ) {
        $command = $command . " --options " . $options_path;
    }
    if ( $order && $order ne '' ) {
        $command = $command . " --order " . $order;
    }
    if ( $only_failure && $only_failure ne '' ) {
        $command = $command . "--only-failures";
    }

    if ( $next_failures && $next_failures ne '' ) {
        $command = $command . " --next-failure";
    }

    if ( $warnings && $warnings ne '' ) {
        $command = $command . " --warnings";
    }
    if ( $backtrace && $backtrace ne '' ) {
        $command = $command . " --backtrace";
    }
    if ( $colour && $colour ne '' ) {
        $command = $command . " --colour";
    }
    if ( $bisect && $bisect ne '' ) {
        $command = $command . " --bisect";
    }
    if ( $init_with_RSpec && $init_with_RSpec ne '' ) {
        $command = $command . " --init";
    }
    if ( $DRb && $DRb ne '' ) {
        $command = $command . " --drb";
    }
    if ( $abort_on_first_failure && $abort_on_first_failure ne '' ) {
        $command = $command . " --fail-fast";
    }
    if ( $dry_run && $dry_run ne '' ) {
        $command = $command . " --dry-run";
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
