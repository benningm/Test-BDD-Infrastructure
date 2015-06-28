package Test::BDD::Infrastructure::Config::Augeas;

use Moose;

# ABSTRACT: configuration class for Test::BDD::Infrastructure
# VERSION

use Config::Augeas;

has 'root' => ( is => 'ro', isa => 'Str', default => '/' );

has '_aug' => (
	is => 'ro', isa => 'Config::Augeas', lazy => 1,
	default => sub {
		my $self = shift;
		return Config::Augeas->new(
			root => $self->root,
		);
	},
	handles => {
		'get' => 'get',
		'get_node' => 'match',
	},
);

1;

