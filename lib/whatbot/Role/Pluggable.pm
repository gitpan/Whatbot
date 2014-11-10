###########################################################################
# Pluggable.pm
# the whatbot project - http://www.whatbot.org
###########################################################################

use MooseX::Declare;
use Method::Signatures::Modifiers;

=head1 NAME

whatbot::Role::Pluggable - Role to provide Pluggable.

=head1 SYNOPSIS

 class whatbot::Foo with whatbot::Role::Pluggable {
	 has 'search_base' => ( is => 'ro', default => 'whatbot::Foo' );

	 method foo {
		 foreach my $plugin ( $self->plugins ) {
			 # do something
		 }
	 }
 }

=head1 DESCRIPTION

whatbot::Role::Pluggable solves a strange problem where Module::Pluggable does
not create the plugins sub in MooseX::Declare, likely due to autoclean. Instead,
we create this role to use Module::Pluggable::Object to get the plugin list, and
provide a 'plugins' method to return the same data as Module::Pluggable. This
implementation does not instantiate any of the classes, only returns the class
names.

Consumers of this role need to define a 'search_base' accessor to give M::P the
root class name to search from.

=head1 METHODS

=over 4

=cut

role whatbot::Role::Pluggable {
	use Module::Pluggable::Object;

	requires 'search_base';

=item plugins()

Returns an array of class names from @INC.

=cut

	method plugins() {
		my $o = Module::Pluggable::Object->new( package => __PACKAGE__ );
		$o->{'search_path'} = $self->search_base;
		return $o->plugins;
	}
}

1;

=pod

=back

=head1 LICENSE/COPYRIGHT

Be excellent to each other and party on, dudes.

=cut
