package Cleavages::Controller::Root;
use Moose;
    extends 'Catalyst::Controller::Validation::DFV';
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
__PACKAGE__->config(namespace => '');

# all controller chain bases should hang off of here
sub language : Chained('/') PathPart('') CaptureArgs(0) {
    my ($self, $c, $language) = @_;
    $c->stash(language => 'en');
}

sub index :Chained('language') :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->forward('/cleavage/top_cleavage');
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->status(404);
    # TODO error template
    $c->stash->{template} = 'error/404';
}

sub render : ActionClass('RenderView') {
    my ($self, $c) = @_;

    # if we have any error(s) in the stash, automatically show the error page
    if (defined $c->stash->{error}) {
        $c->stash->{template} = 'error/simple';
        $c->log->error( $c->stash->{error}{message} );
    }
}

sub end : Private {
    my ($self, $c) = @_;
    $c->forward('render');
    $c->forward('refill_form'); # from Catalyst::Controller::Validation::DFV
}

=head1 AUTHOR

Chisel,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
