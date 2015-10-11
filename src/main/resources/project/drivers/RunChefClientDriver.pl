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

$|=1;


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
    $::g_chef_client_path = ($ec->getProperty( "chef_client_path" ))->findvalue('//value')->string_value;
    $::g_configuration_file = ($ec->getProperty( "configuration_file" ))->findvalue('//value')->string_value;
    $::g_chef_server_url = ($ec->getProperty( "chef_server_url" ))->findvalue('//value')->string_value;
    $::g_node_name = ($ec->getProperty( "node_name" ))->findvalue('//value')->string_value;
    $::g_replace_current_run_list = ($ec->getProperty( "replace_current_run_list" ))->findvalue('//value')->string_value;
    $::g_json_attributes_definition = ($ec->getProperty( "json_attributes_definition" ))->findvalue('//value')->string_value;
    $::g_daemonize = ($ec->getProperty( "daemonize" ))->findvalue('//value')->string_value;
    $::g_interval = ($ec->getProperty( "interval" ))->findvalue('//value')->string_value;
    $::g_log_level = ($ec->getProperty( "log_level" ))->findvalue('//value')->string_value;
    $::g_additional_commands = ($ec->getProperty( "additional_commands" ))->findvalue('//value')->string_value;
    
    #Variable that stores the command to be executed
    $::g_command = $::g_chef_client_path;

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure RunChefClient\n";
    
    #Parameters are checked to see which should be included
    if($::g_node_name && $::g_node_name ne '')
    {
        $::g_command = $::g_command . " --node-name " . $::g_node_name;
    }
    
    if($::g_replace_current_run_list && $::g_replace_current_run_list ne '')
    {
        $::g_command = $::g_command . " --override-runlist " . $::g_replace_current_run_list;
    }
    
    if($::g_json_attributes_definition && $::g_json_attributes_definition ne '')
    {
        $::g_command = $::g_command . " --json-attributes " . $::g_json_attributes_definition;
    }
    
    if($::g_chef_server_url && $::g_chef_server_url ne '')
    {
        $::g_command = $::g_command . " --server " . $::g_chef_server_url;
    }
    
    if($::g_configuration_file && $::g_configuration_file ne '')
    {
        $::g_command = $::g_command . " --config " . $::g_configuration_file;
    }
    
    if($::g_interval && $::g_interval ne '')
    {
        $::g_command = $::g_command . " --interval " . $::g_interval;
    }
    
    if($::g_log_level && $::g_log_level ne '')
    {
        $::g_command = $::g_command . " --log_level " . $::g_log_level;
    }
    
    if($::g_log_file_location && $::g_log_file_location ne '')
    {
        $::g_command = $::g_command . " --logfile " . $::g_log_file_location;
    }
    
    if($::g_daemonize && $::g_daemonize ne '')
    {
        $::g_command = $::g_command . " --daemonize";
    }
    
    if($::g_additional_commands && $::g_additional_commands ne '')
    {
        $::g_command = $::g_command . " " . $::g_additional_commands;
    }

    #Print out the command to be executed
    print "\nCommand to be executed: \n$::g_command \n\n";
    
    #Executes the command
    system("$::g_command");
}
  
main();
