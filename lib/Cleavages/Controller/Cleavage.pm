package Cleavages::Controller::Cleavage;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

sub cleavage_base : Chained('/language') PathPart('cleavage') CaptureArgs(0) {
    my ($self, $c) = @_;
    return;
}

sub index :Chained('cleavage_base') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    $c->detach('no_cleavage');
}

sub no_cleavage : Chained('cleavage_base') PathPart('none') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{template} = 'cleavage/none';
    return;
}

sub top_cleavage : Chained('cleavage_base') PathPart('top') Args(0) {
    my ($self,$c) = @_;
    $c->stash->{top_rated} = $c->model('Cleavages::File')->top_rated();
    # if we don't have a template ... show "main page"
    $c->stash->{template} ||= 'index';
    return;
}

sub random_cleavage : Chained('cleavage_base') PathPart('random') Args(0) {
    my ($self, $c) = @_;

    # pick a random file
    my $file = $c->model('Cleavages::File')->random_file;
    # make sure we have one (that we're not in the terrible position of having
    # no files)
    if (not defined $file) {
        $c->detach('no_cleavage');
    }

    # if we have a previously rated image, make sure we pick something
    # different
    if (
        exists $c->session->{last_rated_file}
            and
        ($file->id == $c->session->{last_rated_file}->id)
            and
        ($c->model('Cleavages::File')->count > 1)
    ) {
        # log that we hit two-in-a-row
        $c->log->info(
              q{Just rated this image. [id=}
            . $file->id
            . q{] Choosing another.}
        );
        # pick another (random) image
        $c->forward(
            q{random_cleavage}
        );
    }

    # do the work we do for a specified file
    $c->detach(
        'rate_cleavage',
        [ $file->md5_hex ]
    );

    # we shouldn't get here
    return;
}

sub upload : Chained('cleavage_base') PathPart('upload') Args(0) {
    my ($self,$c) = @_;
    $c->detach('/upload/cleavage');
    return;
}

__PACKAGE__->meta->make_immutable;

1;
