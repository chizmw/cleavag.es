package Cleavages::Controller::Cleavage;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub base : Chained('/language') PathPart('cleavage') CaptureArgs(0) {
    my ($self, $c) = @_;
    return;
}

sub index :Chained('base') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    $c->detach('no_cleavage');
}

sub no_cleavage : Chained('base') PathPart('none') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{template} = 'cleavage/none';
    return;
}

sub top_cleavage : Chained('base') PathPart('top') Args(0) {
    my ($self,$c) = @_;
    $c->stash->{top_rated} = $c->model('Cleavages::File')->top_rated();
    # if we don't have a template ... show "main page"
    $c->stash->{template} ||= 'index';
    return;
}


__PACKAGE__->meta->make_immutable;

1;
