package Test::BDD::Infrastructure::Exec;

use strict;
use warnings;

# VERSION
# ABSTRACT: cucumber step definitions for checking commands
 
use Test::More;
use Test::BDD::Cucumber::StepFile qw( Given When Then );

sub S { Test::BDD::Cucumber::StepFile::S }

use Test::BDD::Infrastructure::Utils qw(
	convert_unit convert_cmp_operator $CMP_OPERATOR_RE convert_interval);

use IPC::Run qw( run timeout );

=head1 Synopsis

=head1 Step definitions

=cut

# try to set neutral locale
our %DEFAULT_ENV = (
  LANG => 'C',
  LC_ALL => 'C',
);

Given qr/^the command is (.*)$/, sub {
  my @cmd = split(/\s+/, $1);
  if( ! -x $cmd[0] ) {
    fail( $cmd[0]." is not exist or is not executable");
  }
  S->{'cmd'} = \@cmd;
};

Given qr/^the command (?:option|parameter) (.*) is appended$/, sub {
  push(@{S->{'cmd'}}, $1);
};

Given qr/^the commands? timeout is (?:set to )?(\d+)(?: seconds)?$/, sub {
  S->{'timeout'} = $1;
};

Given qr/^the commands? environment variable (\S+) is set to (.*)$/, sub {
  if( ! defined S->{'env'} ) {
    S->{'env'} = { %DEFAULT_ENV }
  }
  S->{'env'}->{$1} = $2;
};

Given qr/^the commands? working directory is (.*)$/, sub {
  if( ! -e $1 ) {
    fail("directory $1 does no exist");
  }
  S->{'cwd'} = $1;
};

When qr/^the command is (executed|run)/, sub {
  my $timeout = S->{'timeout'} || 10;
  my $myenv = S->{'env'} || { %DEFAULT_ENV };
  my $cwd = S->{'cwd'};
  my $cmd = S->{'cmd'};
  my ( $in, $out, $err );

  run $cmd,
    init => sub {
      if( defined $cwd ) { chdir( $cwd ); }
      @$ENV{keys %$myenv} = values %$myenv;
    }, \$in, \$out, \$err, timeout( $timeout );

  S->{'ret'} = $?;
  S->{'out'} = $out;
  S->{'err'} = $err;
};

Then qr/^the commands? return value must be (\d+)/, sub {
  cmp_ok(S->{'ret'}, '==', $1, "the return value must be $1");
};
Then qr/^the commands? return value must be $CMP_OPERATOR_RE (\d+)/, sub {
  my $op = convert_cmp_operator( $1 );
  my $count = $2;
  cmp_ok(S->{'ret'}, $op, $1, "the return value must be $op $1");
};

Then qr/^the commands? output must be like (.*)$/, sub {
  my $regex = $1;
  like( S->{'out'}, qr/$regex/, "output must be like $1");
};
Then qr/^the commands? (?:error|stderr) output must be like (.*)$/, sub {
  my $regex = $1;
  like( S->{'err'}, qr/$regex/, "error output must be like $1");
};
Then qr/^the commands? output must be empty$/, sub {
  cmp_ok( S->{'out'}, 'eq', '', "output must be empty");
};
Then qr/^the commands? (?:error|stderr) output must be empty$/, sub {
  cmp_ok( S->{'err'}, 'eq', '', "error output must be empty");
};

1;

