package Test::BDD::Infrastructure::Config;

use MooseX::Singleton;

# VERSION
# ABSTRACT: configuration variables support for Test::BDD::Infrastructure

use Test::BDD::Infrastructure::Config::YAML;

has '_configs' => (
	is => 'ro', isa => 'HashRef', lazy => 1,
	default => sub { {} },
	traits => [ 'Hash' ],
	handles => {
		register_config => 'set',
		unregister_config => 'delete',
		clear_all_configs => 'clear',
	},
);

sub load_config {
	my ( $self, $file ) = @_;
	$self->register_config(
		'c' => Test::BDD::Infrastructure::Config::YAML->new(
			file => $file,
		)
	);
	return;
}

sub get_node {
	my ( $self, $scope, $path ) = @_;
	if( ! defined $self->_configs->{$scope} ) {
		die('no configuration loaded for "'.$scope.'"');
	}
	return $self->_configs->{$scope}->get_node( $path );
}

sub get {
	my ( $self, $scope, $path ) = @_;
	if( ! defined $self->_configs->{$scope} ) {
		die('no configuration loaded for "'.$scope.'"');
	}
	return $self->_configs->{$scope}->get( $path );
}

1;

