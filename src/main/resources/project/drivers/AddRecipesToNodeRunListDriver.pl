# -------------------------------------------------------------------------
# Package
#    AddRecipesToNodeRunListDriver.pl
#
# Dependencies
#    None
#
# Purpose
#    Perl script add recipes to the node run list
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
package AddRecipesToNodeRunListDriver;


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
    $::g_node_name = ($ec->getProperty( "node_name" ))->findvalue('//value')->string_value;
    $::g_run_list_items = ($ec->getProperty( "run_list_items" ))->findvalue('//value')->string_value;
    $::g_verbose = ($ec->getProperty( "verbose" ))->findvalue('//value')->string_value;
    $::g_after_item = ($ec->getProperty( "after_item" ))->findvalue('//value')->string_value;
    
    #Variable that stores the command to be executed
    $::g_command = $::g_knife_path . " node run_list add";

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure AddRecipesToNodeRunList\n";
    
    #Parameters are checked to see which should be included
    if($::g_node_name && $::g_node_name ne '')
    {
        $::g_command = $::g_command . " " . $::g_node_name;
    }
    
    if($::g_run_list_items && $::g_run_list_items ne '')
    {
        $::g_command = $::g_command . " " . $::g_run_list_items;
    }
    
    if($::g_chef_server_url && $::g_chef_server_url ne '')
    {
        $::g_command = $::g_command . " --server-url " . $::g_chef_server_url;
    }
    
    if($::g_configuration_file && $::g_configuration_file ne '')
    {
        $::g_command = $::g_command . " --config " . $::g_configuration_file;
    }
    
    
    if($::g_verbose && $::g_verbose ne '')
    {
        $::g_command = $::g_command . " --verbose";
    }
    
    if($::g_after_item && $::g_after_item ne '')
    {
        $::g_command = $::g_command . " --after " . $::g_after_item;
    }
    
    #Print out the command to be executed
    print "\nCommand to be executed: \n$::g_command \n\n";
    
    #Executes the command
    system("$::g_command");
}
  
main();
