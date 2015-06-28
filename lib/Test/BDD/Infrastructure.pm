package Test::BDD::Infrastructure;

use strict;
use warnings;

use Test::BDD::Infrastructure::File;
use Test::BDD::Infrastructure::Process;
use Test::BDD::Infrastructure::HTTP;
use Test::BDD::Infrastructure::Compare;

# VERSION
# ABSTRACT: a collection of step file definitions for Test Driven Infrastructure

=head1 Description

This is a collection of generic step definitions for infrastructure testing
with Test::BDD::Cucumber.

=head1 Example

First include the steps from a step_file:

  # features/step_files/00use_steps.pl
  use Test::BDD::Infrastructure;

Or just include individual steps:

  # features/step_files/00use_steps.pl
  use Test::BDD::Infrastructure::File;
  use Test::BDD::Infrastructure::HTTP;
  use Test::BDD::Infrastructure::Process;

Then define features of your infrastructure:

  # features/webserver.feature
  Feature: Example application is running on a webserver
  For the example application to work it is necessary that the webserver
  is configured and running.

  Scenario: The webserver process must be running
  Given a parent process like ^/usr/sbin/apache2.prefork is running
  Then the uid of the process must be root
  And the gid of the process must be root
  And the RSS size of the process must be smaller than 32 megabyte
  When there are at least 5 child processes like ^/usr/sbin/apache2.prefork
  Then the uid of the child processes must be www-data
  And the gid of the child processes must be www-data
  And the RSS size of the child processes must be smaller than 64 megabyte

  Scenario: The start page of the webserver must be accessible
  Given the http URL http://www.example.mydomain.de/
  When the http request is sent
  Then the http response must be successfull
  And the http response header Content-Type must be like text/html
  And the http response content must be like Welcome to Example

  Scenario: The webserver must log access
  Given the file /var/log/apache2/access.log exists
  Then the file mode must be 0640
  And the file must be owned by user root
  And the file must be owned by group adm
  And the file must contain at least 1 line
  And the file mtime must be newer than 5 minutes

=head1 See also

=over

=item Test::BDD::Cucumber

The perl cucumber implementation.

=item Test::BDD::Cucumber::Harness::Nagios

Report your test results to nagios for monitoring.

=item Test::BDD::Cucumber::Harness::Html

Generate HTML reports for your documentation, meetings etc.

=back

=cut

1;
