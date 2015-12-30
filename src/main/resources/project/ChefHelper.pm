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
package ChefHelper;
# -------------------------------------------------------------------------
# Includes
# -------------------------------------------------------------------------
use strict;
use warnings;
use ElectricCommander;
use Exporter 'import';
our @EXPORT = qw(setOutcomeFromExitCode maskPassword);

$|=1;

###########################################################################
=head2 setOutcomeFromExitCode
  Title    : setOutcomeFromExitCode
  Usage    : setOutcomeFromExitCode($exitCode);
  Function : Set outcome based on exit code
  Returns  :
  Args     : named arguments: ElectricCommander object, exitCode
=cut
###########################################################################

sub setOutcomeFromExitCode {

  my ($ec, $exitCode) = @_;
  print "chef returned exit code: $exitCode\n";

  if ( $exitCode == 0 ) {
    print "Success.\n";
  } else {
    $ec->setProperty("outcome","error");
  }
}

sub maskPassword {
    my ($line, $password) = @_;
    return $line unless defined $password && length($password);

    $line =~ s/-password $password/-password ****/;
    return $line;
}

1;
