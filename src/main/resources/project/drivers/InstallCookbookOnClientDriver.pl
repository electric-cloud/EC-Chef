# -------------------------------------------------------------------------
# Package
#    InstallCookbookOnClientDriver.pl
#
# Dependencies
#    None
#
# Purpose
#    Perl script install a cookbook from the opscode repository
#
# Date
#    31/06/2012
#
# Engineer
#    Mario Carmona
#
# Copyright (c) 2012 Electric Cloud, Inc.
# All rights reserved
# -------------------------------------------------------------------------
package InstallCookbookOnClientDriver;


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
    $::g_knife_path = ($ec->getProperty( "knife_path" ))->findvalue('//value')->string_value;
    $::g_configuration_file = ($ec->getProperty( "configuration_file" ))->findvalue('//value')->string_value;
    $::g_chef_server_url = ($ec->getProperty( "chef_server_url" ))->findvalue('//value')->string_value;
    $::g_cookbook_name = ($ec->getProperty( "cookbook_name" ))->findvalue('//value')->string_value;
    $::g_cookbook_version = ($ec->getProperty( "cookbook_version" ))->findvalue('//value')->string_value;
    $::g_no_dependencies = ($ec->getProperty( "no_dependencies" ))->findvalue('//value')->string_value;
    $::g_verbose = ($ec->getProperty( "verbose" ))->findvalue('//value')->string_value;
    $::g_cookbooks_path = ($ec->getProperty( "cookbooks_path" ))->findvalue('//value')->string_value;
    $::g_branch_to_work_with = ($ec->getProperty( "branch_to_work_with" ))->findvalue('//value')->string_value;
    
    #Variable that stores the command to be executed
    $::g_command = $::g_knife_path . " cookbook site install";

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure InstallCookbookOnClient\n";
    
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
    
    if($::g_no_dependencies && $::g_no_dependencies ne '')
    {
        $::g_command = $::g_command . " --skip-dependencies";
    }
    
    if($::g_verbose && $::g_verbose ne '')
    {
        $::g_command = $::g_command . " --verbose";
    }
    
    if($::g_cookbooks_path && $::g_cookbooks_path ne '')
    {
        $::g_command = $::g_command . " --cookbook-path " . $::g_cookbooks_path;
    }
    
    if($::g_branch_to_work_with && $::g_branch_to_work_with ne '')
    {
        $::g_command = $::g_command . " --branch " . $::g_branch_to_work_with;
    }
    
    #Print out the command to be executed
    print "\nCommand to be executed: \n$::g_command \n\n";
    
    #Execute the command
    system("$::g_command");
}
  
main();
