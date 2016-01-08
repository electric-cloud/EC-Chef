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
    my $node_ip =
      ( $ec->getProperty("node_ip") )->findvalue('//value')->string_value;
    my $forward_agent =
      ( $ec->getProperty("forward_agent") )->findvalue('//value')->string_value;

    #may not be used in the same command with --bootstrap-install-command.
    my $bootstrap_curl_options =
      ( $ec->getProperty("bootstrap_curl_options") )->findvalue('//value')
      ->string_value;
    my $bootstrap_install_command =
      ( $ec->getProperty("bootstrap_install_command") )->findvalue('//value')
      ->string_value;
    my $bootstrap_install_sh =
      ( $ec->getProperty("bootstrap_install_sh") )->findvalue('//value')
      ->string_value;
    my $bootstrap_proxy =
      ( $ec->getProperty("bootstrap_proxy") )->findvalue('//value')
      ->string_value;
    my $bootstrap_no_proxy =
      ( $ec->getProperty("bootstrap_no_proxy") )->findvalue('//value')
      ->string_value;
    my $bootstrap_vault_file =
      ( $ec->getProperty("bootstrap_vault_file") )->findvalue('//value')
      ->string_value;
    my $bootstrap_vault_item =
      ( $ec->getProperty("bootstrap_vault_item") )->findvalue('//value')
      ->string_value;
    my $bootstrap_vault_json =
      ( $ec->getProperty("bootstrap_vault_json") )->findvalue('//value')
      ->string_value;
    my $bootstrap_version =
      ( $ec->getProperty("bootstrap_version") )->findvalue('//value')
      ->string_value;
    my $bootstrap_wget_options =
      ( $ec->getProperty("bootstrap_wget_options") )->findvalue('//value')
      ->string_value;
    my $environment =
      ( $ec->getProperty("environment") )->findvalue('//value')->string_value;
    my $ssh_gateway =
      ( $ec->getProperty("ssh_gateway") )->findvalue('//value')->string_value;
    my $hint = ( $ec->getProperty("hint") )->findvalue('//value')->string_value;
    my $identify_file =
      ( $ec->getProperty("identify_file") )->findvalue('//value')->string_value;
    my $json_attribute =
      ( $ec->getProperty("json_attribute") )->findvalue('//value')
      ->string_value;
    my $node_name =
      ( $ec->getProperty("node_name") )->findvalue('//value')->string_value;
    my $host_key_verify =
      ( $ec->getProperty("host_key_verify") )->findvalue('//value')
      ->string_value;
    my $prerelease =
      ( $ec->getProperty("prerelease") )->findvalue('//value')->string_value;
    my $ssh_port =
      ( $ec->getProperty("ssh_port") )->findvalue('//value')->string_value;
    my $run_list =
      ( $ec->getProperty("run_list") )->findvalue('//value')->string_value;
    my $secret =
      ( $ec->getProperty("secret") )->findvalue('//value')->string_value;
    my $secret_file =
      ( $ec->getProperty("secret_file") )->findvalue('//value')->string_value;
    my $sudo = ( $ec->getProperty("sudo") )->findvalue('//value')->string_value;
    my $template =
      ( $ec->getProperty("template") )->findvalue('//value')->string_value;
    my $use_sudo_password =
      ( $ec->getProperty("use_sudo_password") )->findvalue('//value')
      ->string_value;
    my $v = ( $ec->getProperty("v") )->findvalue('//value')->string_value;
    my $node_verify_api_cert =
      ( $ec->getProperty("node_verify_api_cert") )->findvalue('//value')
      ->string_value;
    my $node_ssl_verify_mode =
      ( $ec->getProperty("node_ssl_verify_mode") )->findvalue('//value')
      ->string_value;
    my $additional_options =
      ( $ec->getProperty("additional_options") )->findvalue('//value')
      ->string_value;
    $ec->abortOnError(1);

    #Variable that stores the command to be executed
    my $command = $knife_path . " bootstrap";

    my @cmd;
    my %props;

    #Prints procedure and parameters information
    my $pluginKey  = 'EC-Chef';
    my $xpath      = $ec->getPlugin($pluginKey);
    my $pluginName = $xpath->findvalue('//pluginVersion')->value;
    print "Using plugin $pluginKey version $pluginName\n";
    print "Running procedure Bootstrap\n";

    my $ssh_creds_path =  $ec->getFullCredential( 'ssh_credential' );
    my $userName = $ssh_creds_path->findvalue("//userName");
    my $password = $ssh_creds_path->findvalue("//password");
    if ( defined $userName && "$userName" eq "" ) {
        print "Empty username found in '"
          . $ssh_creds_path
          . "' credential object.\n";
    }
    else
    {
        $command = $command . " --ssh-user" . " " . $userName;
    }

    if ( defined $password && "$password" eq "" ) {
        print "Empty password found in '"
          . $ssh_creds_path
          . "' credential object.\n";
    }
    else
    {
        $command = $command . " --ssh-password" . " " . $password;
    }

    #Parameters are checked to see which should be included

    if ( $node_ip && $node_ip ne '' ) {
        $command = $command . " " . $node_ip;
    }

    if ( $forward_agent && $forward_agent ne '' ) {
        $command = $command . " --forward-agent";
    }

    if ( $bootstrap_curl_options && $bootstrap_curl_options ne '' ) {
        $command =
            $command
          . " --bootstrap-curl-options" . " "
          . $bootstrap_curl_options;
    }

    if ( $bootstrap_curl_options && $bootstrap_curl_options ne '' ) {
        $command =
            $command
          . " --bootstrap-curl-options" . " "
          . $bootstrap_curl_options;
    }

    if ( $bootstrap_install_command && $bootstrap_install_command ne '' ) {
        $command =
            $command
          . " --bootstrap-install-command" . " "
          . $bootstrap_install_command;
    }

    if ( $bootstrap_install_sh && $bootstrap_install_sh ne '' ) {
        $command =
          $command . " --bootstrap-install-sh" . " " . $bootstrap_install_sh;
    }

    if ( $bootstrap_proxy && $bootstrap_proxy ne '' ) {
        $command = $command . " --bootstrap-proxy" . " " . $bootstrap_proxy;
    }

    if ( $bootstrap_no_proxy && $bootstrap_no_proxy ne '' ) {
        $command =
          $command . " --bootstrap-no-proxy" . " " . $bootstrap_no_proxy;
    }

    if ( $bootstrap_vault_file && $bootstrap_vault_file ne '' ) {
        $command =
          $command . " --bootstrap-vault-file" . " " . $bootstrap_vault_file;
    }

    if ( $bootstrap_vault_item && $bootstrap_vault_item ne '' ) {
        $command =
          $command . " --bootstrap-vault-file" . " " . $bootstrap_vault_item;
    }

    if ( $bootstrap_vault_json && $bootstrap_vault_json ne '' ) {
        $command =
          $command . " --bootstrap-vault-json" . " " . $bootstrap_vault_json;
    }

    if ( $bootstrap_version && $bootstrap_version ne '' ) {
        $command = $command . " --bootstrap-version" . " " . $bootstrap_version;
    }

    if ( $bootstrap_wget_options && $bootstrap_wget_options ne '' ) {
        $command =
            $command
          . " --bootstrap-wget-options" . " "
          . $bootstrap_wget_options;
    }

    if ( $environment && $environment ne '' ) {
        $command = $command . " --environment" . " " . $environment;
    }

    if ( $ssh_gateway && $ssh_gateway ne '' ) {
        $command = $command . " --ssh-gateway" . " " . $ssh_gateway;
    }

    if ( $hint && $hint ne '' ) {
        $command = $command . " --hint" . " " . $hint;
    }

    if ( $identify_file && $identify_file ne '' ) {
        $command = $command . " --identity-file" . " " . $identify_file;
    }

    if ( $json_attribute && $json_attribute ne '' ) {
        $command = $command . " --json-attributes" . " " . $json_attribute;
    }

    if ( $node_name && $node_name ne '' ) {
        $command = $command . " --node-name" . " " . $node_name;
    }

    if ( $host_key_verify && $host_key_verify ne '' ) {
        $command = $command . " --no-host-key-verify";
    }

    if ( $node_verify_api_cert && $node_verify_api_cert ne '' ) {
        $command = $command . " --no-node-verify-api-cert";
    }

    if ( $node_ssl_verify_mode && $node_ssl_verify_mode ne '' ) {
        $command =
          $command . " --node-ssl-verify-mode" . " " . $node_ssl_verify_mode;
    }

    if ( $ssh_port && $ssh_port ne '' ) {
        $command = $command . " --ssh-port" . " " . $ssh_port;
    }

    if ( $prerelease && $prerelease ne '' ) {
        $command = $command . " --prerelease";
    }

    if ( $run_list && $run_list ne '' ) {
        $command = $command . " --run-list" . " " . $run_list;
    }

    if ( $secret && $secret ne '' ) {
        $command = $command . " --secret" . " " . $secret;
    }

    if ( $secret_file && $secret_file ne '' ) {
        $command = $command . " --secret-file" . " " . $secret_file;
    }

    if ( $sudo && $sudo ne '' ) {
        $command = $command . " --sudo";
    }

    if ( $template && $template ne '' ) {
        $command = $command . " --bootstrap-template" . " " . $template;
    }

    if ( $use_sudo_password && $use_sudo_password ne '' ) {
        $command = $command . " --use-sudo-password";
    }

    if ( $v && $v ne '' ) {
        $command = $command . " -V -V" . " " . $v;
    }

    if ( $additional_options && $additional_options ne '' ) {
        $command = $command . " " . $additional_options;
    }

    #Print out the command to be executed
    my $escapedCmdLine = maskPassword( $command, $password );
    print "\nCommand to be executed: \n$escapedCmdLine \n\n";

    #Executes the command
    system("$command");
    # To get exit code of process shift right by 8
    my $exitCode = $? >> 8;
    # Set outcome
    setOutcomeFromExitCode($ec, $exitCode);
}

main();
