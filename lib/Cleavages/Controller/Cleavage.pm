package Cleavages::Controller::Cleavage;
# vim: ts=8 sts=4 et sw=4 sr sta
use strict;
use warnings;
use parent 'Catalyst::Controller';

our $CLEAVAGE_RE = qr<[-_\./0-9a-fA-F]+>;

use Cleavages::DFV qw< :constraints >;
use Data::FormValidator::Constraints qw(:closures :regexp_common);

use base 'Catalyst::Controller::Validation::DFV';
use base 'Cleavages::ControllerBase::FormValidation';

my %dfv_profile_for = (
    rating => {
        required => [qw<
            cleavage_rating
            file_md5
        >],

        filters => 'trim',

        constraint_methods => {
            cleavage_rating => [
                # ratings are integers
                FV_num_int(),
                # ... from 1 to 10 (inclusive)
                constraint_in_range(
                    { fields => [qw/1 10/] },
                    'rating-out-of-range',
                ),
            ],
        },
    },
);

sub base : Chained('/language') PathPart('cleavage') CaptureArgs(0) { 
    my ($self, $c) = @_;
    return;
}

sub index :Chained('base') PathPart('') Args(0) {
    my ( $self, $c ) = @_;
    $c->detach('random_cleavage');
}

sub cleavage_file : Regex('^cleavage/show/([-_\./0-9a-zA-z]+)$') {
    my ( $self, $c ) = @_;
    my $rel_path = $c->request->captures->[0];

    # get the file contents
    my $body = $c->model('FS::Cleavage')->slurp( $rel_path );
    # deal with cases where the file doesn't actually exist
    if (not defined $body) {
        $c->response->status('404');
        $c->response->body(
            qq{$rel_path: file not found}
        );
        return;
    }

    # serve via /static
    $c->response->redirect(
        $c->uri_for(
                q{/static/cleavage/}
            . $rel_path
        )
    );

    return;
}

sub no_cleavage : Chained('base') PathPart('none') Args(0) {
    my ($self, $c) = @_;
    $c->stash->{template} = 'cleavage/none';
    return;
}

sub random_cleavage : Chained('base') PathPart('random') Args(0) {
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

sub rate_index : Chained('base') PathPart('rate') Args(0) {
    my ($self, $c) = @_;

    # pick a random file
    $c->forward(
        'random_cleavage',
    );

    return;
}

sub rate_cleavage : Chained('base') PathPart('rate') Args(1) {
    my ($self, $c, $file_ref) = @_;
    $c->stash->{template} = 'cleavage/rate_cleavage';

    # fetch the file
    my $file = $c->model('Cleavages::File')->find(
        {
            md5_hex => $file_ref,
        }
    );

    # are we attempting to rate something?
    if (
        q{POST} eq $c->request->method
            and
        keys %{$c->request->body_parameters}
    ) {
        # check the submitted values
        $c->forward('form_check', [$dfv_profile_for{rating}]);
        # if the form data was valid
        if ($c->stash->{validation}->success) {
            # add the new rating
            $c->model('Cleavages::File')->add_rating(
                {
                    file    => $c->stash->{validation}->valid('file_md5'),
                    rating  => $c->stash->{validation}->valid('cleavage_rating'),
                    ip_addr => $c->request->address,
                }
            );

            # remember what we rated
            $c->session->{last_rated_file}          = $file;
            # XXX don't know why this barfs in template
            $c->session->{last_rated_file_summary}  = $c->session->{last_rated_file}->rating_summary;

            # redirect to lose the POST and prevent reloads
            # (yeah, can't stop back+reload ... yet)
            $c->response->redirect(
                $c->uri_for(
                    q{/cleavage/random}
                )
            );
        }
    }

    # all's well if we find the file
    if (defined $file) {
        # make sure we can find the file in the local filesystem
        my $file_fs = $c->model('FS::Cleavage')->file( $file->filepath );
        if (not $file_fs) {
            die "where's the damn file?";
        }

        # put useful stuff in the stash
        $c->stash->{file}       = $file;
        $c->stash->{file_fs}    = $file_fs;
        $c->stash->{formdata}{file_md5}   = $file->md5_hex;
        return;
    }

    die "unknown cleavage";
}

sub top_cleavage : Chained('base') PathPart('top') Args(0) {
    my ($self,$c) = @_;
    $c->stash->{top_rated} = $c->model('Cleavages::File')->top_rated();
    # if we don't have a template ... show "main page"
    $c->stash->{template} ||= 'index';
    return;
}

sub upload : Chained('base') PathPart('upload') Args(0) {
    my ($self,$c) = @_;
    $c->detach(
        '/upload/cleavage',
    );
    return;
}

1;
__END__

=head1 NAME

Cleavages::Controller::Cleavage - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=head2 index 

=head1 AUTHOR

Chisel Wright

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
