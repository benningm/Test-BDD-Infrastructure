package Test::BDD::Infrastructure::Config::Facter;

use Moose;

# ABSTRACT: configuration class for Test::BDD::Infrastructure
# VERSION

extends 'Test::BDD::Infrastructure::Config::Hash';

use IPC::Run;
use JSON;

has 'command' => ( is => 'ro', isa => 'ArrayRef[Str]',
	default => sub { [ 'facter', '--json' ] },
);

has 'config' => ( is => 'rw', lazy => 1, isa => 'HashRef',
	default => sub {
		my $self = shift;
		my ( $in, $out, $err );
		IPC::Run::run($self->command, \$in, \$out, \$err )
			or die("error running facter: $err");
		my $data = from_json( $out );
		return( $data );
	},
);

1;

