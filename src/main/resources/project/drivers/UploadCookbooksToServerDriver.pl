# -------------------------------------------------------------------------
# Package
#    UploadCookbooksToServerDriver.pl
#
# Dependencies
#    None
#
# Purpose
#    Perl script upload cookbooks to the Chef server
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
package UploadCookbooksToServerDriver;


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
  Function : Runs a manifest into Puppet
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
    $::g_cookbook_names = ($ec->getProperty( "cookbook_names" ))->findvalue('//value')->string_value;
    $::g_all_cookbooks = ($ec->getProperty( "all_cookbooks" ))->findvalue('//value')->string_value;
    $::g_cookbook_paths = ($ec->getProperty( "cookbook_paths" ))->findvalue('//value')->string_value;
    $::g_include_dependencies = ($ec->getProperty( "include_dependencies" ))->findvalue('//value')->string_value;
    $::g_verbose = ($ec->getProperty( "verbose" ))->findvalue('//value')->string_value;
    $::g_additional_commands = ($ec->getProperty( "additional_commands" ))->findvalue('//value')->string_value;
    
    #Variable that stores the command to be executed
    $::g_command = $::g_knife_path . " cookbook upload";

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure UploadCookbooksToServer\n";
    
    #Parameters are checked to see which should be included
    if($::g_all_cookbooks && $::g_all_cookbooks ne '')
    {
        $::g_command = $::g_command . " --all";
    }
    else
    {
        if($::g_cookbook_names && $::g_cookbook_names ne '')
        {
            $::g_command = $::g_command . " " . $::g_cookbook_names;
        }
    }
    
    if($::g_chef_server_url && $::g_chef_server_url ne '')
    {
        $::g_command = $::g_command . " --server-url " . $::g_chef_server_url;
    }
    
    if($::g_configuration_file && $::g_configuration_file ne '')
    {
        $::g_command = $::g_command . " --config " . $::g_configuration_file;
    }
    
    if($::g_cookbook_paths && $::g_cookbook_paths ne '')
    {
        $::g_command = $::g_command . " --cookbook-path " . $::g_cookbook_paths;
    }
    
    if($::g_include_dependencies && $::g_include_dependencies ne '')
    {
        $::g_command = $::g_command . " --include-dependencies";
    }
    
    if($::g_verbose && $::g_verbose ne '')
    {
        $::g_command = $::g_command . " --verbose";
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
