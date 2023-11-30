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
    $::g_knife_path = ($ec->getProperty( "knife_path" ))->findvalue('//value')->string_value;
    $::g_configuration_file = ($ec->getProperty( "configuration_file" ))->findvalue('//value')->string_value;
    $::g_chef_server_url = ($ec->getProperty( "chef_server_url" ))->findvalue('//value')->string_value;
    $::g_cookbook_name = ($ec->getProperty( "cookbook_name" ))->findvalue('//value')->string_value;
    $::g_cookbook_version = ($ec->getProperty( "cookbook_version" ))->findvalue('//value')->string_value;
    $::g_force = ($ec->getProperty( "force" ))->findvalue('//value')->string_value;
    $::g_verbose = ($ec->getProperty( "verbose" ))->findvalue('//value')->string_value;
    $::g_file_name = ($ec->getProperty( "file_name" ))->findvalue('//value')->string_value;
    $::g_download_directory = ($ec->getProperty( "download_directory" ))->findvalue('//value')->string_value;
    
    #Variable that stores the command to be executed
    $::g_command = $::g_knife_path . " cookbook site download";

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure DownloadCookbookFromRespository\n";
    
    #Parameters are checked to see which should be included
    
    if($::g_cookbook_name && $::g_cookbook_name ne '')
    {
        $::g_command = $::g_command . " " . $::g_cookbook_name;
    }
    
    if($::g_cookbook_version && $::g_cookbook_version ne '')
    {
        $::g_command = $::g_command . " " . $::g_cookbook_version;
    }
    
    if($::g_chef_server_url && $::g_chef_server_url ne '')
    {
        $::g_command = $::g_command . " --server-url " . $::g_chef_server_url;
    }
    
    if($::g_configuration_file && $::g_configuration_file ne '')
    {
        $::g_command = $::g_command . " --config " . $::g_configuration_file;
    }
    
    if($::g_force && $::g_force ne '')
    {
        $::g_command = $::g_command . " --force";
    }
    
    if($::g_verbose && $::g_verbose ne '')
    {
        $::g_command = $::g_command . " --verbose";
    }
    
    if($::g_file_name && $::g_file_name ne '')
    {
        $::g_command = $::g_command . " --file " . $::g_file_name . ".tar.gz";
    }
    
    #Changes the current directory in order to download the cookbook to the specified location
    if($::g_download_directory && $::g_download_directory ne '')
    {        
        chdir("$::g_download_directory") or die "Cant chdir to $::g_download_directory $!";
    }

    #Print out the command to be executed
    print "\nCommand to be executed: \n$::g_command \n\n";
    
    #Executes the command
    system("$::g_command");
    # To get exit code of process shift right by 8
    my $exitCode = $? >> 8;
    # Set outcome
    setOutcomeFromExitCode($ec, $exitCode);
}
  
main();
