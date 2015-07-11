package Test::BDD::Infrastructure::Config;

use MooseX::Singleton;

# VERSION
# ABSTRACT: configuration variables support for Test::BDD::Infrastructure

use Test::BDD::Infrastructure::Config::YAML;

=head1 Description

The module provides a abstraction to retrieve configuration
values from different configuration backends.

=head1 Synopsis

Load a configuration in step_files/00use_steps.pl:

  use Test::BDD::Infrastructure::Config;

  my $c = Test::BDD::Infrastructure::Config->new;
  $c->load_config( dirname(__FILE__)."/config.yaml" );

Or register additional configuration backends:

  use Test::BDD::Infrastructure::Config::Augeas;
  $c->register_config(
    'a' => Test::BDD::Infrastructure::Config::Augeas->new,
  );


In config.yaml:

  web:
    baseurl: http://www.example.tld/
  
Then retrieve the value with:

  $c->get( 'c', 'web/baseurl');

Or to retrieve a value from the Augeas backend:

  $c->get( 'a', '/files/etc/resolv.conf/nameserver');

=head1 Methods

=head2 register_config( $scope, $backend )

Registers a new configuration backend.

=head2 unregister_config( $scope )

Unregisters the backend in $scope.

=head2 clear_all_configs

Unregisters all configuration backends.

=cut

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

=head2 load_config( $file )

This is an alias for loading a YAML file to the scope 'c':

  $config->register_config(
    'c' => Test::BDD::Infrastructure::Config::YAML->new(
      file => $file,
    )
  );

=cut

sub load_config {
	my ( $self, $file ) = @_;
	$self->register_config(
		'c' => Test::BDD::Infrastructure::Config::YAML->new(
			file => $file,
		)
	);
	return;
}

=head2 get_node( $scope, $path )

Retrieve a node within the configuration tree with all
its subentries.

=cut

sub get_node {
	my ( $self, $scope, $path ) = @_;
	if( ! defined $self->_configs->{$scope} ) {
		die('no configuration loaded for "'.$scope.'"');
	}
	return $self->_configs->{$scope}->get_node( $path );
}

=head2 get ( $scope, $path )

Retrieve a configuration value.

=cut

sub get {
	my ( $self, $scope, $path ) = @_;
	if( ! defined $self->_configs->{$scope} ) {
		die('no configuration loaded for "'.$scope.'"');
	}
	return $self->_configs->{$scope}->get( $path );
}

=head1 See also

L<Test::BDD::Infrastructure::Config::YAML>, L<Test::BDD::Infrastructure::Config::Augeas>

=cut

1;

