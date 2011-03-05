package Cleavages::Controller::Root;
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
use warnings;
use parent 'Catalyst::Controller';

use base 'Catalyst::Controller::Validation::DFV';

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config->{namespace} = '';

=head1 NAME

Cleavages::Controller::Root - Root Controller for Cleavages

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=cut

=head2 index

=cut

# all controller chain bases should hang off of here
sub language : Chained('/') PathPart('') CaptureArgs(0) {
    my ($self, $c, $language) = @_;
    $c->stash(language => 'en');
}

sub index : Chained('language') PathPart('') :Args(0) {
    my ( $self, $c ) = @_;

    $c->forward('/cleavage/top_cleavage');

    return;
}

sub app_root : Chained PathPart('') Args(0) {
    my ($self, $c) = @_;
    # redirect to the default action
    $c->response->redirect( $c->uri_for($c->config->{default_uri}) );
}

sub default :Path {
    my ( $self, $c ) = @_;
    #$c->response->body( 'Page not found' );
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

#    if (has_died($c)) {
#        $c->stash->{template} = 'error/simple';
#        $c->log->error( @{ $c->stash->{view}{error}{messages} } );
#    }
}

sub end : Private {
    my ($self, $c) = @_;

    # render the page
    $c->forward('render');

    # fill in any forms
    $c->forward('refill_form'); # from Catalyst::Controller::Validation::DFV
}


=head2 end

Attempt to render a view, if needed.

=cut 

#sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Chisel Wright

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
