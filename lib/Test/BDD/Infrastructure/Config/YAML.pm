package Test::BDD::Infrastructure::Config::YAML;

use Moose;

# ABSTRACT: configuration class for Test::BDD::Infrastructure
# VERSION

extends 'Test::BDD::Infrastructure::Config::Hash';

use YAML;

has 'file' => ( is => 'ro', isa => 'Str', required => 1 );

has 'config' => ( is => 'rw', lazy => 1, isa => 'HashRef',
	default => sub {
		my $self = shift;
		return YAML::LoadFile( $self->file );
	},
);

1;

